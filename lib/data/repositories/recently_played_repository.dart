import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/db/recently_played_entity.dart';

final recentlyPlayedRepositoryProvider = Provider<RecentlyPlayedRepository>((ref) {
  return RecentlyPlayedRepository(ref.watch(isarProvider));
});

class RecentlyPlayedItem {
  final int id;
  final String mediaPath;
  final String mediaType;
  final String title;
  final String subtitle;
  final String? artworkPath;
  final DateTime playedAt;
  final int positionMs;

  const RecentlyPlayedItem({
    required this.id,
    required this.mediaPath,
    required this.mediaType,
    required this.title,
    required this.subtitle,
    this.artworkPath,
    required this.playedAt,
    required this.positionMs,
  });

  bool get isAudio => mediaType == 'audio';
  bool get isVideo => mediaType == 'video';
}

class RecentlyPlayedRepository {
  final Isar _isar;
  static const int _maxHistory = 50;

  RecentlyPlayedRepository(this._isar);

  Future<void> addOrUpdate({
    required String mediaPath,
    required String mediaType,
    required String title,
    required String subtitle,
    String? artworkPath,
    int positionMs = 0,
  }) async {
    try {
      await _isar.writeTxn(() async {
        // Remove existing entry for same path
        await _isar.recentlyPlayedEntitys
            .where()
            .mediaPathEqualTo(mediaPath)
            .deleteAll();

        final entity = RecentlyPlayedEntity()
          ..mediaPath = mediaPath
          ..mediaType = mediaType
          ..title = title
          ..subtitle = subtitle
          ..artworkPath = artworkPath
          ..playedAt = DateTime.now()
          ..positionMs = positionMs;

        await _isar.recentlyPlayedEntitys.put(entity);

        // Keep only the most recent _maxHistory items
        final count = await _isar.recentlyPlayedEntitys.count();
        if (count > _maxHistory) {
          final oldest = await _isar.recentlyPlayedEntitys
              .where()
              .sortByPlayedAt()
              .limit(count - _maxHistory)
              .findAll();
          final ids = oldest.map((e) => e.id).toList();
          await _isar.recentlyPlayedEntitys.deleteAll(ids);
        }
      });
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.addOrUpdate failed',
          error: e, stackTrace: st);
    }
  }

  Future<void> updatePosition(String mediaPath, int positionMs) async {
    try {
      await _isar.writeTxn(() async {
        final entity = await _isar.recentlyPlayedEntitys
            .where()
            .mediaPathEqualTo(mediaPath)
            .findFirst();
        if (entity != null) {
          entity.positionMs = positionMs;
          entity.playedAt = DateTime.now();
          await _isar.recentlyPlayedEntitys.put(entity);
        }
      });
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.updatePosition failed',
          error: e, stackTrace: st);
    }
  }

  Future<List<RecentlyPlayedItem>> getAll({int limit = 20}) async {
    try {
      final entities = await _isar.recentlyPlayedEntitys
          .where()
          .sortByPlayedAtDesc()
          .limit(limit)
          .findAll();
      return entities.map(_toItem).toList();
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.getAll failed',
          error: e, stackTrace: st);
      return [];
    }
  }

  Future<RecentlyPlayedItem?> getByPath(String path) async {
    try {
      final entity = await _isar.recentlyPlayedEntitys
          .where()
          .mediaPathEqualTo(path)
          .findFirst();
      return entity != null ? _toItem(entity) : null;
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.getByPath failed',
          error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.recentlyPlayedEntitys.clear();
      });
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.clearAll failed',
          error: e, stackTrace: st);
    }
  }

  Future<void> removeByPath(String path) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.recentlyPlayedEntitys
            .where()
            .mediaPathEqualTo(path)
            .deleteAll();
      });
    } catch (e, st) {
      AppLogger.error('RecentlyPlayedRepository.removeByPath failed',
          error: e, stackTrace: st);
    }
  }

  RecentlyPlayedItem _toItem(RecentlyPlayedEntity e) {
    return RecentlyPlayedItem(
      id: e.id,
      mediaPath: e.mediaPath,
      mediaType: e.mediaType,
      title: e.title,
      subtitle: e.subtitle,
      artworkPath: e.artworkPath,
      playedAt: e.playedAt,
      positionMs: e.positionMs,
    );
  }
}
