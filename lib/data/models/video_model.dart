import 'package:equatable/equatable.dart';
import 'db/video_entity.dart';

class VideoModel extends Equatable {
  final int id;
  final String path;
  final String title;
  final String duration;
  final int durationMs;
  final int size;
  final int width;
  final int height;
  final String? thumbnailPath;
  final String? mimeType;
  final DateTime dateAdded;
  final int playCount;
  final bool isFavorite;
  final bool isDownloaded;

  const VideoModel({
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
    required this.durationMs,
    required this.size,
    required this.width,
    required this.height,
    this.thumbnailPath,
    this.mimeType,
    required this.dateAdded,
    required this.playCount,
    required this.isFavorite,
    required this.isDownloaded,
  });

  factory VideoModel.fromEntity(VideoEntity e) => VideoModel(
        id: e.id,
        path: e.path,
        title: e.title,
        duration: e.duration,
        durationMs: e.durationMs,
        size: e.size,
        width: e.width,
        height: e.height,
        thumbnailPath: e.thumbnailPath,
        mimeType: e.mimeType,
        dateAdded: e.dateAdded,
        playCount: e.playCount,
        isFavorite: e.isFavorite,
        isDownloaded: e.isDownloaded,
      );

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
  }

  String get resolution {
    if (width == 0 && height == 0) return 'Unknown';
    if (height >= 2160) return '4K';
    if (height >= 1080) return '1080p';
    if (height >= 720) return '720p';
    if (height >= 480) return '480p';
    return '${height}p';
  }

  VideoModel copyWith({bool? isFavorite, int? playCount}) => VideoModel(
        id: id,
        path: path,
        title: title,
        duration: duration,
        durationMs: durationMs,
        size: size,
        width: width,
        height: height,
        thumbnailPath: thumbnailPath,
        mimeType: mimeType,
        dateAdded: dateAdded,
        playCount: playCount ?? this.playCount,
        isFavorite: isFavorite ?? this.isFavorite,
        isDownloaded: isDownloaded,
      );

  @override
  List<Object?> get props => [id, path, isFavorite, playCount];
}
