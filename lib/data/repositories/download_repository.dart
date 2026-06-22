import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/download_model.dart';
import '../models/db/download_entity.dart';

final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository(ref.watch(isarProvider));
});

class DownloadRepository {
  final Isar _isar;
  DownloadRepository(this._isar);

  Future<List<DownloadModel>> getAll() async {
    try {
      final entities = await _isar.downloadEntitys
          .where()
          .sortByCreatedAt()
          .findAll();
      return entities.reversed.map(_toModel).toList();
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getAll failed', error: e, stackTrace: st);
      return [];
    }
  }

  Future<DownloadModel?> getByTaskId(String taskId) async {
    try {
      final entity = await _isar.downloadEntitys
          .where()
          .taskIdEqualTo(taskId)
          .findFirst();
      return entity != null ? _toModel(entity) : null;
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getByTaskId failed', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> insert(DownloadEntity entity) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadEntitys.put(entity);
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.insert failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateProgress({
    required String taskId,
    required int status,
    required double progress,
    int totalBytes = 0,
    int downloadedBytes = 0,
    double speed = 0,
  }) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .findFirst();
        if (entity != null) {
          entity.status = status;
          entity.progress = progress;
          entity.totalBytes = totalBytes;
          entity.downloadedBytes = downloadedBytes;
          entity.speed = speed;
          if (speed > 0 && totalBytes > downloadedBytes) {
            entity.eta = ((totalBytes - downloadedBytes) / speed).toInt();
          }
          if (status == 2) entity.completedAt = DateTime.now();
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateProgress failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateTaskId(String oldTaskId, String newTaskId, int status) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(oldTaskId)
            .findFirst();
        if (entity != null) {
          entity.taskId = newTaskId;
          entity.status = status;
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateTaskId failed', error: e, stackTrace: st);
    }
  }

  Future<void> updateStatus(String taskId, int status) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .findFirst();
        if (entity != null) {
          entity.status = status;
          await _isar.downloadEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.updateStatus failed', error: e, stackTrace: st);
    }
  }

  Future<void> delete(String taskId) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.downloadEntitys
            .where()
            .taskIdEqualTo(taskId)
            .deleteAll();
      });
    } catch (e, st) {
      AppLogger.error('DownloadRepository.delete failed', error: e, stackTrace: st);
    }
  }

  Future<List<DownloadModel>> getCompleted() async {
    try {
      final all = await _isar.downloadEntitys.where().findAll();
      return all
          .where((e) => e.status == 2)
          .map(_toModel)
          .toList();
    } catch (e, st) {
      AppLogger.error('DownloadRepository.getCompleted failed', error: e, stackTrace: st);
      return [];
    }
  }

  DownloadModel _toModel(DownloadEntity e) {
    return DownloadModel(
      id: e.id,
      taskId: e.taskId,
      url: e.url,
      fileName: e.fileName,
      savePath: e.savePath,
      status: DownloadStatus.values[e.status.clamp(0, 5)],
      progress: e.progress,
      totalBytes: e.totalBytes,
      downloadedBytes: e.downloadedBytes,
      speed: e.speed,
      eta: e.eta,
      thumbnailUrl: e.thumbnailUrl,
      errorMessage: e.errorMessage,
      createdAt: e.createdAt,
      completedAt: e.completedAt,
    );
  }
}
