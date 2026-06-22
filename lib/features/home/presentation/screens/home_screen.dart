import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/audio/providers/audio_library_provider.dart';
import '../../../../features/video/providers/video_library_provider.dart';
import '../../../../features/downloads/providers/download_manager_provider.dart';
import '../../../../features/audio/providers/audio_player_provider.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../data/models/audio_model.dart';
import '../../../../data/models/video_model.dart';
import '../../../audio/presentation/widgets/mini_player.dart';
import '../../providers/recently_played_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioLibraryProvider.notifier).loadFromDb();
      ref.read(videoLibraryProvider.notifier).loadFromDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioLibraryProvider);
    final videoState = ref.watch(videoLibraryProvider);
    final downloadState = ref.watch(downloadManagerProvider);
    final currentTrack = ref.watch(currentTrackProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildGreeting(context),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 28),
                _buildRecentlyPlayed(context),
                const SizedBox(height: 28),
                _buildStatsRow(
                  context,
                  audioCount: audioState.tracks.length,
                  videoCount: videoState.videos.length,
                  downloadCount: downloadState.downloads.length,
                ),
                const SizedBox(height: 28),
                if (currentTrack != null) ...[
                  SectionHeader(title: 'Now Playing'),
                  const SizedBox(height: 12),
                  _buildNowPlayingCard(context, currentTrack),
                  const SizedBox(height: 28),
                ],
                SectionHeader(
                  title: 'Audio Library',
                  subtitle: '${audioState.tracks.length} tracks',
                  onSeeAll: () => context.push(AppRoutes.audioLibrary),
                ),
                const SizedBox(height: 12),
                _buildAudioPreview(context, audioState.tracks),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Video Library',
                  subtitle: '${videoState.videos.length} videos',
                  onSeeAll: () => context.push(AppRoutes.videoLibrary),
                ),
                const SizedBox(height: 12),
                _buildVideoPreview(context, videoState.videos),
                const SizedBox(height: 28),
                if (downloadState.active.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Active Downloads',
                    subtitle: '${downloadState.active.length} in progress',
                    onSeeAll: () => context.push(AppRoutes.downloads),
                  ),
                  const SizedBox(height: 12),
                  _buildDownloadPreview(context, downloadState),
                  const SizedBox(height: 28),
                ],
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavBar(context),
      floatingActionButton: _buildFab(context),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      expandedHeight: 0,
      toolbarHeight: 64,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.darkBg,
                AppTheme.primaryViolet.withOpacity(0.08),
              ],
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryViolet, AppTheme.accentCyan],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Text(
            'Nova Player',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  background: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppTheme.primaryViolet, AppTheme.accentCyan],
                    ).createShader(const Rect.fromLTWH(0, 0, 140, 30)),
                ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Scan Library',
          onPressed: () {
            ref.read(audioLibraryProvider.notifier).scanLibrary();
            ref.read(videoLibraryProvider.notifier).scanLibrary();
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () => context.push(AppRoutes.settings),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryViolet,
                  fontWeight: FontWeight.w500,
                )),
        const SizedBox(height: 4),
        Text('Your Media Hub',
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      (
        icon: Icons.audiotrack_rounded,
        label: 'Audio',
        color: AppTheme.primaryViolet,
        route: AppRoutes.audioLibrary,
      ),
      (
        icon: Icons.video_library_rounded,
        label: 'Video',
        color: AppTheme.accentCyan,
        route: AppRoutes.videoLibrary,
      ),
      (
        icon: Icons.download_rounded,
        label: 'Downloads',
        color: AppTheme.accentPink,
        route: AppRoutes.downloads,
      ),
      (
        icon: Icons.settings_rounded,
        label: 'Settings',
        color: AppTheme.accentGold,
        route: AppRoutes.settings,
      ),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final i = entry.key;
        final a = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 10 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(a.route),
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    color: a.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: a.color.withOpacity(0.25), width: 0.8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Icon(a.icon, color: a.color, size: 26),
                      const SizedBox(height: 6),
                      Text(a.label,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: a.color,
                                    fontSize: 11,
                                  )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatsRow(BuildContext context,
      {required int audioCount,
      required int videoCount,
      required int downloadCount}) {
    return Row(
      children: [
        _statCard(context, audioCount.toString(), 'Tracks',
            Icons.audiotrack_rounded, AppTheme.primaryViolet),
        const SizedBox(width: 10),
        _statCard(context, videoCount.toString(), 'Videos',
            Icons.videocam_rounded, AppTheme.accentCyan),
        const SizedBox(width: 10),
        _statCard(context, downloadCount.toString(), 'Downloads',
            Icons.download_done_rounded, AppTheme.accentPink),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _statCard(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w700),
                      maxLines: 1),
                  Text(label,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingCard(BuildContext context, AudioModel track) {
    return GlassCard(
      onTap: () => context.push(AppRoutes.audioPlayer, extra: track),
      child: MiniPlayer(track: track),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAudioPreview(BuildContext context, List<AudioModel> tracks) {
    if (tracks.isEmpty) {
      return GlassCard(
        onTap: () => context.push(AppRoutes.audioLibrary),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.audiotrack_rounded,
                  color: AppTheme.primaryViolet),
              const SizedBox(width: 12),
              Text('Tap to scan audio library',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tracks.take(10).length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final track = tracks[i];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.audioPlayer, extra: track),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryViolet.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppTheme.primaryViolet.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  MediaArtwork(
                      path: track.artworkPath,
                      size: 44,
                      radius: 8,
                      fallbackIcon: Icons.audiotrack_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  Widget _buildVideoPreview(BuildContext context, List<VideoModel> videos) {
    if (videos.isEmpty) {
      return GlassCard(
        onTap: () => context.push(AppRoutes.videoLibrary),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library_rounded,
                  color: AppTheme.accentCyan),
              const SizedBox(width: 12),
              Text('Tap to scan video library',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videos.take(10).length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final video = videos[i];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.videoPlayer, extra: video),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppTheme.darkCard,
                border: Border.all(
                    color: AppTheme.accentCyan.withOpacity(0.15)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MediaArtwork(
                      path: video.thumbnailPath,
                      size: 120,
                      radius: 14,
                      fallbackIcon: Icons.video_file_rounded,
                      fallbackColor: AppTheme.accentCyan,
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms);
  }

  Widget _buildDownloadPreview(
      BuildContext context, DownloadManagerState downloadState) {
    return GlassCard(
      onTap: () => context.push(AppRoutes.downloads),
      child: Column(
        children: downloadState.active.take(2).map((d) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.downloading_rounded,
                    color: AppTheme.accentPink, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: d.progress,
                        backgroundColor:
                            AppTheme.primaryViolet.withOpacity(0.1),
                        color: AppTheme.accentPink,
                        minHeight: 3,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(d.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _navIndex,
      onDestinationSelected: (i) {
        setState(() => _navIndex = i);
        switch (i) {
          case 0:
            break;
          case 1:
            context.push(AppRoutes.audioLibrary);
            break;
          case 2:
            context.push(AppRoutes.videoLibrary);
            break;
          case 3:
            context.push(AppRoutes.downloads);
            break;
          case 4:
            context.push(AppRoutes.settings);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.audiotrack_outlined),
            selectedIcon: Icon(Icons.audiotrack_rounded),
            label: 'Audio'),
        NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded),
            label: 'Video'),
        NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download_rounded),
            label: 'Downloads'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings'),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push(AppRoutes.downloads),
      backgroundColor: AppTheme.accentPink,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_link_rounded),
      label: const Text('Download', style: TextStyle(fontWeight: FontWeight.w600)),
      elevation: 6,
    ).animate().scale(delay: 600.ms, duration: 400.ms, curve: Curves.elasticOut);
  }

  Widget _buildRecentlyPlayed(BuildContext context) {
    final historyAsync = ref.watch(recentlyPlayedProvider);
    final history = historyAsync.valueOrNull ?? [];

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Recently Played'),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final item = history[i];
              final isAudio = item.isAudio;
              final audioModel = isAudio ? ref.read(audioLibraryProvider).tracks.where((t) => t.path == item.mediaPath).firstOrNull : null;
              final videoModel = !isAudio ? ref.read(videoLibraryProvider).videos.where((v) => v.path == item.mediaPath).firstOrNull : null;

              return GestureDetector(
                onTap: () {
                  if (isAudio && audioModel != null) {
                    context.push(AppRoutes.audioPlayer, extra: audioModel);
                  } else if (!isAudio && videoModel != null) {
                    context.push(AppRoutes.videoPlayer, extra: videoModel);
                  }
                },
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.darkBorder, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              MediaArtwork(
                                  path: item.artworkPath,
                                  size: 140,
                                  radius: 0,
                                fallbackIcon: isAudio
                                    ? Icons.audiotrack_rounded
                                    : Icons.videocam_rounded,
                                fallbackColor: isAudio
                                    ? AppTheme.primaryViolet
                                    : AppTheme.accentCyan,
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isAudio
                                        ? Icons.music_note_rounded
                                        : Icons.movie_rounded,
                                    color: isAudio
                                        ? AppTheme.primaryViolet
                                        : AppTheme.accentCyan,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isAudio ? item.subtitle : 'Video',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.darkTextMuted,
                                    fontSize: 9,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 150.ms);
  }
}
