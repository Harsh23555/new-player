import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'dart:io' show Platform;
import 'package:nova_player/core/database/isar_service.dart';
import 'package:nova_player/core/utils/app_logger.dart';
import 'package:nova_player/data/models/db/eq_settings_entity.dart';
import 'package:nova_player/core/services/equalizer_service.dart';
import 'package:nova_player/features/audio/providers/equalizer_provider.dart';

class VideoEqState {
  final bool enabled;
  final String preset;
  final List<double> gains;
  final double preamp;
  final int bassBoost; // 0 to 1000
  final int virtualizer; // 0 to 1000

  const VideoEqState({
    this.enabled = false,
    this.preset = 'Flat',
    this.gains = const [0, 0, 0, 0, 0],
    this.preamp = 1.0,
    this.bassBoost = 0,
    this.virtualizer = 0,
  });

  VideoEqState copyWith({
    bool? enabled,
    String? preset,
    List<double>? gains,
    double? preamp,
    int? bassBoost,
    int? virtualizer,
  }) =>
      VideoEqState(
        enabled: enabled ?? this.enabled,
        preset: preset ?? this.preset,
        gains: gains ?? this.gains,
        preamp: preamp ?? this.preamp,
        bassBoost: bassBoost ?? this.bassBoost,
        virtualizer: virtualizer ?? this.virtualizer,
      );
}

class VideoEqNotifier extends StateNotifier<VideoEqState> {
  final Isar _isar;

  VideoEqNotifier(this._isar) : super(const VideoEqState()) {
    _load().then((_) => _applyToNative());
  }

  Future<void> _load() async {
    try {
      final entity = await _isar.eqSettingsEntitys.get(2);
      if (entity != null) {
        state = VideoEqState(
          enabled: entity.enabled,
          preset: entity.preset,
          gains: List<double>.from(entity.gains),
          preamp: entity.preamp,
          // Since we didn't have bass/virtual in Isar yet, we handle defaults
          // In a real app we'd update the entity. For now defaults are fine.
        );
      }
    } catch (e, st) {
      AppLogger.warning('VideoEqNotifier._load failed', error: e, stackTrace: st);
    }
  }

  Future<void> _save() async {
    try {
      final entity = EqSettingsEntity()
        ..id = 2
        ..enabled = state.enabled
        ..preset = state.preset
        ..gains = state.gains
        ..preamp = state.preamp;
      await _isar.writeTxn(() => _isar.eqSettingsEntitys.put(entity));
    } catch (e, st) {
      AppLogger.warning('VideoEqNotifier._save failed', error: e, stackTrace: st);
    }
  }

  void toggle() {
    state = state.copyWith(enabled: !state.enabled);
    _applyToNative();
    _save();
  }

  void reset() {
    state = const VideoEqState(enabled: true);
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
  }

  void setVirtualizer(int value) {
    state = state.copyWith(virtualizer: value);
    if (state.enabled) {
      EqualizerService.setVirtualizer(value);
    }
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

final videoEqProvider = StateNotifierProvider<VideoEqNotifier, VideoEqState>((ref) {
  return VideoEqNotifier(ref.watch(isarProvider));
});
