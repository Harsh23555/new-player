import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/audio_model.dart';
import '../../../../data/services/audio_player_service.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../providers/audio_player_provider.dart';
import '../../providers/audio_library_provider.dart';
import '../../providers/sleep_timer_provider.dart';
import 'package:nova_player/shared/providers/global_equalizer_provider.dart';
import '../widgets/equalizer_sheet.dart';

class AudioPlayerScreen extends ConsumerStatefulWidget {
  final AudioModel? initialAudio;
  const AudioPlayerScreen({super.key, this.initialAudio});

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(audioPlayerNotifierProvider.notifier);
      final track = widget.initialAudio;
      if (track != null) {
        final queue = ref.read(filteredAudioProvider);
        notifier.playAudio(track, queue.isEmpty ? [track] : queue);
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = ref.watch(currentTrackProvider);
    final playerStateAsync = ref.watch(playerStateStreamProvider);
    final positionAsync = ref.watch(positionStreamProvider);
    final durationAsync = ref.watch(durationStreamProvider);
    final speedAsync = ref.watch(speedStreamProvider);
    final loopAsync = ref.watch(loopModeStreamProvider);
    final shuffleAsync = ref.watch(shuffleModeStreamProvider);

    final isPlaying = playerStateAsync.valueOrNull?.playing ?? false;
    final position = positionAsync.valueOrNull ?? Duration.zero;
    final duration = durationAsync.valueOrNull ?? Duration.zero;
    final speed = speedAsync.valueOrNull ?? 1.0;
    final loopMode = loopAsync.valueOrNull ?? LoopMode.off;
    final shuffle = shuffleAsync.valueOrNull ?? false;

    if (isPlaying) {
      _rotationController.forward();
    } else {
      _rotationController.stop();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.darkBg, Color(0xFF0F0820), AppTheme.darkBg],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildArtwork(track),
                    _buildTrackInfo(context, track),
                    _buildProgressBar(context, position, duration),
                    _buildControls(context, isPlaying, loopMode, shuffle),
                    _buildSpeedControl(context, speed),
                    _buildQueue(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final sleepTimer = ref.watch(sleepTimerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          ),
          Expanded(
            child: Column(
              children: [
                Text('NOW PLAYING',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.darkTextMuted,
                          letterSpacing: 2,
                          fontSize: 10,
                        )),
                if (sleepTimer.isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined, size: 12, color: AppTheme.accentCyan),
                        const SizedBox(width: 4),
                        Text(
                          _fmt(sleepTimer.remaining),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.accentCyan,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showSleepTimerDialog(context),
            icon: Icon(
              Icons.timer_rounded,
              color: sleepTimer.isActive ? AppTheme.accentCyan : null,
            ),
          ),
          IconButton(
            onPressed: () => _showEqualizer(context),
            icon: Consumer(builder: (context, ref, _) {
              final eq = ref.watch(globalEqProvider);
              return Icon(
                Icons.equalizer_rounded,
                color: eq.enabled ? AppTheme.primaryViolet : null,
              );
            }),
          ),
          IconButton(
            onPressed: () => _showOptions(context),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }

  void _showEqualizer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EqualizerSheet(),
    );
  }

  void _showSleepTimerDialog(BuildContext context) {
    final notifier = ref.read(sleepTimerProvider.notifier);
    final playerNotifier = ref.read(audioPlayerNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.timer_rounded, color: AppTheme.primaryViolet),
                  const SizedBox(width: 12),
                  Text('Sleep Timer',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            const Divider(),
            ...[15, 30, 45, 60].map((mins) => ListTile(
                  leading: const Icon(Icons.access_time_rounded),
                  title: Text('$mins Minutes'),
                  onTap: () {
                    notifier.start(Duration(minutes: mins), onExpire: () {
                      playerNotifier.pause();
                    });
                    Navigator.pop(ctx);
                  },
                )),
            ListTile(
              leading: const Icon(Icons.timer_off_rounded, color: Colors.red),
              title: const Text('Cancel Timer', style: TextStyle(color: Colors.red)),
              onTap: () {
                notifier.cancel();
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork(AudioModel? track) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 6.28,
          child: child,
        );
      },
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryViolet.withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: ClipOval(
          child: track != null
              ? QueryArtworkWidget(
                  id: track.id,
                  type: ArtworkType.AUDIO,
                  artworkWidth: 240,
                  artworkHeight: 240,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: Container(
                    width: 240,
                    height: 240,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryViolet,
                          AppTheme.primaryDeep,
                        ],
                      ),
                    ),
                    child: const Icon(Icons.audiotrack_rounded,
                        size: 90, color: Colors.white54),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryViolet, AppTheme.primaryDeep],
                    ),
                  ),
                  child: const Icon(Icons.audiotrack_rounded,
                      size: 90, color: Colors.white54),
                ),
        ),
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.elasticOut);
  }

  Widget _buildTrackInfo(BuildContext context, AudioModel? track) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track?.title ?? 'Unknown Track',
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  track?.artist ?? 'Unknown Artist',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryViolet,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (track != null) {
                ref
                    .read(audioLibraryProvider.notifier)
                    .toggleFavorite(track);
              }
            },
            icon: Icon(
              track?.isFavorite == true
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: track?.isFavorite == true
                  ? AppTheme.accentPink
                  : AppTheme.darkTextSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      BuildContext context, Duration position, Duration duration) {
    final notifier = ref.read(audioPlayerNotifierProvider.notifier);
    final total = duration.inMilliseconds.toDouble();
    final current = position.inMilliseconds.toDouble().clamp(0, total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: AppTheme.primaryViolet,
              inactiveTrackColor: AppTheme.darkBorder,
              thumbColor: Colors.white,
              overlayColor: AppTheme.primaryViolet.withOpacity(0.2),
            ),
            child: Slider(
              value: total > 0 ? current / total : 0,
              onChanged: (v) {
                final pos = Duration(milliseconds: (v * total).toInt());
                notifier.seek(pos);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(position),
                    style: Theme.of(context).textTheme.bodySmall),
                Text(_fmt(duration),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, bool isPlaying,
      LoopMode loopMode, bool shuffle) {
    final notifier = ref.read(audioPlayerNotifierProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          IconButton(
            icon: Icon(
              Icons.shuffle_rounded,
              color:
                  shuffle ? AppTheme.primaryViolet : AppTheme.darkTextMuted,
            ),
            onPressed: () => notifier.toggleShuffle(),
            iconSize: 22,
          ),
          // Previous
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: () => notifier.previous(),
            iconSize: 32,
          ),
          // Play/Pause
          GestureDetector(
            onTap: () => notifier.playPause(),
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryViolet, AppTheme.primaryDeep],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryViolet.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          // Next
          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: () => notifier.next(),
            iconSize: 32,
          ),
          // Loop
          IconButton(
            icon: Icon(
              loopMode == LoopMode.one
                  ? Icons.repeat_one_rounded
                  : Icons.repeat_rounded,
              color: loopMode != LoopMode.off
                  ? AppTheme.primaryViolet
                  : AppTheme.darkTextMuted,
            ),
            onPressed: () => notifier.toggleLoopMode(),
            iconSize: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedControl(BuildContext context, double speed) {
    final notifier = ref.read(audioPlayerNotifierProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.speed_rounded,
            color: AppTheme.darkTextMuted, size: 16),
        const SizedBox(width: 8),
        ...([0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((s) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => notifier.setSpeed(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: speed == s
                        ? AppTheme.primaryViolet
                        : AppTheme.darkCardAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${s}x',
                    style: TextStyle(
                      color: speed == s
                          ? Colors.white
                          : AppTheme.darkTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ))),
      ],
    );
  }

  Widget _buildQueue(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showQueue(context),
      icon: const Icon(Icons.queue_music_rounded, size: 18),
      label: const Text('Queue'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.darkTextSecondary,
      ),
    );
  }

  void _showQueue(BuildContext context) {
    final queue = ref.read(audioPlayerServiceProvider).queue;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Text('Queue', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                Text('${queue.length} tracks',
                    style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: queue.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: MediaArtwork(
                    path: queue[i].artworkPath,
                    size: 40,
                    radius: 8,
                  ),
                  title: Text(queue[i].title, maxLines: 1),
                  subtitle: Text(queue[i].artist, maxLines: 1),
                  trailing: Text(queue[i].formattedDuration,
                      style: Theme.of(context).textTheme.bodySmall),
                  onTap: () {
                    ref.read(audioPlayerServiceProvider).skipToIndex(i);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('Song Info'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline_rounded, color: Colors.red),
              title: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(ctx); // close options sheet
                final track = ref.read(currentTrackProvider);
                if (track == null) return;
                final ok =
                    await showConfirmDeleteDialog(context, track.title);
                if (ok) {
                  // Stop playback first
                  await ref
                      .read(audioPlayerNotifierProvider.notifier)
                      .pause();
                  await ref
                      .read(audioLibraryProvider.notifier)
                      .deleteTrack(track);
                  if (mounted) {
                    Navigator.pop(context); // pop player screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('"${track.title}" deleted')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
