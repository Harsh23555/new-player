import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/models/video_model.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../providers/video_library_provider.dart';

class VideoLibraryScreen extends ConsumerStatefulWidget {
  const VideoLibraryScreen({super.key});

  @override
  ConsumerState<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends ConsumerState<VideoLibraryScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(videoLibraryProvider);
      if (state.videos.isEmpty) {
        ref.read(videoLibraryProvider.notifier).scanLibrary();
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
    final state = ref.watch(videoLibraryProvider);
    final filter = ref.watch(videoFilterProvider);
    final videos = ref.watch(filteredVideoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Library'),
        actions: [
          IconButton(
            icon: Icon(
                _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                ref.read(videoLibraryProvider.notifier).scanLibrary(),
          ),
          _VideoSortButton(
            currentSort: filter.sortBy,
            ascending: filter.ascending,
            onChanged: (sortBy, asc) {
              ref.read(videoFilterProvider.notifier).state =
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
              hint: 'Search videos…',
              controller: _searchController,
              onChanged: (q) {
                ref.read(videoFilterProvider.notifier).state =
                    filter.copyWith(searchQuery: q);
              },
            ),
          ),
          _buildStats(context, videos.length),
          Expanded(child: _buildBody(context, state, videos)),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.videocam_rounded,
              color: AppTheme.accentCyan, size: 16),
          const SizedBox(width: 6),
          Text('$count videos',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.accentCyan)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, VideoLibraryState state,
      List<VideoModel> videos) {
    switch (state.status) {
      case ScanStatus.scanning:
        return _isGridView
            ? const ShimmerGrid()
            : const ShimmerList(itemHeight: 88);
      case ScanStatus.error:
        return EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Scan Error',
          subtitle: state.error ?? 'Failed to scan videos',
          actionLabel: 'Retry',
          onAction: () =>
              ref.read(videoLibraryProvider.notifier).scanLibrary(),
        );
      case ScanStatus.idle:
      case ScanStatus.done:
        if (videos.isEmpty) {
          return EmptyState(
            icon: Icons.video_library_rounded,
            title: 'No Videos Found',
            subtitle: 'Tap scan to search your device for video files',
            actionLabel: 'Scan Now',
            onAction: () =>
                ref.read(videoLibraryProvider.notifier).scanLibrary(),
          );
        }
        return _isGridView
            ? _buildGrid(context, videos)
            : _buildList(context, videos);
    }
  }

  Widget _buildGrid(BuildContext context, List<VideoModel> videos) {
    final filter = ref.watch(videoFilterProvider);
    final cols = int.tryParse(filter.gridColumns.toString()) ?? 2;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 16 / 11,
      ),
      itemCount: videos.length,
      itemBuilder: (context, i) => _VideoGridCard(
        video: videos[i],
        index: i,
        onTap: () =>
            context.push(AppRoutes.videoPlayer, extra: videos[i]),
        onFavorite: () => ref
            .read(videoLibraryProvider.notifier)
            .toggleFavorite(videos[i]),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<VideoModel> videos) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: videos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _VideoListTile(
        video: videos[i],
        index: i,
        onTap: () =>
            context.push(AppRoutes.videoPlayer, extra: videos[i]),
        onFavorite: () => ref
            .read(videoLibraryProvider.notifier)
            .toggleFavorite(videos[i]),
      ),
    );
  }
}

class _VideoGridCard extends StatelessWidget {
  final VideoModel video;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _VideoGridCard({
    required this.video,
    required this.index,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail
              video.thumbnailPath != null &&
                      File(video.thumbnailPath!).existsSync()
                  ? Image.file(
                      File(video.thumbnailPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              // Duration badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(video.duration,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ),
              ),

              // Resolution badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(video.resolution,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
              ),

              // Title / size
              Positioned(
                bottom: 6,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                    Text(video.formattedSize,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9)),
                  ],
                ),
              ),

              // Favorite button
              Positioned(
                bottom: 4,
                right: 6,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Icon(
                    video.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: video.isFavorite
                        ? AppTheme.accentPink
                        : Colors.white54,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 25)).fadeIn().scale(
        begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.darkCardAlt,
      child: const Center(
        child: Icon(Icons.video_file_rounded,
            color: AppTheme.accentCyan, size: 36),
      ),
    );
  }
}

class _VideoListTile extends StatelessWidget {
  final VideoModel video;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _VideoListTile({
    required this.video,
    required this.index,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.darkCard.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.darkBorder, width: 0.5),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 108,
                  height: 62,
                  child: video.thumbnailPath != null &&
                          File(video.thumbnailPath!).existsSync()
                      ? Image.file(File(video.thumbnailPath!),
                          fit: BoxFit.cover)
                      : Container(
                          color: AppTheme.darkCardAlt,
                          child: const Center(
                            child: Icon(Icons.video_file_rounded,
                                color: AppTheme.accentCyan),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(children: [
                      _badge(video.duration, AppTheme.accentCyan),
                      const SizedBox(width: 6),
                      _badge(video.formattedSize, AppTheme.primaryViolet),
                      const SizedBox(width: 6),
                      _badge(video.resolution, AppTheme.accentGold),
                    ]),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  video.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: video.isFavorite
                      ? AppTheme.accentPink
                      : AppTheme.darkTextMuted,
                  size: 18,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 20)).fadeIn().slideX(begin: 0.04);
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _VideoSortButton extends StatelessWidget {
  final String currentSort;
  final bool ascending;
  final void Function(String, bool) onChanged;

  const _VideoSortButton({
    required this.currentSort,
    required this.ascending,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort_rounded),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort By', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...[
                  ('titleVideo', 'Title', Icons.title_rounded),
                  ('dateAdded', 'Date Added', Icons.calendar_today_rounded),
                  ('duration', 'Duration', Icons.timer_rounded),
                  ('size', 'File Size', Icons.storage_rounded),
                ].map((o) => ListTile(
                      leading: Icon(o.$3,
                          color: currentSort == o.$1
                              ? AppTheme.accentCyan
                              : null),
                      title: Text(o.$2),
                      trailing: currentSort == o.$1
                          ? Icon(
                              ascending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color: AppTheme.accentCyan,
                              size: 16,
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onTap: () {
                        final newAsc =
                            currentSort == o.$1 ? !ascending : false;
                        onChanged(o.$1 == 'titleVideo' ? 'title' : o.$1, newAsc);
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
