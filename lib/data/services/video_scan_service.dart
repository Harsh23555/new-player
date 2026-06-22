import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/app_logger.dart';
import '../models/video_model.dart';
import '../models/db/video_entity.dart';
import '../repositories/video_repository.dart';

final videoScanServiceProvider = Provider<VideoScanService>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return VideoScanService(repository: repository);
});

class VideoScanService {
  final VideoRepository _repository;

  static const _supportedFormats = [
    'mp4', 'mkv', 'mov', 'avi', 'webm', 'flv', 'm4v', '3gp', 'ts', 'wmv',
  ];

  VideoScanService({required VideoRepository repository}) : _repository = repository;

  Future<List<VideoModel>> scanAndIndex() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        filterOption: FilterOptionGroup(
          videoOption: const FilterOption(
            durationConstraint: DurationConstraint(
              min: Duration(seconds: 1),
              max: Duration(hours: 24),
            ),
          ),
        ),
      );

      final thumbDir = await _thumbDir();
      final entities = <VideoEntity>[];

      for (final album in albums) {
        final count = await album.assetCountAsync;
        final assets = await album.getAssetListRange(start: 0, end: count);

        for (final asset in assets) {
          final file = await asset.file;
          if (file == null || !file.existsSync()) continue;

          final ext = p.extension(file.path).replaceAll('.', '').toLowerCase();
          if (!_supportedFormats.contains(ext)) continue;

          String? thumbPath;
          try {
            final thumbFile = File(p.join(thumbDir, '${asset.id}.jpg'));
            if (!thumbFile.existsSync()) {
              final thumbData = await asset.thumbnailDataWithSize(
                const ThumbnailSize(320, 180),
                quality: 80,
              );
              if (thumbData != null) {
                await thumbFile.writeAsBytes(thumbData);
              }
            }
            if (thumbFile.existsSync()) thumbPath = thumbFile.path;
          } catch (_) {}

          final durationMs = (asset.duration * 1000).toInt();
          final entity = VideoEntity()
            ..path = file.path
            ..title = p.basenameWithoutExtension(file.path)
            ..duration = _formatDuration(durationMs)
            ..durationMs = durationMs
            ..size = await file.length()
            ..width = asset.width
            ..height = asset.height
            ..thumbnailPath = thumbPath
            ..mimeType = ext
            ..dateAdded = asset.createDateTime
            ..dateModified = asset.modifiedDateTime
            ..playCount = 0
            ..isDownloaded = false;

          entities.add(entity);
        }
      }

      await _repository.upsertAll(entities);
      AppLogger.info('Indexed ${entities.length} video files');
      return _repository.getAll();
    } catch (e, st) {
      AppLogger.error('Video scan failed', error: e, stackTrace: st);
      return [];
    }
  }

  Future<void> addDownloadedVideo(VideoEntity entity) async {
    await _repository.upsert(entity);
  }

  Future<String> _thumbDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory(p.join(dir.path, 'video_thumbs'));
    if (!thumbDir.existsSync()) await thumbDir.create(recursive: true);
    return thumbDir.path;
  }

  String _formatDuration(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
