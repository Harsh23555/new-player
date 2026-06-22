import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/media_utils.dart';
import '../../../../data/models/video_model.dart';
import '../../../../data/repositories/recently_played_repository.dart';
import '../../providers/video_player_provider.dart';

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
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initVideo() async {
    // Get resume position from recently played
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

  void _showControls() {
    if (!_controlsVisible) {
      setState(() => _controlsVisible = true);
    }
    _startControlsTimer();
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
            // Video layer
            _buildVideoPlayer(playerState),

            // Gesture layer
            _buildGestureLayer(context, playerState),

            // Volume overlay
            if (_showVolumeOverlay) _buildVolumeOverlay(),

            // Brightness overlay
            if (_showBrightnessOverlay) _buildBrightnessOverlay(),

            // Seek gesture overlay
            if (_isSeeking) _buildSeekGestureOverlay(playerState),

            // Controls overlay
            AnimatedOpacity(
              opacity: _controlsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: _buildControls(context, playerState, speed),
            ),

            // Speed panel
            if (_showSpeedPanel && _controlsVisible)
              _buildSpeedPanel(context, speed),

            // Loading/Error overlay
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
      return const SizedBox.expand(
          child: ColoredBox(color: Colors.black));
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
          _showSeekIndicator(false);
        } else {
          ref.read(videoPlayerProvider.notifier).seekBy(const Duration(seconds: 10));
          _showSeekIndicator(true);
        }
      },
      onDoubleTap: () {}, // Required for onDoubleTapDown to fire
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
          // Volume control
          _dragVolume = (_panStartVolume + delta * 2).clamp(0.0, 1.0);
          ref.read(videoPlayerProvider.notifier).setVolume(_dragVolume);
          setState(() {
            _showVolumeOverlay = true;
            _showBrightnessOverlay = false;
          });
        } else {
          // Brightness control
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
          if (mounted) {
            setState(() {
              _showVolumeOverlay = false;
              _showBrightnessOverlay = false;
            });
          }
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

  bool _seekForward = true;
  void _showSeekIndicator(bool forward) {
    setState(() => _seekForward = forward);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() {});
    });
  }

  Widget _buildVolumeOverlay() {
    final vol = ref.watch(videoVolumeProvider);
    return Positioned(
      right: 24,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                vol > 0.5
                    ? Icons.volume_up_rounded
                    : vol > 0
                        ? Icons.volume_down_rounded
                        : Icons.volume_mute_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: LinearProgressIndicator(
                    value: vol,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(vol * 100).round()}%',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrightnessOverlay() {
    final brightness = ref.watch(videoBrightnessProvider);
    return Positioned(
      left: 24,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                brightness > 0.5
                    ? Icons.brightness_high_rounded
                    : Icons.brightness_low_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: LinearProgressIndicator(
                    value: brightness,
                    color: Colors.yellow,
                    backgroundColor: Colors.white24,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(brightness * 100).round()}%',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekGestureOverlay(VideoPlayerState state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _seekGesturePosition > state.position
                  ? Icons.fast_forward_rounded
                  : Icons.fast_rewind_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              MediaUtils.formatDuration(_seekGesturePosition),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    VideoPlayerState playerState,
    double speed,
  ) {
    return Stack(
      children: [
        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(videoPlayerProvider.notifier).saveResumePosition();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                ),
                Expanded(
                  child: Text(
                    widget.video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => _showSpeedPanel = !_showSpeedPanel),
                  icon: Text(
                    '${speed}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tooltip: 'Playback Speed',
                ),
                IconButton(
                  onPressed: _enterPiP,
                  icon: const Icon(Icons.picture_in_picture_alt_rounded,
                      color: Colors.white),
                  tooltip: 'Picture in Picture',
                ),
                IconButton(
                  onPressed: () {
                    final locked = ref.read(videoControlsLockedProvider);
                    ref.read(videoControlsLockedProvider.notifier).state =
                        !locked;
                  },
                  icon: Icon(
                    ref.watch(videoControlsLockedProvider)
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Lock Controls',
                ),
              ],
            ),
          ),
        ),

        // Center play/pause button
        Center(
          child: GestureDetector(
            onTap: () =>
                ref.read(videoPlayerProvider.notifier).togglePlayPause(),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                playerState.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: AppTheme.primaryViolet,
                    inactiveTrackColor: Colors.white30,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white30,
                  ),
                  child: Slider(
                    value: playerState.progress,
                    onChangeStart: (_) {
                      setState(() => _seeking = true);
                      _controlsTimer?.cancel();
                    },
                    onChanged: (v) {
                      final ms = (v * playerState.duration.inMilliseconds)
                          .toInt();
                      setState(() {
                        _seekGesturePosition = Duration(milliseconds: ms);
                      });
                    },
                    onChangeEnd: (v) {
                      final ms = (v * playerState.duration.inMilliseconds)
                          .toInt();
                      ref
                          .read(videoPlayerProvider.notifier)
                          .seekTo(Duration(milliseconds: ms));
                      setState(() => _seeking = false);
                      _startControlsTimer();
                    },
                  ),
                ),
                // Time labels + buttons
                Row(
                  children: [
                    Text(
                      MediaUtils.formatDuration(playerState.position),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      ' / ',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      MediaUtils.formatDuration(playerState.duration),
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12),
                    ),
                    const Spacer(),
                    // Skip backward
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => ref
                          .read(videoPlayerProvider.notifier)
                          .seekBy(const Duration(seconds: -10)),
                      icon: const Icon(Icons.replay_10_rounded,
                          color: Colors.white, size: 22),
                    ),
                    // Skip forward
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => ref
                          .read(videoPlayerProvider.notifier)
                          .seekBy(const Duration(seconds: 10)),
                      icon: const Icon(Icons.forward_10_rounded,
                          color: Colors.white, size: 22),
                    ),
                    // Info / resolution
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.video.resolution,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Buffering indicator
        if (playerState.isBuffering)
          const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildSpeedPanel(BuildContext context, double currentSpeed) {
    return Positioned(
      top: 60,
      right: 12,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _speeds.map((s) {
            final isSelected = (s - currentSpeed).abs() < 0.01;
            return InkWell(
              onTap: () {
                ref.read(videoPlayerProvider.notifier).setSpeed(s);
                setState(() => _showSpeedPanel = false);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${s}x',
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryViolet : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryViolet),
          SizedBox(height: 16),
          Text('Loading video…',
              style: TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildErrorOverlay(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Colors.redAccent, size: 64),
          const SizedBox(height: 16),
          const Text('Failed to play video',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(error,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initVideo,
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryViolet,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back',
                style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}
