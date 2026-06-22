import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/settings_provider.dart';
import '../../../../shared/widgets/common_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeMode = ref.watch(novaThemeModeProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: Text('Settings',
                style: Theme.of(context).textTheme.titleLarge),
            centerTitle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Appearance ──────────────────────────────────────────
                _SectionTitle(title: 'Appearance'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _buildThemePicker(context, themeMode, notifier),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 20),

                // ── Audio ────────────────────────────────────────────────
                _SectionTitle(title: 'Audio Playback'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Background Playback'),
                        subtitle:
                            const Text('Continue playing when app is minimized'),
                        value: settings.backgroundPlayback,
                        onChanged: notifier.setBackgroundPlayback,
                        secondary: const Icon(Icons.headphones_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      _buildDivider(),
                      _buildSkipDurationTile(context, settings.skipDuration,
                          (v) => notifier.setSkipDuration(v)),
                      _buildDivider(),
                      _buildSpeedTile(
                          context,
                          settings.defaultPlaybackSpeed,
                          (v) => notifier.setDefaultSpeed(v)),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 20),

                // ── Video ─────────────────────────────────────────────────
                _SectionTitle(title: 'Video Playback'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Picture in Picture'),
                        subtitle: const Text('Float video over other apps'),
                        value: settings.pipEnabled,
                        onChanged: notifier.setPipEnabled,
                        secondary: const Icon(Icons.picture_in_picture_alt_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        title: const Text('Show Thumbnails'),
                        subtitle: const Text('Display video preview thumbnails'),
                        value: settings.showVideoThumbnail,
                        onChanged: notifier.setShowVideoThumbnail,
                        secondary: const Icon(Icons.image_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      _buildDivider(),
                      _buildGridColumnsTile(context, settings.videoGridColumns,
                          (v) => notifier.setVideoGridColumns(v)),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                const SizedBox(height: 20),

                // ── Library ───────────────────────────────────────────────
                _SectionTitle(title: 'Media Library'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Auto-Scan on Start'),
                        subtitle: const Text('Scan library when app launches'),
                        value: settings.autoScanOnStart,
                        onChanged: notifier.setAutoScan,
                        secondary: const Icon(Icons.search_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        title: const Text('Show Audio Artwork'),
                        subtitle: const Text('Display album art in audio list'),
                        value: settings.showAudioArtwork,
                        onChanged: notifier.setShowAudioArtwork,
                        secondary: const Icon(Icons.photo_library_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 20),

                // ── Downloads ─────────────────────────────────────────────
                _SectionTitle(title: 'Downloads'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Download Notifications'),
                        subtitle:
                            const Text('Show progress in notification bar'),
                        value: settings.showDownloadNotification,
                        onChanged: notifier.setShowDownloadNotification,
                        secondary: const Icon(Icons.notifications_rounded),
                        activeColor: AppTheme.primaryViolet,
                      ),
                      _buildDivider(),
                      _buildMaxDownloadsTile(
                          context,
                          settings.maxConcurrentDownloads,
                          (v) => notifier.setMaxConcurrentDownloads(v)),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                const SizedBox(height: 20),

                // ── About ─────────────────────────────────────────────────
                _SectionTitle(title: 'About'),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.primaryViolet,
                                AppTheme.accentCyan
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 22),
                        ),
                        title: const Text('Nova Player'),
                        subtitle: const Text('Version 1.0.0'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemePicker(
    BuildContext context,
    NovaThemeMode current,
    SettingsNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.palette_rounded,
                    color: AppTheme.primaryViolet, size: 20),
                const SizedBox(width: 12),
                Text('Theme',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: NovaThemeMode.values.map((mode) {
              final isSelected = mode == current;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => notifier.setThemeMode(mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryViolet.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryViolet
                              : AppTheme.darkBorder,
                          width: isSelected ? 1.5 : 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(mode.icon,
                              color: isSelected
                                  ? AppTheme.primaryViolet
                                  : AppTheme.darkTextSecondary,
                              size: 22),
                          const SizedBox(height: 6),
                          Text(
                            mode.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryViolet
                                  : AppTheme.darkTextSecondary,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSkipDurationTile(
      BuildContext context, int current, ValueChanged<int> onChanged) {
    return ListTile(
      leading: const Icon(Icons.fast_forward_rounded),
      title: const Text('Skip Duration'),
      subtitle: Text('$current seconds'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [5, 10, 15, 30].map((v) {
          final isSelected = v == current;
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.darkCardAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${v}s',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkTextSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpeedTile(
      BuildContext context, double current, ValueChanged<double> onChanged) {
    return ListTile(
      leading: const Icon(Icons.speed_rounded),
      title: const Text('Default Speed'),
      subtitle: Text('${current}x'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [0.5, 0.75, 1.0, 1.25, 1.5].map((v) {
          final isSelected = (v - current).abs() < 0.01;
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.darkCardAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${v}x',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkTextSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGridColumnsTile(
      BuildContext context, String current, ValueChanged<String> onChanged) {
    return ListTile(
      leading: const Icon(Icons.grid_view_rounded),
      title: const Text('Video Grid Columns'),
      subtitle: Text('$current columns'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['1', '2', '3'].map((v) {
          final isSelected = v == current;
          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.darkCardAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  v,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppTheme.darkTextSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMaxDownloadsTile(
      BuildContext context, int current, ValueChanged<int> onChanged) {
    return ListTile(
      leading: const Icon(Icons.download_rounded),
      title: const Text('Max Concurrent Downloads'),
      subtitle: Text('$current at a time'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [1, 2, 3, 5].map((v) {
          final isSelected = v == current;
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryViolet
                      : AppTheme.darkCardAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$v',
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppTheme.darkTextSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryViolet,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
      ),
    );
  }
}
