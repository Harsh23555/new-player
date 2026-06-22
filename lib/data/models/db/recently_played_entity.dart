import 'package:isar/isar.dart';

part 'recently_played_entity.g.dart';

@collection
class RecentlyPlayedEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String mediaPath;

  late String mediaType; // 'audio' or 'video'
  late String title;
  late String subtitle;
  String? artworkPath;
  late DateTime playedAt;
  late int positionMs;
}
