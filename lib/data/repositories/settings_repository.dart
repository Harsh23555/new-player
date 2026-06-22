import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/utils/app_logger.dart';
import '../models/db/settings_entity.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(isarProvider));
});

class SettingsRepository {
  static const int _singletonId = 1;
  final Isar _isar;

  SettingsRepository(this._isar);

  Future<SettingsEntity> get() async {
    try {
      final existing = await _isar.settingsEntitys.get(_singletonId);
      if (existing != null) return existing;
      // Return defaults and persist them
      final defaults = SettingsEntity();
      await save(defaults);
      return defaults;
    } catch (e, st) {
      AppLogger.error('SettingsRepository.get failed', error: e, stackTrace: st);
      return SettingsEntity();
    }
  }

  Future<void> save(SettingsEntity entity) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.settingsEntitys.put(entity);
      });
    } catch (e, st) {
      AppLogger.error('SettingsRepository.save failed', error: e, stackTrace: st);
    }
  }

  Future<void> reset() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.settingsEntitys.delete(_singletonId);
      });
    } catch (e, st) {
      AppLogger.error('SettingsRepository.reset failed', error: e, stackTrace: st);
    }
  }
}
