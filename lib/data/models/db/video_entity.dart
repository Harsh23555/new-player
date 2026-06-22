import 'package:isar/isar.dart';

part 'video_entity.g.dart';

@collection
class VideoEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String path;

  late String title;
  late String duration; // formatted
  late int durationMs; // milliseconds
  late int size; // bytes
  late int width;
  late int height;
  String? thumbnailPath;
  String? mimeType;
  late DateTime dateAdded;
  late DateTime dateModified;
  late int playCount;
  bool isFavorite = false;
  bool isDownloaded = false;
}
