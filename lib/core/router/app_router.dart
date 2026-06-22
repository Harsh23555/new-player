import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/audio/presentation/screens/audio_library_screen.dart';
import '../../features/audio/presentation/screens/audio_player_screen.dart';
import '../../features/video/presentation/screens/video_library_screen.dart';
import '../../features/video/presentation/screens/video_player_screen.dart';
import '../../features/downloads/presentation/screens/download_manager_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../data/models/audio_model.dart';
import '../../data/models/video_model.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildPage(
          child: const HomeScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.audioLibrary,
        name: 'audio-library',
        pageBuilder: (context, state) => _buildPage(
          child: const AudioLibraryScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.audioPlayer,
        name: 'audio-player',
        pageBuilder: (context, state) {
          final audio = state.extra as AudioModel?;
          return _buildPage(
            child: AudioPlayerScreen(initialAudio: audio),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.videoLibrary,
        name: 'video-library',
        pageBuilder: (context, state) => _buildPage(
          child: const VideoLibraryScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.videoPlayer,
        name: 'video-player',
        pageBuilder: (context, state) {
          final video = state.extra as VideoModel?;
          return _buildSlideUpPage(
            child: VideoPlayerScreen(video: video!),
            state: state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.downloads,
        name: 'downloads',
        pageBuilder: (context, state) => _buildPage(
          child: const DownloadManagerScreen(),
          state: state,
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildPage(
          child: const SettingsScreen(),
          state: state,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});

CustomTransitionPage<void> _buildPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage<void> _buildSlideUpPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
  );
}

class AppRoutes {
  static const home = '/';
  static const audioLibrary = '/audio';
  static const audioPlayer = '/audio/player';
  static const videoLibrary = '/video';
  static const videoPlayer = '/video/player';
  static const downloads = '/downloads';
  static const settings = '/settings';
}
