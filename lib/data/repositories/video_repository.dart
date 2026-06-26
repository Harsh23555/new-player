import 'dart:io';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/video_model.dart';
import '../models/db/video_entity.dart';

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepository(ref.watch(isarProvider));
});

abstract class IVideoRepository {
  Future<List<VideoModel>> getAll({String sortBy, bool ascending});
  Future<VideoModel?> getById(int id);
  Future<VideoModel?> getByPath(String path);
  Future<void> upsertAll(List<VideoEntity> entities);
  Future<void> upsert(VideoEntity entity);
  Future<void> toggleFavorite(int id);
  Future<void> incrementPlayCount(int id);
  Future<void> updateResumePosition(int id, int positionMs);
  Future<List<VideoModel>> search(String query);
  Future<List<VideoModel>> getFavorites();
  Future<List<VideoModel>> getDownloaded();
  Future<int> getCount();
  Future<void> deleteByPath(String path);
}

class VideoRepository implements IVideoRepository {
  final Isar _isar;
  VideoRepository(this._isar);

  @override
  Future<List<VideoModel>> getAll({
    String sortBy = 'dateAdded',
    bool ascending = false,
  }) async {
    try {
      List<VideoEntity> entities;
      switch (sortBy) {
        case 'title':
          entities = await _isar.videoEntitys.where().sortByTitle().findAll();
          break;
        case 'size':
          entities = await _isar.videoEntitys.where().sortBySize().findAll();
          break;
        case 'duration':
          entities = await _isar.videoEntitys.where().sortByDurationMs().findAll();
          break;
        default:
          entities = await _isar.videoEntitys.where().sortByDateAdded().findAll();
      }
      if (!ascending) entities = entities.reversed.toList();
      return entities.map(VideoModel.fromEntity).toList();
    } catch (e, st) {
      AppLogger.error('VideoRepository.getAll failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<VideoModel?> getById(int id) async {
    try {
      final entity = await _isar.videoEntitys.get(id);
      return entity != null ? VideoModel.fromEntity(entity) : null;
    } catch (e, st) {
      AppLogger.error('VideoRepository.getById failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<VideoModel?> getByPath(String path) async {
    try {
      final entity = await _isar.videoEntitys
          .where()
          .pathEqualTo(path)
          .findFirst();
      return entity != null ? VideoModel.fromEntity(entity) : null;
    } catch (e, st) {
      AppLogger.error('VideoRepository.getByPath failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> upsertAll(List<VideoEntity> entities) async {
    try {
      await _isar.writeTxn(() async {
        for (final entity in entities) {
          final existing = await _isar.videoEntitys
              .where()
              .pathEqualTo(entity.path)
              .findFirst();
          if (existing != null) {
            entity.id = existing.id;
            entity.playCount = existing.playCount;
            entity.isFavorite = existing.isFavorite;
            if (existing.thumbnailPath != null) {
              entity.thumbnailPath = existing.thumbnailPath;
            }
          }
          await _isar.videoEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.upsertAll failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> upsert(VideoEntity entity) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.videoEntitys.put(entity);
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.upsert failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> toggleFavorite(int id) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.videoEntitys.get(id);
        if (entity != null) {
          entity.isFavorite = !entity.isFavorite;
          await _isar.videoEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.toggleFavorite failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> incrementPlayCount(int id) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.videoEntitys.get(id);
        if (entity != null) {
          entity.playCount++;
          await _isar.videoEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.incrementPlayCount failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> updateResumePosition(int id, int positionMs) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.videoEntitys.get(id);
        if (entity != null) {
          await _isar.videoEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.updateResumePosition failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<List<VideoModel>> search(String query) async {
    try {
      final q = query.toLowerCase();
      final all = await _isar.videoEntitys.where().findAll();
      return all
          .where((e) => e.title.toLowerCase().contains(q))
          .map(VideoModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('VideoRepository.search failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<VideoModel>> getFavorites() async {
    try {
      final all = await _isar.videoEntitys.where().findAll();
      return all
          .where((e) => e.isFavorite)
          .map(VideoModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('VideoRepository.getFavorites failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<VideoModel>> getDownloaded() async {
    try {
      final all = await _isar.videoEntitys.where().findAll();
      return all
          .where((e) => e.isDownloaded)
          .map(VideoModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('VideoRepository.getDownloaded failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<int> getCount() async {
    try {
      return await _isar.videoEntitys.count();
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> deleteByPath(String path) async {
    try {
      // 1. Delete physical file
      final file = File(path);
      if (await file.exists()) await file.delete();
      // 2. Remove from Isar
      await _isar.writeTxn(() async {
        await _isar.videoEntitys.filter().pathEqualTo(path).deleteAll();
      });
    } catch (e, st) {
      AppLogger.error('VideoRepository.deleteByPath failed', error: e, stackTrace: st);
    }
  }
}
