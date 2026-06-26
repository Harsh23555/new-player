import 'package:isar/isar.dart';
part 'eq_settings_entity.g.dart';

@collection
class EqSettingsEntity {
  Id id = Isar.autoIncrement;
  bool enabled = false;
  String preset = 'Flat';
  List<double> gains = [0, 0, 0, 0, 0];
  double preamp = 1.0; // 1.0 = normal, >1.0 = boost
  int bassBoost = 0;   // 0-1000
  int virtualizer = 0; // 0-1000
}
