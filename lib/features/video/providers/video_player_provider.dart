import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/video_model.dart';
import '../../../data/repositories/recently_played_repository.dart';
import '../../../data/repositories/video_repository.dart';

// Current video being played
final currentVideoProvider = StateProvider<VideoModel?>((ref) => null);

// Video playback speed
final videoSpeedProvider = StateProvider<double>((ref) => 1.0);

// Video lock controls
final videoControlsLockedProvider = StateProvider<bool>((ref) => false);

// Video brightness (0.0 to 1.0)
final videoBrightnessProvider = StateProvider<double>((ref) => 0.5);

// Video volume (0.0 to 1.0)
final videoVolumeProvider = StateProvider<double>((ref) => 1.0);

class VideoPlayerState {
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final String? error;
  final double aspectRatio;

  const VideoPlayerState({
    this.controller,
    this.isInitialized = false,
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.error,
    this.aspectRatio = 16 / 9,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? isInitialized,
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    String? error,
    double? aspectRatio,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      error: error,
      aspectRatio: aspectRatio ?? this.aspectRatio,
    );
  }

  double get progress {
    if (duration.inMilliseconds <= 0) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  final Ref _ref;

  VideoPlayerNotifier(this._ref) : super(const VideoPlayerState());

  Future<void> loadVideo(VideoModel video, {int resumePositionMs = 0}) async {
    // Dispose old controller
    await _disposeController();

    state = const VideoPlayerState();
    _ref.read(currentVideoProvider.notifier).state = video;

    try {
      final controller = VideoPlayerController.file(
        File(video.path),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );

      await controller.initialize();

      controller.addListener(_onControllerUpdate);

      if (resumePositionMs > 1000) {
        await controller.seekTo(Duration(milliseconds: resumePositionMs));
      }

      state = state.copyWith(
        controller: controller,
        isInitialized: true,
        duration: controller.value.duration,
        aspectRatio: controller.value.aspectRatio > 0
            ? controller.value.aspectRatio
            : 16 / 9,
      );

      await controller.play();

      // Track in recently played
      await _ref
          .read(recentlyPlayedRepositoryProvider)
          .addOrUpdate(
            mediaPath: video.path,
            mediaType: 'video',
            title: video.title,
            subtitle: video.duration,
            artworkPath: video.thumbnailPath,
            positionMs: resumePositionMs,
          );

      // Increment play count
      await _ref.read(videoRepositoryProvider).incrementPlayCount(video.id);
    } catch (e, st) {
      AppLogger.error('VideoPlayerNotifier.loadVideo failed',
          error: e, stackTrace: st);
      state = state.copyWith(error: e.toString());
    }
  }

  void _onControllerUpdate() {
    final ctrl = state.controller;
    if (ctrl == null) return;
    final value = ctrl.value;
    state = state.copyWith(
      isPlaying: value.isPlaying,
      isBuffering: value.isBuffering,
      position: value.position,
      duration: value.duration,
      error: value.hasError ? value.errorDescription : null,
    );
  }

  Future<void> play() async {
    await state.controller?.play();
  }

  Future<void> pause() async {
    await state.controller?.pause();
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await state.controller?.seekTo(position);
  }

  Future<void> seekBy(Duration delta) async {
    final current = state.position;
    final target = current + delta;
    final clamped = Duration(
      milliseconds: target.inMilliseconds.clamp(0, state.duration.inMilliseconds),
    );
    await seekTo(clamped);
  }

  Future<void> setSpeed(double speed) async {
    await state.controller?.setPlaybackSpeed(speed);
    _ref.read(videoSpeedProvider.notifier).state = speed;
  }

  Future<void> setVolume(double volume) async {
    await state.controller?.setVolume(volume.clamp(0.0, 1.0));
    _ref.read(videoVolumeProvider.notifier).state = volume.clamp(0.0, 1.0);
  }

  Future<void> saveResumePosition() async {
    final video = _ref.read(currentVideoProvider);
    if (video == null) return;
    await _ref
        .read(recentlyPlayedRepositoryProvider)
        .updatePosition(video.path, state.position.inMilliseconds);
  }

  Future<void> _disposeController() async {
    final ctrl = state.controller;
    if (ctrl != null) {
      await saveResumePosition();
      ctrl.removeListener(_onControllerUpdate);
      await ctrl.dispose();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider.autoDispose<VideoPlayerNotifier, VideoPlayerState>(
        (ref) {
  return VideoPlayerNotifier(ref);
});
