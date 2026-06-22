import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/isar_service.dart';
import '../../../data/models/db/settings_entity.dart';

// ---------------------------------------------------------------------------
// Theme mode enum with AMOLED support
// ---------------------------------------------------------------------------
enum NovaThemeMode { light, dark, amoled }

extension NovaThemeModeX on NovaThemeMode {
  ThemeMode get flutterThemeMode {
    switch (this) {
      case NovaThemeMode.light:
        return ThemeMode.light;
      case NovaThemeMode.dark:
      case NovaThemeMode.amoled:
        return ThemeMode.dark;
    }
  }

  String get label {
    switch (this) {
      case NovaThemeMode.light:
        return 'Light';
      case NovaThemeMode.dark:
        return 'Dark';
      case NovaThemeMode.amoled:
        return 'AMOLED';
    }
  }

  IconData get icon {
    switch (this) {
      case NovaThemeMode.light:
        return Icons.light_mode_rounded;
      case NovaThemeMode.dark:
        return Icons.dark_mode_rounded;
      case NovaThemeMode.amoled:
        return Icons.brightness_1_rounded;
    }
  }
}

// ---------------------------------------------------------------------------
// Theme mode provider
// ---------------------------------------------------------------------------
final novaThemeModeProvider =
    StateProvider<NovaThemeMode>((ref) => NovaThemeMode.dark);

// For compatibility with existing themeModeProvider usage in core/app.dart
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(novaThemeModeProvider).flutterThemeMode;
});

// AMOLED flag
final isAmoledProvider = Provider<bool>((ref) {
  return ref.watch(novaThemeModeProvider) == NovaThemeMode.amoled;
});

// ---------------------------------------------------------------------------
// Settings notifier
// ---------------------------------------------------------------------------
class SettingsNotifier extends StateNotifier<SettingsEntity> {
  final Isar _isar;
  final Ref _ref;

  SettingsNotifier(this._isar, this._ref) : super(SettingsEntity()) {
    _load();
  }

  Future<void> _load() async {
    final settings = await _isar.settingsEntitys.get(1);
    if (settings != null) {
      state = settings;
      final mode = settings.isDarkMode
          ? (settings.useDynamicColor ? NovaThemeMode.amoled : NovaThemeMode.dark)
          : NovaThemeMode.light;
      _ref.read(novaThemeModeProvider.notifier).state = mode;
    } else {
      await _save();
    }
  }

  Future<void> _save() async {
    await _isar.writeTxn(() async {
      await _isar.settingsEntitys.put(state);
    });
  }

  /// Helper to create a copy of SettingsEntity with mutations
  SettingsEntity _copyState() {
    final s = SettingsEntity();
    s.id = state.id;
    s.isDarkMode = state.isDarkMode;
    s.useDynamicColor = state.useDynamicColor;
    s.audioSortBy = state.audioSortBy;
    s.videoSortBy = state.videoSortBy;
    s.audioSortAscending = state.audioSortAscending;
    s.videoSortAscending = state.videoSortAscending;
    s.showAudioArtwork = state.showAudioArtwork;
    s.showVideoThumbnail = state.showVideoThumbnail;
    s.backgroundPlayback = state.backgroundPlayback;
    s.pipEnabled = state.pipEnabled;
    s.defaultPlaybackSpeed = state.defaultPlaybackSpeed;
    s.skipDuration = state.skipDuration;
    s.downloadPath = state.downloadPath;
    s.autoScanOnStart = state.autoScanOnStart;
    s.showDownloadNotification = state.showDownloadNotification;
    s.maxConcurrentDownloads = state.maxConcurrentDownloads;
    s.lastAudioPath = state.lastAudioPath;
    s.lastAudioPosition = state.lastAudioPosition;
    s.videoGridColumns = state.videoGridColumns;
    return s;
  }

  Future<void> setThemeMode(NovaThemeMode mode) async {
    final s = _copyState();
    s.isDarkMode = mode != NovaThemeMode.light;
    s.useDynamicColor = mode == NovaThemeMode.amoled;
    state = s;
    _ref.read(novaThemeModeProvider.notifier).state = mode;
    await _save();
  }

  Future<void> setDarkMode(bool value) async {
    final mode = value ? NovaThemeMode.dark : NovaThemeMode.light;
    await setThemeMode(mode);
  }

  Future<void> setBackgroundPlayback(bool value) async {
    final s = _copyState();
    s.backgroundPlayback = value;
    state = s;
    await _save();
  }

  Future<void> setPipEnabled(bool value) async {
    final s = _copyState();
    s.pipEnabled = value;
    state = s;
    await _save();
  }

  Future<void> setDefaultSpeed(double value) async {
    final s = _copyState();
    s.defaultPlaybackSpeed = value;
    state = s;
    await _save();
  }

  Future<void> setSkipDuration(int value) async {
    final s = _copyState();
    s.skipDuration = value;
    state = s;
    await _save();
  }

  Future<void> setAutoScan(bool value) async {
    final s = _copyState();
    s.autoScanOnStart = value;
    state = s;
    await _save();
  }

  Future<void> setVideoGridColumns(String value) async {
    final s = _copyState();
    s.videoGridColumns = value;
    state = s;
    await _save();
  }

  Future<void> setMaxConcurrentDownloads(int value) async {
    final s = _copyState();
    s.maxConcurrentDownloads = value;
    state = s;
    await _save();
  }

  Future<void> setShowDownloadNotification(bool value) async {
    final s = _copyState();
    s.showDownloadNotification = value;
    state = s;
    await _save();
  }

  Future<void> setShowAudioArtwork(bool value) async {
    final s = _copyState();
    s.showAudioArtwork = value;
    state = s;
    await _save();
  }

  Future<void> setShowVideoThumbnail(bool value) async {
    final s = _copyState();
    s.showVideoThumbnail = value;
    state = s;
    await _save();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsEntity>((ref) {
  return SettingsNotifier(ref.watch(isarProvider), ref);
});
