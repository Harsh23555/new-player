import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/audio_model.dart';
import '../../../data/services/audio_scan_service.dart';
import '../../../data/services/permission_service.dart';
import '../../../data/repositories/audio_repository.dart';

// ── Sort / Filter state ──────────────────────────────────────────────────────
class AudioLibraryFilter {
  final String sortBy;
  final bool ascending;
  final String searchQuery;

  const AudioLibraryFilter({
    this.sortBy = 'title',
    this.ascending = true,
    this.searchQuery = '',
  });

  AudioLibraryFilter copyWith({
    String? sortBy,
    bool? ascending,
    String? searchQuery,
  }) =>
      AudioLibraryFilter(
        sortBy: sortBy ?? this.sortBy,
        ascending: ascending ?? this.ascending,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}

final audioFilterProvider =
    StateProvider<AudioLibraryFilter>((ref) => const AudioLibraryFilter());

// ── Scan State ───────────────────────────────────────────────────────────────
enum ScanStatus { idle, scanning, done, error }

class AudioLibraryState {
  final List<AudioModel> tracks;
  final ScanStatus status;
  final String? error;

  const AudioLibraryState({
    this.tracks = const [],
    this.status = ScanStatus.idle,
    this.error,
  });

  AudioLibraryState copyWith({
    List<AudioModel>? tracks,
    ScanStatus? status,
    String? error,
  }) =>
      AudioLibraryState(
        tracks: tracks ?? this.tracks,
        status: status ?? this.status,
        error: error ?? this.error,
      );
}


class AudioLibraryNotifier extends StateNotifier<AudioLibraryState> {
  final AudioScanService _scanService;
  final AudioRepository _repository;
  final PermissionService _permissionService;

  AudioLibraryNotifier(
    this._scanService,
    this._repository,
    this._permissionService,
  ) : super(const AudioLibraryState());

  Future<void> scanLibrary() async {
    if (state.status == ScanStatus.scanning) return;
    state = state.copyWith(status: ScanStatus.scanning);
    try {
      final result = await _permissionService.requestStoragePermission();
      if (!result.granted) {
        state = state.copyWith(
          status: ScanStatus.error,
          error: result.message ?? 'Storage permission denied',
        );
        return;
      }
      final tracks = await _scanService.scanAndIndex();
      state = state.copyWith(tracks: tracks, status: ScanStatus.done);
    } catch (e) {
      state = state.copyWith(
        status: ScanStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> loadFromDb({String sortBy = 'title', bool ascending = true}) async {
    state = state.copyWith(status: ScanStatus.scanning);
    try {
      final tracks = await _repository.getAll();
      state = state.copyWith(tracks: tracks, status: ScanStatus.done);
    } catch (e) {
      state = state.copyWith(status: ScanStatus.error, error: e.toString());
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadFromDb();
      return;
    }
    final results = await _repository.search(query);
    state = state.copyWith(tracks: results);
  }

  Future<void> toggleFavorite(AudioModel audio) async {
    await _repository.toggleFavorite(audio.id);
    final updated = state.tracks.map((t) {
      if (t.id == audio.id) return t.copyWith(isFavorite: !t.isFavorite);
      return t;
    }).toList();
    state = state.copyWith(tracks: updated);
  }
}

final audioLibraryProvider =
    StateNotifierProvider<AudioLibraryNotifier, AudioLibraryState>((ref) {
  return AudioLibraryNotifier(
    ref.watch(audioScanServiceProvider),
    ref.watch(audioRepositoryProvider),
    ref.watch(permissionServiceProvider),
  );
});

// Filtered/sorted list derived provider
final filteredAudioProvider = Provider<List<AudioModel>>((ref) {
  final state = ref.watch(audioLibraryProvider);
  final filter = ref.watch(audioFilterProvider);

  if (state.tracks.isEmpty) return [];

  List<AudioModel> tracks = List.from(state.tracks);

  if (filter.searchQuery.isNotEmpty) {
    final q = filter.searchQuery.toLowerCase();
    tracks = tracks
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.artist.toLowerCase().contains(q) ||
            t.album.toLowerCase().contains(q))
        .toList();
  }

  tracks.sort((a, b) {
    int compare;
    switch (filter.sortBy) {
      case 'artist':
        compare = a.artist.compareTo(b.artist);
        break;
      case 'album':
        compare = a.album.compareTo(b.album);
        break;
      case 'duration':
        compare = a.duration.compareTo(b.duration);
        break;
      case 'dateAdded':
        compare = a.dateAdded.compareTo(b.dateAdded);
        break;
      default:
        compare = a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }
    return filter.ascending ? compare : -compare;
  });

  return tracks;
});
