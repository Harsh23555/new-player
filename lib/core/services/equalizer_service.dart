import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../../core/utils/app_logger.dart';

class EqualizerService {
  static const _channel = MethodChannel('com.novaplayer.app/equalizer');

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setEnabled', {'enabled': enabled});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setEnabled failed', error: e, stackTrace: st);
    }
  }

  static Future<void> setBandLevel(int band, double level) async {
    if (!Platform.isAndroid) return;
    try {
      // Level in dB, convert to millibels if needed on native side
      await _channel.invokeMethod('setBandLevel', {'band': band, 'level': level});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setBandLevel failed', error: e, stackTrace: st);
    }
  }

  static Future<void> applyPreset(List<double> gains) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('applyPreset', {'gains': gains});
    } catch (e, st) {
      AppLogger.error('EqualizerService.applyPreset failed', error: e, stackTrace: st);
    }
  }

  static Future<void> setPreamp(double preamp) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setPreamp', {'preamp': preamp});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setPreamp failed', error: e, stackTrace: st);
    }
  }

  static Future<void> setBassBoost(int strength) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setBassBoost', {'strength': strength});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setBassBoost failed', error: e, stackTrace: st);
    }
  }

  static Future<void> setVirtualizer(int strength) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setVirtualizer', {'strength': strength});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setVirtualizer failed', error: e, stackTrace: st);
    }
  }

  static Future<void> setAudioSessionId(int sessionId) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('setAudioSessionId', {'sessionId': sessionId});
    } catch (e, st) {
      AppLogger.error('EqualizerService.setAudioSessionId failed', error: e, stackTrace: st);
    }
  }
}
