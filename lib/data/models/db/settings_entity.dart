import 'package:isar/isar.dart';

part 'settings_entity.g.dart';

@collection
class SettingsEntity {
  Id id = 1; // Singleton

  bool isDarkMode = true;
  bool useDynamicColor = false;
  String audioSortBy = 'title'; // title, artist, album, duration, dateAdded
  String videoSortBy = 'dateAdded'; // title, duration, size, dateAdded
  bool audioSortAscending = true;
  bool videoSortAscending = false;
  bool showAudioArtwork = true;
  bool showVideoThumbnail = true;
  bool backgroundPlayback = true;
  bool pipEnabled = true;
  double defaultPlaybackSpeed = 1.0;
  int skipDuration = 10; // seconds
  String downloadPath = '';
  bool autoScanOnStart = true;
  bool showDownloadNotification = true;
  int maxConcurrentDownloads = 3;
  String lastAudioPath = '';
  int lastAudioPosition = 0;
  String videoGridColumns = '2'; // '1', '2', '3'
}
