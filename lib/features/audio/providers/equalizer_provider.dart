import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'dart:io' show Platform;
import '../../../core/database/isar_service.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/db/eq_settings_entity.dart';
import '../../../core/services/equalizer_service.dart';

/// Hz centre frequencies for the 5 bands
const kEqBandHz = [60, 230, 910, 3600, 14000];

/// Preset gain tables (dB per band)
const kEqPresets = <String, List<double>>{
  'Flat': [0, 0, 0, 0, 0],
  'Rock': [5, 3, -1, 3, 5],
  'Pop': [-1, 2, 5, 1, -2],
  'Classical': [5, 3, -2, 4, 4],
  'Jazz': [4, 2, 0, 2, 5],
  'Bass Boost': [6, 4, 0, -2, -3],
  'Dance': [5, 7, 2, 4, 3],
  'Hip Hop': [5, 3, 0, 1, 3],
  'Electronic': [4, 2, 0, 2, 4],
  'Vocal': [-2, -1, 5, 3, 0],
  'Custom': [0, 0, 0, 0, 0],
};

class EqState {
  final bool enabled;
  final String preset;
  final List<double> gains; // -12 dB .. +12 dB

  const EqState({
    this.enabled = false,
    this.preset = 'Flat',
    this.gains = const [0, 0, 0, 0, 0],
  });

  EqState copyWith({bool? enabled, String? preset, List<double>? gains}) =>
      EqState(
        enabled: enabled ?? this.enabled,
        preset: preset ?? this.preset,
        gains: gains ?? this.gains,
      );
}

class EqNotifier extends StateNotifier<EqState> {
  final Isar _isar;

  EqNotifier(this._isar) : super(const EqState()) {
    _load().then((_) => _applyToNative());
  }

  /// Load persisted settings from Isar
  Future<void> _load() async {
    try {
      final entity = await _isar.eqSettingsEntitys.get(1);
      if (entity != null) {
        state = EqState(
          enabled: entity.enabled,
          preset: entity.preset,
          gains: List<double>.from(entity.gains),
        );
      }
    } catch (e, st) {
      AppLogger.warning('EqNotifier._load failed', error: e, stackTrace: st);
    }
  }

  /// Persist current state to Isar
  Future<void> _save() async {
    try {
      final entity = EqSettingsEntity()
        ..id = 1
        ..enabled = state.enabled
        ..preset = state.preset
        ..gains = state.gains;
      await _isar.writeTxn(() => _isar.eqSettingsEntitys.put(entity));
    } catch (e, st) {
      AppLogger.warning('EqNotifier._save failed', error: e, stackTrace: st);
    }
  }

  void toggle() {
    state = state.copyWith(enabled: !state.enabled);
    _applyToNative();
    _save();
  }

  void applyPreset(String name) {
    final gains =
        List<double>.from(kEqPresets[name] ?? kEqPresets['Flat']!);
    state = state.copyWith(preset: name, gains: gains);
    _applyToNative();
    _save();
  }

  void setBandGain(int index, double db) {
    final gains = [...state.gains]..[index] = db;
    state = state.copyWith(gains: gains, preset: 'Custom');
    _applyToNative();
    _save();
  }

  void _applyToNative() {
    if (!Platform.isAndroid) return;
    EqualizerService.setEnabled(state.enabled);
    if (state.enabled) {
      EqualizerService.applyPreset(state.gains);
    }
  }
}

final eqProvider = StateNotifierProvider<EqNotifier, EqState>((ref) {
  return EqNotifier(ref.watch(isarProvider));
});
