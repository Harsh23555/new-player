import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/recently_played_repository.dart';

// Recently Played provider
final recentlyPlayedProvider =
    FutureProvider.autoDispose<List<RecentlyPlayedItem>>((ref) async {
  final repo = ref.watch(recentlyPlayedRepositoryProvider);
  return repo.getAll(limit: 30);
});

// Resume position for a specific media path
final resumePositionProvider =
    FutureProvider.autoDispose.family<int, String>((ref, path) async {
  final repo = ref.watch(recentlyPlayedRepositoryProvider);
  final item = await repo.getByPath(path);
  return item?.positionMs ?? 0;
});
