import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'dart:io' show Platform;
import 'package:nova_player/core/database/isar_service.dart';
import 'package:nova_player/core/utils/app_logger.dart';
import 'package:nova_player/data/models/db/eq_settings_entity.dart';
import 'package:nova_player/core/services/equalizer_service.dart';
import 'package:nova_player/features/audio/providers/equalizer_provider.dart' show kEqPresets;

class GlobalEqState {
  final bool enabled;
  final String preset;
  final List<double> gains;
  final double preamp;
  final int bassBoost;
  final int virtualizer;

  const GlobalEqState({
    this.enabled = false,
    this.preset = 'Flat',
    this.gains = const [0, 0, 0, 0, 0],
    this.preamp = 1.0,
    this.bassBoost = 0,
    this.virtualizer = 0,
  });

  GlobalEqState copyWith({
    bool? enabled,
    String? preset,
    List<double>? gains,
    double? preamp,
    int? bassBoost,
    int? virtualizer,
  }) =>
      GlobalEqState(
        enabled: enabled ?? this.enabled,
        preset: preset ?? this.preset,
        gains: gains ?? this.gains,
        preamp: preamp ?? this.preamp,
        bassBoost: bassBoost ?? this.bassBoost,
        virtualizer: virtualizer ?? this.virtualizer,
      );
}

class GlobalEqNotifier extends StateNotifier<GlobalEqState> {
  final Isar _isar;

  GlobalEqNotifier(this._isar) : super(const GlobalEqState()) {
    _load().then((_) => _applyToNative());
  }

  Future<void> _load() async {
    try {
      final entity = await _isar.eqSettingsEntitys.get(1); // Using ID=1 for global
      if (entity != null) {
        state = GlobalEqState(
          enabled: entity.enabled,
          preset: entity.preset,
          gains: List<double>.from(entity.gains),
          preamp: entity.preamp,
          bassBoost: entity.bassBoost,
          virtualizer: entity.virtualizer,
        );
      }
    } catch (e, st) {
      AppLogger.warning('GlobalEqNotifier._load failed', error: e, stackTrace: st);
    }
  }

  Future<void> _save() async {
    try {
      final entity = EqSettingsEntity()
        ..id = 1
        ..enabled = state.enabled
        ..preset = state.preset
        ..gains = state.gains
        ..preamp = state.preamp
        ..bassBoost = state.bassBoost
        ..virtualizer = state.virtualizer;
      await _isar.writeTxn(() => _isar.eqSettingsEntitys.put(entity));
    } catch (e, st) {
      AppLogger.warning('GlobalEqNotifier._save failed', error: e, stackTrace: st);
    }
  }

  void toggle() {
    state = state.copyWith(enabled: !state.enabled);
    _applyToNative();
    _save();
  }

  void reset() {
    state = const GlobalEqState(enabled: true);
    _applyToNative();
    _save();
  }

  void applyPreset(String name) {
    final gains = List<double>.from(kEqPresets[name] ?? kEqPresets['Flat']!);
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

  void setPreamp(double value) {
    state = state.copyWith(preamp: value);
    if (state.enabled) {
      EqualizerService.setPreamp(state.preamp);
    }
    _save();
  }

  void setBassBoost(int value) {
    state = state.copyWith(bassBoost: value);
    if (state.enabled) {
      EqualizerService.setBassBoost(value);
    }
    _save();
  }

  void setVirtualizer(int value) {
    state = state.copyWith(virtualizer: value);
    if (state.enabled) {
      EqualizerService.setVirtualizer(value);
    }
    _save();
  }

  void _applyToNative() {
    if (!Platform.isAndroid) return;
    EqualizerService.setEnabled(state.enabled);
    if (state.enabled) {
      EqualizerService.applyPreset(state.gains);
      EqualizerService.setPreamp(state.preamp);
      EqualizerService.setBassBoost(state.bassBoost);
      EqualizerService.setVirtualizer(state.virtualizer);
    }
  }
}

final globalEqProvider = StateNotifierProvider<GlobalEqNotifier, GlobalEqState>((ref) {
  return GlobalEqNotifier(ref.watch(isarProvider));
});
