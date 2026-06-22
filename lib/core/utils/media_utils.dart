import 'dart:io';
import 'package:path/path.dart' as p;

class MediaUtils {
  MediaUtils._();

  static const List<String> audioExtensions = [
    'mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'opus', 'wma', 'aiff', 'alac',
  ];

  static const List<String> videoExtensions = [
    'mp4', 'mkv', 'mov', 'avi', 'webm', 'flv', 'm4v', '3gp', 'ts', 'wmv', 'vob',
  ];

  static bool isAudioFile(String path) {
    final ext = p.extension(path).replaceAll('.', '').toLowerCase();
    return audioExtensions.contains(ext);
  }

  static bool isVideoFile(String path) {
    final ext = p.extension(path).replaceAll('.', '').toLowerCase();
    return videoExtensions.contains(ext);
  }

  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String formatDurationMs(int ms) {
    return formatDuration(Duration(milliseconds: ms));
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static String formatSpeed(double bytesPerSec) {
    if (bytesPerSec <= 0) return '0 B/s';
    if (bytesPerSec < 1024) return '${bytesPerSec.toStringAsFixed(0)} B/s';
    if (bytesPerSec < 1024 * 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  static String formatEta(int seconds) {
    if (seconds <= 0) return '--';
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).floor()}m ${seconds % 60}s';
    return '${(seconds / 3600).floor()}h ${((seconds % 3600) / 60).floor()}m';
  }

  static String getFileNameWithoutExtension(String path) {
    final name = p.basename(path);
    final dot = name.lastIndexOf('.');
    return dot != -1 ? name.substring(0, dot) : name;
  }

  static String getExtension(String path) {
    return p.extension(path).replaceAll('.', '').toLowerCase();
  }

  static Future<bool> fileExists(String path) async {
    return File(path).exists();
  }

  static String resolutionLabel(int width, int height) {
    if (width == 0 && height == 0) return 'Unknown';
    if (height >= 2160) return '4K UHD';
    if (height >= 1440) return '1440p';
    if (height >= 1080) return '1080p FHD';
    if (height >= 720) return '720p HD';
    if (height >= 480) return '480p SD';
    if (height >= 360) return '360p';
    return '${height}p';
  }

  static double parseProgress(int progress) {
    return (progress / 100.0).clamp(0.0, 1.0);
  }
}
