import 'package:equatable/equatable.dart';

enum DownloadStatus {
  enqueued,
  running,
  complete,
  failed,
  canceled,
  paused,
}

class DownloadModel extends Equatable {
  final int id;
  final String taskId;
  final String url;
  final String fileName;
  final String savePath;
  final DownloadStatus status;
  final double progress;
  final int totalBytes;
  final int downloadedBytes;
  final double speed; // bytes/s
  final int eta; // seconds
  final String? thumbnailUrl;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DownloadModel({
    required this.id,
    required this.taskId,
    required this.url,
    required this.fileName,
    required this.savePath,
    required this.status,
    required this.progress,
    required this.totalBytes,
    required this.downloadedBytes,
    required this.speed,
    required this.eta,
    this.thumbnailUrl,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  String get formattedSpeed {
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  String get formattedEta {
    if (eta <= 0) return '--';
    if (eta < 60) return '${eta}s';
    if (eta < 3600) return '${(eta / 60).floor()}m ${eta % 60}s';
    return '${(eta / 3600).floor()}h ${((eta % 3600) / 60).floor()}m';
  }

  String get formattedTotalSize {
    if (totalBytes <= 0) return 'Unknown';
    if (totalBytes < 1024 * 1024) return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    if (totalBytes < 1024 * 1024 * 1024) return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  bool get isActive => status == DownloadStatus.running || status == DownloadStatus.enqueued;
  bool get isPaused => status == DownloadStatus.paused;
  bool get isComplete => status == DownloadStatus.complete;
  bool get isFailed => status == DownloadStatus.failed;

  @override
  List<Object?> get props => [id, taskId, status, progress, speed, eta];
}
