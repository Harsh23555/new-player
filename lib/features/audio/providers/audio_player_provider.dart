import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../data/models/audio_model.dart';
import '../../../data/services/audio_player_service.dart';
import '../../../data/services/audio_scan_service.dart';

// ── Current Track ────────────────────────────────────────────────────────────
final currentTrackProvider = StateProvider<AudioModel?>((ref) => null);

// ── Player State ─────────────────────────────────────────────────────────────
final playerStateStreamProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(audioPlayerServiceProvider).playerStateStream;
});

final positionStreamProvider = StreamProvider<Duration>((ref) {
  return ref.watch(audioPlayerServiceProvider).positionStream;
});

final durationStreamProvider = StreamProvider<Duration?>((ref) {
  return ref.watch(audioPlayerServiceProvider).durationStream;
});

final speedStreamProvider = StreamProvider<double>((ref) {
  return ref.watch(audioPlayerServiceProvider).speedStream;
});

final loopModeStreamProvider = StreamProvider<LoopMode>((ref) {
  return ref.watch(audioPlayerServiceProvider).loopModeStream;
});

final shuffleModeStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(audioPlayerServiceProvider).shuffleModeStream;
});

final currentIndexStreamProvider = StreamProvider<int?>((ref) {
  return ref.watch(audioPlayerServiceProvider).currentIndexStream;
});

// ── Player controller ────────────────────────────────────────────────────────
class AudioPlayerNotifier extends StateNotifier<AsyncValue<void>> {
  final AudioPlayerService _service;
  final Ref _ref;

  AudioPlayerNotifier(this._service, this._ref)
      : super(const AsyncData(null)) {
    _service.init();
  }

  Future<void> playAudio(AudioModel audio, List<AudioModel> queue) async {
    _ref.read(currentTrackProvider.notifier).state = audio;
    final index = queue.indexWhere((a) => a.id == audio.id);
    await _service.playQueue(queue, startIndex: index >= 0 ? index : 0);
  }

  Future<void> pause() async => _service.pause();

  Future<void> playPause() async {
    if (_service.isPlaying) {
      await _service.pause();
    } else {
      await _service.play();
    }
  }

  Future<void> next() async {
    await _service.seekToNext();
    final idx = _service.currentIndex;
    if (idx < _service.queue.length) {
      _ref.read(currentTrackProvider.notifier).state = _service.queue[idx];
    }
  }

  Future<void> previous() async {
    if (_service.position.inSeconds > 3) {
      await _service.seek(Duration.zero);
    } else {
      await _service.seekToPrevious();
      final idx = _service.currentIndex;
      if (idx < _service.queue.length) {
        _ref.read(currentTrackProvider.notifier).state = _service.queue[idx];
      }
    }
  }

  Future<void> seek(Duration position) => _service.seek(position);
  Future<void> setSpeed(double speed) => _service.setSpeed(speed);

  Future<void> toggleLoopMode() async {
    final current = _service.playerState.processingState;
    final loopMode = await _service.loopModeStream.first;
    switch (loopMode) {
      case LoopMode.off:
        await _service.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        await _service.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        await _service.setLoopMode(LoopMode.off);
        break;
    }
  }

  Future<void> toggleShuffle() async {
    final current = await _service.shuffleModeStream.first;
    await _service.setShuffleModeEnabled(!current);
  }
}

final audioPlayerNotifierProvider =
    StateNotifierProvider<AudioPlayerNotifier, AsyncValue<void>>((ref) {
  return AudioPlayerNotifier(
    ref.watch(audioPlayerServiceProvider),
    ref,
  );
});
