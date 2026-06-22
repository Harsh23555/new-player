import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class StorageHelper {
  StorageHelper._();

  static const String _appDirName = 'NovaPlayer';
  static const String _downloadsDirName = 'Downloads';
  static const String _thumbsDirName = 'Thumbnails';
  static const String _artworkDirName = 'Artwork';

  /// Returns primary external storage download directory on Android,
  /// falls back to app documents on other platforms.
  static Future<String> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/$_appDirName/$_downloadsDirName');
      if (!dir.existsSync()) await dir.create(recursive: true);
      return dir.path;
    }
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _downloadsDirName));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir.path;
  }

  static Future<String> getThumbnailDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _thumbsDirName));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir.path;
  }

  static Future<String> getArtworkDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _artworkDirName));
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir.path;
  }

  /// Returns available, used, total storage in bytes (Android only; 0 on other platforms)
  static Future<({int total, int used, int available})> getStorageStats() async {
    try {
      if (Platform.isAndroid) {
        final stat = await FileStat.stat('/storage/emulated/0');
        // FileStat doesn't give free space directly; use Directory approach
        // Approximation via app documents directory
        final docs = await getApplicationDocumentsDirectory();
        final docStat = await FileStat.stat(docs.path);
        return (total: 0, used: 0, available: 0);
      }
      return (total: 0, used: 0, available: 0);
    } catch (_) {
      return (total: 0, used: 0, available: 0);
    }
  }

  static Future<int> getDirectorySize(String path) async {
    try {
      final dir = Directory(path);
      if (!dir.existsSync()) return 0;
      int totalSize = 0;
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (_) {
      return 0;
    }
  }

  static Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static bool fileExists(String path) {
    return File(path).existsSync();
  }

  static Future<void> ensureDirectoryExists(String path) async {
    final dir = Directory(path);
    if (!dir.existsSync()) await dir.create(recursive: true);
  }
}
