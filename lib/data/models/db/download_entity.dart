import 'package:isar/isar.dart';

part 'download_entity.g.dart';

@collection
class DownloadEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String taskId;

  late String url;
  late String fileName;
  late String savePath;
  late int status; // 0=enqueued, 1=running, 2=complete, 3=failed, 4=canceled, 5=paused
  late double progress; // 0.0 - 1.0
  late int totalBytes;
  late int downloadedBytes;
  late double speed; // bytes per second
  late int eta; // seconds remaining
  String? thumbnailUrl;
  String? errorMessage;
  late DateTime createdAt;
  DateTime? completedAt;
  bool isBackground = true;
}
