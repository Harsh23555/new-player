import 'package:equatable/equatable.dart';
import 'db/audio_entity.dart';

class AudioModel extends Equatable {
  final int id;
  final String path;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int duration; // ms
  final int size;
  final int trackNumber;
  final int year;
  final String? artworkPath;
  final String? mimeType;
  final DateTime dateAdded;
  final int playCount;
  final bool isFavorite;

  const AudioModel({
    required this.id,
    required this.path,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.size,
    required this.trackNumber,
    required this.year,
    this.artworkPath,
    this.mimeType,
    required this.dateAdded,
    required this.playCount,
    required this.isFavorite,
  });

  factory AudioModel.fromEntity(AudioEntity e) => AudioModel(
        id: e.id,
        path: e.path,
        title: e.title,
        artist: e.artist,
        album: e.album,
        genre: e.genre,
        duration: e.duration,
        size: e.size,
        trackNumber: e.trackNumber,
        year: e.year,
        artworkPath: e.artworkPath,
        mimeType: e.mimeType,
        dateAdded: e.dateAdded,
        playCount: e.playCount,
        isFavorite: e.isFavorite,
      );

  String get formattedDuration {
    final ms = Duration(milliseconds: duration);
    final h = ms.inHours;
    final m = ms.inMinutes % 60;
    final s = ms.inSeconds % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
  }

  AudioModel copyWith({bool? isFavorite, int? playCount}) => AudioModel(
        id: id,
        path: path,
        title: title,
        artist: artist,
        album: album,
        genre: genre,
        duration: duration,
        size: size,
        trackNumber: trackNumber,
        year: year,
        artworkPath: artworkPath,
        mimeType: mimeType,
        dateAdded: dateAdded,
        playCount: playCount ?? this.playCount,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  @override
  List<Object?> get props => [id, path, isFavorite, playCount];
}
