import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/download_model.dart';
import '../models/db/download_entity.dart';
import '../models/db/video_entity.dart';

import '../repositories/download_repository.dart';

final downloadServiceProvider = Provider<DownloadService>((ref) {
  final repository = ref.watch(downloadRepositoryProvider);
  return DownloadService(repository: repository);
});

class DownloadService {
  final DownloadRepository _repository;
  final _dio = Dio();
  final _uuid = const Uuid();

  static const _downloadSubDir = 'NovaPlayer/Downloads';

  DownloadService({required DownloadRepository repository}) : _repository = repository;

  Future<String> get downloadDirectory async {
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/$_downloadSubDir');
    } else {
      final docs = await getApplicationDocumentsDirectory();
      dir = Directory(p.join(docs.path, 'Downloads'));
    }
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir.path;
  }

  Future<({bool valid, String? fileName, int? fileSize, String? error})> validateUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return (valid: false, fileName: null, fileSize: null, error: 'Invalid URL format');
      }

      final response = await _dio.head(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          followRedirects: true,
          maxRedirects: 5,
        ),
      );

      final contentDisposition = response.headers.value('content-disposition');
      String? fileName;
      if (contentDisposition != null && contentDisposition.contains('filename=')) {
        fileName = contentDisposition.split('filename=').last.replaceAll('"', '').trim();
      }
      fileName ??= uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'download_${_uuid.v4().substring(0, 8)}';
      if (!fileName.contains('.')) fileName += '.mp4';

      final contentLength = int.tryParse(response.headers.value('content-length') ?? '');

      return (valid: true, fileName: fileName, fileSize: contentLength, error: null);
    } on DioException catch (e) {
      return (valid: false, fileName: null, fileSize: null, error: e.message ?? 'Network error');
    } catch (e) {
      return (valid: false, fileName: null, fileSize: null, error: e.toString());
    }
  }

  Future<String?> startDownload({
    required String url,
    required String fileName,
    String? thumbnailUrl,
  }) async {
    try {
      final savePath = await downloadDirectory;
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savePath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true,
      );

      if (taskId == null) return null;

      final entity = DownloadEntity()
        ..taskId = taskId
        ..url = url
        ..fileName = fileName
        ..savePath = savePath
        ..thumbnailUrl = thumbnailUrl
        ..status = 0
        ..progress = 0
        ..totalBytes = 0
        ..downloadedBytes = 0
        ..speed = 0
        ..eta = 0
        ..createdAt = DateTime.now()
        ..isBackground = true;

      await _repository.insert(entity);
      return taskId;
    } catch (e, st) {
      AppLogger.error('Failed to start download', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> pauseDownload(String taskId) async {
    await FlutterDownloader.pause(taskId: taskId);
    await _repository.updateStatus(taskId, DownloadTaskStatus.paused.index);
  }

  Future<void> resumeDownload(String taskId) async {
    final newTaskId = await FlutterDownloader.resume(taskId: taskId);
    if (newTaskId != null) {
      await _repository.updateTaskId(taskId, newTaskId, DownloadTaskStatus.running.index);
    }
  }

  Future<void> cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
    await _repository.updateStatus(taskId, DownloadTaskStatus.canceled.index);
  }

  Future<void> retryDownload(String taskId) async {
    final newTaskId = await FlutterDownloader.retry(taskId: taskId);
    if (newTaskId != null) {
      await _repository.updateTaskId(taskId, newTaskId, DownloadTaskStatus.running.index);
    }
  }

  Future<void> deleteDownload(String taskId, {bool deleteFile = false}) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: deleteFile);
    await _repository.delete(taskId);
  }

  Future<List<DownloadModel>> getAllDownloads() async {
    return _repository.getAll();
  }

  Future<void> updateProgress({
    required String taskId,
    required int status,
    required double progress,
    int totalBytes = 0,
    int downloadedBytes = 0,
    double speed = 0,
  }) async {
    await _repository.updateProgress(
      taskId: taskId,
      status: status,
      progress: progress,
      totalBytes: totalBytes,
      downloadedBytes: downloadedBytes,
      speed: speed,
    );
  }
}
