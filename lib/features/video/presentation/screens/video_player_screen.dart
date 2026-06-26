import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:nova_player/core/theme/app_theme.dart';
import 'package:nova_player/core/utils/media_utils.dart';
import 'package:nova_player/data/models/video_model.dart';
import 'package:nova_player/data/repositories/recently_played_repository.dart';
import 'package:nova_player/features/video/providers/video_player_provider.dart';
import 'package:nova_player/features/video/presentation/widgets/video_equalizer_sheet.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final VideoModel video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with WidgetsBindingObserver {
  // Controls visibility
  bool _controlsVisible = true;
  Timer? _controlsTimer;
  bool _seeking = false;
  bool _isFullscreen = false;

  // Gesture state
  bool _showVolumeOverlay = false;
  bool _showBrightnessOverlay = false;
  double _dragVolume = 1.0;
  double _dragBrightness = 0.5;
  double _panStartVolume = 1.0;
  double _panStartBrightness = 0.5;
  bool _isRightSide = false;
  double _seekStartX = 0;
  Duration _seekGesturePosition = Duration.zero;
  bool _isSeeking = false;

  // Speed panel
  bool _showSpeedPanel = false;
  final List<double> _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  /// PiP method channel
  static const _pipChannel = MethodChannel('com.novaplayer.app/pip');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _setImmersive();
    _initVideo();
    _startControlsTimer();
  }

  Future<void> _setImmersive() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initVideo() async {
    final repo = ref.read(recentlyPlayedRepositoryProvider);
    final recent = await repo.getByPath(widget.video.path);
    final resumeMs = recent?.positionMs ?? 0;

    await ref
        .read(videoPlayerProvider.notifier)
        .loadVideo(widget.video, resumePositionMs: resumeMs);
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_seeking) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) _startControlsTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused) {
      ref.read(videoPlayerProvider.notifier).pause();
      ref.read(videoPlayerProvider.notifier).saveResumePosition();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _controlsTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _toggleFullscreen() async {
    final next = !_isFullscreen;
    setState(() => _isFullscreen = next);
    if (next) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  Future<void> _enterPiP() async {
    try {
      await _pipChannel.invokeMethod('enterPiP');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Picture-in-Picture not supported on this device'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(videoPlayerProvider);
    final speed = ref.watch(videoSpeedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _buildVideoPlayer(playerState),
            _buildGestureLayer(context, playerState),
            if (_showVolumeOverlay) _buildVolumeOverlay(),
            if (_showBrightnessOverlay) _buildBrightnessOverlay(),
            if (_isSeeking) _buildSeekGestureOverlay(playerState),
            AnimatedOpacity(
              opacity: _controlsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: _buildControls(context, playerState, speed),
            ),
            if (_showSpeedPanel && _controlsVisible)
              _buildSpeedPanel(context, speed),
            if (!playerState.isInitialized && playerState.error == null)
              _buildLoadingOverlay(),
            if (playerState.error != null)
              _buildErrorOverlay(playerState.error!),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerState playerState) {
    if (!playerState.isInitialized || playerState.controller == null) {
      return const SizedBox.expand(child: ColoredBox(color: Colors.black));
    }

    return Center(
      child: AspectRatio(
        aspectRatio: playerState.aspectRatio,
        child: VideoPlayer(playerState.controller!),
      ),
    );
  }

  Widget _buildGestureLayer(BuildContext context, VideoPlayerState playerState) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _toggleControls,
      onDoubleTapDown: (details) {
        final x = details.globalPosition.dx;
        if (x < screenWidth / 2) {
          ref.read(videoPlayerProvider.notifier).seekBy(const Duration(seconds: -10));
        } else {
          ref.read(videoPlayerProvider.notifier).seekBy(const Duration(seconds: 10));
        }
      },
      onDoubleTap: () {},
      onVerticalDragStart: (details) {
        _isRightSide = details.localPosition.dx > screenWidth / 2;
        _panStartVolume = ref.read(videoVolumeProvider);
        _panStartBrightness = ref.read(videoBrightnessProvider);
        _dragVolume = _panStartVolume;
        _dragBrightness = _panStartBrightness;
      },
      onVerticalDragUpdate: (details) {
        final delta = -details.delta.dy / screenHeight;
        if (_isRightSide) {
          _dragVolume = (_panStartVolume + delta * 2).clamp(0.0, 1.0);
          ref.read(videoPlayerProvider.notifier).setVolume(_dragVolume);
          setState(() {
            _showVolumeOverlay = true;
            _showBrightnessOverlay = false;
          });
        } else {
          _dragBrightness = (_panStartBrightness + delta * 2).clamp(0.0, 1.0);
          ref.read(videoBrightnessProvider.notifier).state = _dragBrightness;
          setState(() {
            _showBrightnessOverlay = true;
            _showVolumeOverlay = false;
          });
        }
      },
      onVerticalDragEnd: (_) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() { _showVolumeOverlay = false; _showBrightnessOverlay = false; });
        });
      },
      onHorizontalDragStart: (details) {
        _seekStartX = details.localPosition.dx;
        _seekGesturePosition = playerState.position;
        setState(() => _isSeeking = true);
      },
      onHorizontalDragUpdate: (details) {
        final dx = details.localPosition.dx - _seekStartX;
        final seekMs = (dx / 5 * 1000).toInt();
        final newPos = Duration(
          milliseconds: (_seekGesturePosition.inMilliseconds + seekMs)
              .clamp(0, playerState.duration.inMilliseconds),
        );
        setState(() => _seekGesturePosition = newPos);
      },
      onHorizontalDragEnd: (_) {
        ref.read(videoPlayerProvider.notifier).seekTo(_seekGesturePosition);
        setState(() => _isSeeking = false);
      },
      child: Container(color: Colors.transparent),
    );
  }

  Widget _buildVolumeOverlay() {
    final vol = ref.watch(videoVolumeProvider);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(vol > 0.5 ? Icons.volume_up : vol > 0 ? Icons.volume_down : Icons.volume_mute, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text('${(vol * 100).round()}%', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildBrightnessOverlay() {
    final brightness = ref.watch(videoBrightnessProvider);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(brightness > 0.5 ? Icons.brightness_high : Icons.brightness_low, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text('${(brightness * 100).round()}%', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekGestureOverlay(VideoPlayerState state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_seekGesturePosition > state.position ? Icons.fast_forward : Icons.fast_rewind, color: Colors.white),
            const SizedBox(width: 8),
            Text(MediaUtils.formatDuration(_seekGesturePosition), style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, VideoPlayerState playerState, double speed) {
    return Stack(
      children: [
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black87, Colors.transparent])),
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                Expanded(child: Text(widget.video.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                IconButton(
                  onPressed: () => setState(() => _showSpeedPanel = !_showSpeedPanel),
                  icon: Text('${speed}x', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const VideoEqualizerSheet(),
                    );
                  },
                  icon: const Icon(Icons.tune, color: Colors.white),
                ),
                IconButton(onPressed: _enterPiP, icon: const Icon(Icons.picture_in_picture, color: Colors.white)),
                IconButton(
                  onPressed: () {
                    final locked = ref.read(videoControlsLockedProvider);
                    ref.read(videoControlsLockedProvider.notifier).state = !locked;
                  },
                  icon: Icon(ref.watch(videoControlsLockedProvider) ? Icons.lock : Icons.lock_open, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: InkWell(
            onTap: () => ref.read(videoPlayerProvider.notifier).togglePlayPause(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
              child: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 48),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent])),
            child: Column(
              children: [
                Slider(
                  value: playerState.progress,
                  onChanged: (v) {
                    final ms = (v * playerState.duration.inMilliseconds).toInt();
                    ref.read(videoPlayerProvider.notifier).seekTo(Duration(milliseconds: ms));
                  },
                  activeColor: AppTheme.primaryViolet,
                ),
                Row(
                  children: [
                    Text(MediaUtils.formatDuration(playerState.position), style: const TextStyle(color: Colors.white)),
                    const Text(' / ', style: TextStyle(color: Colors.white54)),
                    Text(MediaUtils.formatDuration(playerState.duration), style: const TextStyle(color: Colors.white54)),
                    const Spacer(),
                    IconButton(onPressed: () => ref.read(videoPlayerProvider.notifier).seekBy(const Duration(seconds: -10)), icon: const Icon(Icons.replay_10, color: Colors.white)),
                    IconButton(onPressed: () => ref.read(videoPlayerProvider.notifier).seekBy(const Duration(seconds: 10)), icon: const Icon(Icons.forward_10, color: Colors.white)),
                    IconButton(onPressed: _toggleFullscreen, icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedPanel(BuildContext context, double currentSpeed) {
    return Positioned(
      top: 60, right: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.darkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.darkBorder)),
        child: Column(
          children: _speeds.map((s) => InkWell(
            onTap: () { ref.read(videoPlayerProvider.notifier).setSpeed(s); setState(() => _showSpeedPanel = false); },
            child: Padding(padding: const EdgeInsets.all(8.0), child: Text('${s}x', style: TextStyle(color: s == currentSpeed ? AppTheme.primaryViolet : Colors.white))),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() => const Center(child: CircularProgressIndicator(color: AppTheme.primaryViolet));
  Widget _buildErrorOverlay(String error) => Center(child: Text(error, style: const TextStyle(color: Colors.red)));
}
