import 'package:isar/isar.dart';

part 'audio_entity.g.dart';

@collection
class AudioEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String path;

  late String title;
  late String artist;
  late String album;
  late String genre;
  late int duration; // milliseconds
  late int size; // bytes
  late int trackNumber;
  late int year;
  String? artworkPath;
  String? mimeType;
  late DateTime dateAdded;
  late DateTime dateModified;
  late int playCount;
  bool isFavorite = false;
}
