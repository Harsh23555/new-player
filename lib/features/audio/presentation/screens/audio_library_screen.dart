import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/models/audio_model.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../providers/audio_library_provider.dart';
import '../../providers/audio_player_provider.dart';

class AudioLibraryScreen extends ConsumerStatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  ConsumerState<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends ConsumerState<AudioLibraryScreen> {
  final _searchController = TextEditingController();
  final _onAudioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(audioLibraryProvider);
      if (state.tracks.isEmpty) {
        ref.read(audioLibraryProvider.notifier).scanLibrary();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioLibraryProvider);
    final filter = ref.watch(audioFilterProvider);
    final tracks = ref.watch(filteredAudioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.read(audioLibraryProvider.notifier).scanLibrary(),
            tooltip: 'Rescan',
          ),
          _SortFilterButton(
            currentSort: filter.sortBy,
            ascending: filter.ascending,
            onChanged: (sortBy, asc) {
              ref.read(audioFilterProvider.notifier).state =
                  filter.copyWith(sortBy: sortBy, ascending: asc);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: NovaSearchBar(
              hint: 'Search songs, artists, albums…',
              controller: _searchController,
              onChanged: (q) {
                ref
                    .read(audioFilterProvider.notifier)
                    .state = filter.copyWith(searchQuery: q);
              },
            ),
          ),
          _buildChips(context, filter, tracks.length),
          Expanded(
            child: _buildBody(context, state, tracks),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(
      BuildContext context, AudioLibraryFilter filter, int count) {
    return SizedBox(
      height: 44,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _chip(context, '$count songs', Icons.library_music_rounded,
              AppTheme.primaryViolet),
          const SizedBox(width: 8),
          _chip(
              context,
              filter.ascending ? 'A-Z' : 'Z-A',
              filter.ascending
                  ? Icons.sort_by_alpha_rounded
                  : Icons.sort_rounded,
              AppTheme.accentCyan,
              onTap: () {
                ref.read(audioFilterProvider.notifier).state =
                    filter.copyWith(ascending: !filter.ascending);
              }),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context, String label, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: color),
      onPressed: onTap,
      side: BorderSide(color: color.withOpacity(0.3)),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }

  Widget _buildBody(BuildContext context, AudioLibraryState state,
      List<AudioModel> tracks) {
    switch (state.status) {
      case ScanStatus.scanning:
        return const ShimmerList();
      case ScanStatus.error:
        return EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Something went wrong',
          subtitle: state.error ?? 'Unknown error',
          actionLabel: 'Retry',
          onAction: () =>
              ref.read(audioLibraryProvider.notifier).scanLibrary(),
        );
      case ScanStatus.idle:
      case ScanStatus.done:
        if (tracks.isEmpty) {
          return EmptyState(
            icon: Icons.audiotrack_rounded,
            title: 'No Audio Files Found',
            subtitle: 'Tap scan to search your device for audio files',
            actionLabel: 'Scan Now',
            onAction: () =>
                ref.read(audioLibraryProvider.notifier).scanLibrary(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: tracks.length,
          itemBuilder: (context, i) {
            final track = tracks[i];
            return _AudioTile(
              track: track,
              index: i,
              onTap: () {
                ref
                    .read(audioPlayerNotifierProvider.notifier)
                    .playAudio(track, tracks);
                context.push(AppRoutes.audioPlayer, extra: track);
              },
              onFavorite: () => ref
                  .read(audioLibraryProvider.notifier)
                  .toggleFavorite(track),
            );
          },
        );
    }
  }
}

class _AudioTile extends StatelessWidget {
  final AudioModel track;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _AudioTile({
    required this.track,
    required this.index,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.darkCard.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.darkBorder, width: 0.5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: QueryArtworkWidget(
                    id: int.tryParse(track.id.toString()) ?? 0,
                    type: ArtworkType.AUDIO,
                    artworkWidth: 52,
                    artworkHeight: 52,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: MediaArtwork(
                      path: track.artworkPath,
                      size: 52,
                      radius: 10,
                      fallbackIcon: Icons.audiotrack_rounded,
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.album_rounded,
                              size: 11,
                              color: AppTheme.darkTextMuted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              track.album,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.darkTextMuted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      track.formattedDuration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryViolet,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: onFavorite,
                      child: Icon(
                        track.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: track.isFavorite
                            ? AppTheme.accentPink
                            : AppTheme.darkTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 20)).fadeIn().slideX(begin: 0.04);
  }
}

class _SortFilterButton extends StatelessWidget {
  final String currentSort;
  final bool ascending;
  final void Function(String, bool) onChanged;

  const _SortFilterButton({
    required this.currentSort,
    required this.ascending,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort_rounded),
      tooltip: 'Sort',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => _SortSheet(
            currentSort: currentSort,
            ascending: ascending,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

class _SortSheet extends StatelessWidget {
  final String currentSort;
  final bool ascending;
  final void Function(String, bool) onChanged;

  const _SortSheet({
    required this.currentSort,
    required this.ascending,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      ('title', 'Title', Icons.title_rounded),
      ('artist', 'Artist', Icons.person_rounded),
      ('album', 'Album', Icons.album_rounded),
      ('duration', 'Duration', Icons.timer_rounded),
      ('dateAdded', 'Date Added', Icons.calendar_today_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort By', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...options.map((o) => ListTile(
                leading: Icon(o.$3,
                    color: currentSort == o.$1
                        ? AppTheme.primaryViolet
                        : null),
                title: Text(o.$2),
                trailing: currentSort == o.$1
                    ? Icon(
                        ascending
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: AppTheme.primaryViolet,
                        size: 18,
                      )
                    : null,
                selected: currentSort == o.$1,
                selectedTileColor:
                    AppTheme.primaryViolet.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  final newAsc =
                      currentSort == o.$1 ? !ascending : true;
                  onChanged(o.$1, newAsc);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}
