import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/utils/app_logger.dart';
import '../models/audio_model.dart';
import '../models/db/audio_entity.dart';
import '../repositories/audio_repository.dart';

final audioScanServiceProvider = Provider<AudioScanService>((ref) {
  final repository = ref.watch(audioRepositoryProvider);
  return AudioScanService(repository: repository);
});

class AudioScanService {
  final AudioRepository _repository;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  static const _supportedFormats = [
    'mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'opus', 'wma', 'aiff',
  ];

  AudioScanService({required AudioRepository repository}) : _repository = repository;

  /// Scan device for audio files and store in Isar via Repository
  Future<List<AudioModel>> scanAndIndex() async {
    try {
      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final entities = <AudioEntity>[];
      for (final song in songs) {
        final ext = song.fileExtension?.toLowerCase() ?? '';
        if (!_supportedFormats.contains(ext)) continue;
        if (!File(song.data).existsSync()) continue;
        if (song.duration == null || song.duration == 0) continue;

        final entity = AudioEntity()
          ..path = song.data
          ..title = song.title.isNotEmpty ? song.title : _fileNameWithoutExt(song.data)
          ..artist = song.artist ?? 'Unknown Artist'
          ..album = song.album ?? 'Unknown Album'
          ..genre = song.genre ?? 'Unknown'
          ..duration = song.duration ?? 0
          ..size = song.size
          ..trackNumber = song.track ?? 0
          ..year = 0
          ..mimeType = song.fileExtension
          ..dateAdded = DateTime.fromMillisecondsSinceEpoch(
              (song.dateAdded ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000)
          ..dateModified = DateTime.fromMillisecondsSinceEpoch(
              (song.dateModified ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000)
          ..playCount = 0;

        entities.add(entity);
      }

      await _repository.upsertAll(entities);
      AppLogger.info('Indexed ${entities.length} audio files');
      return _repository.getAll();
    } catch (e, st) {
      AppLogger.error('Audio scan failed', error: e, stackTrace: st);
      return [];
    }
  }

  String _fileNameWithoutExt(String path) {
    final name = path.split('/').last;
    final dot = name.lastIndexOf('.');
    return dot != -1 ? name.substring(0, dot) : name;
  }
}
