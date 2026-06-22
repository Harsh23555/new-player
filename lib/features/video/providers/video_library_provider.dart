import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/video_model.dart';
import '../../../data/services/video_scan_service.dart';
import '../../../data/services/permission_service.dart';
import '../../../data/repositories/video_repository.dart';

class VideoLibraryFilter {
  final String sortBy;
  final bool ascending;
  final String searchQuery;
  final int gridColumns;

  const VideoLibraryFilter({
    this.sortBy = 'dateAdded',
    this.ascending = false,
    this.searchQuery = '',
    this.gridColumns = 2,
  });

  VideoLibraryFilter copyWith({
    String? sortBy,
    bool? ascending,
    String? searchQuery,
    int? gridColumns,
  }) =>
      VideoLibraryFilter(
        sortBy: sortBy ?? this.sortBy,
        ascending: ascending ?? this.ascending,
        searchQuery: searchQuery ?? this.searchQuery,
        gridColumns: gridColumns ?? this.gridColumns,
      );
}

final videoFilterProvider =
    StateProvider<VideoLibraryFilter>((ref) => const VideoLibraryFilter());

class VideoLibraryState {
  final List<VideoModel> videos;
  final ScanStatus status;
  final String? error;

  const VideoLibraryState({
    this.videos = const [],
    this.status = ScanStatus.idle,
    this.error,
  });

  VideoLibraryState copyWith({
    List<VideoModel>? videos,
    ScanStatus? status,
    String? error,
  }) =>
      VideoLibraryState(
        videos: videos ?? this.videos,
        status: status ?? this.status,
        error: error ?? this.error,
      );
}


enum ScanStatus { idle, scanning, done, error }

class VideoLibraryNotifier extends StateNotifier<VideoLibraryState> {
  final VideoScanService _scanService;
  final VideoRepository _repository;
  final PermissionService _permissionService;

  VideoLibraryNotifier(
    this._scanService,
    this._repository,
    this._permissionService,
  ) : super(const VideoLibraryState());

  Future<void> scanLibrary() async {
    if (state.status == ScanStatus.scanning) return;
    state = state.copyWith(status: ScanStatus.scanning);
    try {
      final result = await _permissionService.requestStoragePermission();
      if (!result.granted) {
        state = state.copyWith(
          status: ScanStatus.error,
          error: result.message ?? 'Permission denied',
        );
        return;
      }
      final videos = await _scanService.scanAndIndex();
      state = state.copyWith(videos: videos, status: ScanStatus.done);
    } catch (e) {
      state = state.copyWith(status: ScanStatus.error, error: e.toString());
    }
  }

  Future<void> loadFromDb({String sortBy = 'dateAdded', bool ascending = false}) async {
    state = state.copyWith(status: ScanStatus.scanning);
    try {
      final videos = await _repository.getAll();
      state = state.copyWith(videos: videos, status: ScanStatus.done);
    } catch (e) {
      state = state.copyWith(status: ScanStatus.error, error: e.toString());
    }
  }

  Future<void> toggleFavorite(VideoModel video) async {
    await _repository.toggleFavorite(video.id);
    final updated = state.videos.map((v) {
      if (v.id == video.id) return v.copyWith(isFavorite: !v.isFavorite);
      return v;
    }).toList();
    state = state.copyWith(videos: updated);
  }
}

final videoLibraryProvider =
    StateNotifierProvider<VideoLibraryNotifier, VideoLibraryState>((ref) {
  return VideoLibraryNotifier(
    ref.watch(videoScanServiceProvider),
    ref.watch(videoRepositoryProvider),
    ref.watch(permissionServiceProvider),
  );
});

final filteredVideoProvider = Provider<List<VideoModel>>((ref) {
  final state = ref.watch(videoLibraryProvider);
  final filter = ref.watch(videoFilterProvider);

  if (state.videos.isEmpty) return [];

  List<VideoModel> videos = List.from(state.videos);

  if (filter.searchQuery.isNotEmpty) {
    final q = filter.searchQuery.toLowerCase();
    videos = videos.where((v) => v.title.toLowerCase().contains(q)).toList();
  }

  videos.sort((a, b) {
    int compare;
    switch (filter.sortBy) {
      case 'title':
        compare = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        break;
      case 'size':
        compare = a.size.compareTo(b.size);
        break;
      case 'duration':
        compare = a.durationMs.compareTo(b.durationMs);
        break;
      default:
        compare = a.dateAdded.compareTo(b.dateAdded);
    }
    return filter.ascending ? compare : -compare;
  });

  return videos;
});
