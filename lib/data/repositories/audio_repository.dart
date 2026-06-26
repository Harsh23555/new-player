import 'dart:io';
import 'package:isar/isar.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/audio_model.dart';
import '../models/db/audio_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepository(ref.watch(isarProvider));
});

abstract class IAudioRepository {
  Future<List<AudioModel>> getAll({String sortBy, bool ascending});
  Future<AudioModel?> getById(int id);
  Future<AudioModel?> getByPath(String path);
  Future<void> upsertAll(List<AudioEntity> entities);
  Future<void> toggleFavorite(int id);
  Future<void> incrementPlayCount(int id);
  Future<List<AudioModel>> search(String query);
  Future<List<AudioModel>> getFavorites();
  Future<List<AudioModel>> getMostPlayed({int limit});
  Future<int> getCount();
  Future<void> deleteByPath(String path);
}

class AudioRepository implements IAudioRepository {
  final Isar _isar;
  AudioRepository(this._isar);

  @override
  Future<List<AudioModel>> getAll({
    String sortBy = 'title',
    bool ascending = true,
  }) async {
    try {
      List<AudioEntity> entities;
      switch (sortBy) {
        case 'artist':
          entities = await _isar.audioEntitys.where().sortByArtist().findAll();
          break;
        case 'album':
          entities = await _isar.audioEntitys.where().sortByAlbum().findAll();
          break;
        case 'duration':
          entities = await _isar.audioEntitys.where().sortByDuration().findAll();
          break;
        case 'dateAdded':
          entities = await _isar.audioEntitys.where().sortByDateAdded().findAll();
          break;
        case 'playCount':
          entities = await _isar.audioEntitys.where().sortByPlayCount().findAll();
          break;
        default:
          entities = await _isar.audioEntitys.where().sortByTitle().findAll();
      }
      if (!ascending) entities = entities.reversed.toList();
      return entities.map(AudioModel.fromEntity).toList();
    } catch (e, st) {
      AppLogger.error('AudioRepository.getAll failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<AudioModel?> getById(int id) async {
    try {
      final entity = await _isar.audioEntitys.get(id);
      return entity != null ? AudioModel.fromEntity(entity) : null;
    } catch (e, st) {
      AppLogger.error('AudioRepository.getById failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<AudioModel?> getByPath(String path) async {
    try {
      final entity = await _isar.audioEntitys
          .where()
          .pathEqualTo(path)
          .findFirst();
      return entity != null ? AudioModel.fromEntity(entity) : null;
    } catch (e, st) {
      AppLogger.error('AudioRepository.getByPath failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> upsertAll(List<AudioEntity> entities) async {
    try {
      await _isar.writeTxn(() async {
        for (final entity in entities) {
          final existing = await _isar.audioEntitys
              .where()
              .pathEqualTo(entity.path)
              .findFirst();
          if (existing != null) {
            entity.id = existing.id;
            entity.playCount = existing.playCount;
            entity.isFavorite = existing.isFavorite;
            entity.artworkPath = existing.artworkPath;
          }
          await _isar.audioEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('AudioRepository.upsertAll failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> toggleFavorite(int id) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.audioEntitys.get(id);
        if (entity != null) {
          entity.isFavorite = !entity.isFavorite;
          await _isar.audioEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('AudioRepository.toggleFavorite failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> incrementPlayCount(int id) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.audioEntitys.get(id);
        if (entity != null) {
          entity.playCount++;
          await _isar.audioEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('AudioRepository.incrementPlayCount failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<List<AudioModel>> search(String query) async {
    try {
      final q = query.toLowerCase();
      final all = await _isar.audioEntitys.where().findAll();
      return all
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.artist.toLowerCase().contains(q) ||
              e.album.toLowerCase().contains(q))
          .map(AudioModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('AudioRepository.search failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<AudioModel>> getFavorites() async {
    try {
      final all = await _isar.audioEntitys.where().findAll();
      return all
          .where((e) => e.isFavorite)
          .map(AudioModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('AudioRepository.getFavorites failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<List<AudioModel>> getMostPlayed({int limit = 20}) async {
    try {
      final entities = await _isar.audioEntitys
          .where()
          .sortByPlayCountDesc()
          .limit(limit)
          .findAll();
      return entities
          .where((e) => e.playCount > 0)
          .map(AudioModel.fromEntity)
          .toList();
    } catch (e, st) {
      AppLogger.error('AudioRepository.getMostPlayed failed', error: e, stackTrace: st);
      return [];
    }
  }

  @override
  Future<int> getCount() async {
    try {
      return await _isar.audioEntitys.count();
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> deleteByPath(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
      await _isar.writeTxn(() async {
        await _isar.audioEntitys.where().pathEqualTo(path).deleteAll();
      });
    } catch (e, st) {
      AppLogger.error('AudioRepository.deleteByPath failed', error: e, stackTrace: st);
    }
  }

  Future<void> rename(int id, String newTitle) async {
    final track = await _isar.audioEntitys.get(id);
    if (track != null) {
      track.title = newTitle;
      await _isar.writeTxn(() => _isar.audioEntitys.put(track));
    }
  }
}
