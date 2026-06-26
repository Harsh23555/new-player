import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:logger/logger.dart';

import '../../core/services/equalizer_service.dart';
import '../models/audio_model.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

class AudioPlayerService {
  late final AudioPlayer _player;
  final _logger = Logger();

  AudioPlayerService() {
    _player = AudioPlayer();
    
    // Send session ID to native equalizer
    _player.androidAudioSessionIdStream.listen((id) {
      if (id != null && id != 0) {
        EqualizerService.setAudioSessionId(id);
      }
    });
  }


  List<AudioModel> _queue = [];

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<double> get speedStream => _player.speedStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<bool> get shuffleModeStream => _player.shuffleModeEnabledStream;
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  PlayerState get playerState => _player.playerState;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  double get speed => _player.speed;
  bool get isPlaying => _player.playing;
  int get currentIndex => _player.currentIndex ?? 0;
  List<AudioModel> get queue => _queue;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio interruptions
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(0.4);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            _player.pause();
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            _player.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });

    session.becomingNoisyEventStream.listen((_) => _player.pause());
  }

  Future<void> playQueue(List<AudioModel> audios, {int startIndex = 0}) async {
    _queue = audios;

    final sources = audios.map((a) => AudioSource.uri(
      Uri.file(a.path),
      tag: MediaItem(
        id: a.path,
        title: a.title,
        artist: a.artist,
        album: a.album,
        duration: Duration(milliseconds: a.duration),
        artUri: a.artworkPath != null ? Uri.file(a.artworkPath!) : null,
      ),
    )).toList();

    try {
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: startIndex,
        initialPosition: Duration.zero,
      );
      await _player.play();
    } catch (e, st) {
      _logger.e('playQueue error', error: e, stackTrace: st);
    }
  }

  Future<void> playSingle(AudioModel audio) async {
    _queue = [audio];
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.file(audio.path),
          tag: MediaItem(
            id: audio.path,
            title: audio.title,
            artist: audio.artist,
            album: audio.album,
            duration: Duration(milliseconds: audio.duration),
            artUri: audio.artworkPath != null ? Uri.file(audio.artworkPath!) : null,
          ),
        ),
      );
      await _player.play();
    } catch (e, st) {
      _logger.e('playSingle error', error: e, stackTrace: st);
    }
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> seekToNext() => _player.seekToNext();
  Future<void> seekToPrevious() => _player.seekToPrevious();
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  Future<void> setVolume(double vol) => _player.setVolume(vol);

  Future<void> setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> skipToIndex(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  void dispose() {
    _player.dispose();
  }
}
