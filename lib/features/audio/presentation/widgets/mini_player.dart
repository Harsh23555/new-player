import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/models/audio_model.dart';
import '../../providers/audio_player_provider.dart';
import 'package:go_router/go_router.dart';

class MiniPlayer extends ConsumerWidget {
  final AudioModel track;
  const MiniPlayer({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerStateAsync = ref.watch(playerStateStreamProvider);
    final positionAsync = ref.watch(positionStreamProvider);
    final durationAsync = ref.watch(durationStreamProvider);
    final isPlaying = playerStateAsync.valueOrNull?.playing ?? false;
    final position = positionAsync.valueOrNull ?? Duration.zero;
    final duration = durationAsync.valueOrNull ?? Duration.zero;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.audioPlayer, extra: track),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: QueryArtworkWidget(
              id: track.id,
              type: ArtworkType.AUDIO,
              artworkWidth: 46,
              artworkHeight: 46,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryViolet, AppTheme.primaryDeep],
                  ),
                ),
                child: const Icon(Icons.audiotrack_rounded,
                    color: Colors.white60, size: 22),
              ),
              keepOldArtwork: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppTheme.darkBorder,
                  color: AppTheme.primaryViolet,
                  minHeight: 2,
                  borderRadius: BorderRadius.circular(1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () =>
                ref.read(audioPlayerNotifierProvider.notifier).previous(),
            icon: const Icon(Icons.skip_previous_rounded, size: 22),
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () =>
                ref.read(audioPlayerNotifierProvider.notifier).playPause(),
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 26,
            ),
            color: AppTheme.primaryViolet,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: () =>
                ref.read(audioPlayerNotifierProvider.notifier).next(),
            icon: const Icon(Icons.skip_next_rounded, size: 22),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
