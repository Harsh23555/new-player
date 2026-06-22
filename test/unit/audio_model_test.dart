import 'package:flutter_test/flutter_test.dart';
import 'package:nova_player/data/models/audio_model.dart';
import 'package:nova_player/data/models/db/audio_entity.dart';

void main() {
  group('AudioModel', () {
    late AudioEntity entity;

    setUp(() {
      entity = AudioEntity()
        ..id = 1
        ..path = '/storage/emulated/0/Music/test.mp3'
        ..title = 'Test Song'
        ..artist = 'Test Artist'
        ..album = 'Test Album'
        ..genre = 'Pop'
        ..duration = 210000 // 3:30
        ..size = 5 * 1024 * 1024 // 5 MB
        ..trackNumber = 1
        ..year = 2024
        ..dateAdded = DateTime(2024, 1, 1)
        ..dateModified = DateTime(2024, 1, 1)
        ..playCount = 0
        ..isFavorite = false;
    });

    test('fromEntity creates correct model', () {
      final model = AudioModel.fromEntity(entity);

      expect(model.id, 1);
      expect(model.title, 'Test Song');
      expect(model.artist, 'Test Artist');
      expect(model.album, 'Test Album');
      expect(model.duration, 210000);
      expect(model.isFavorite, false);
    });

    test('formattedDuration formats correctly for minutes:seconds', () {
      final model = AudioModel.fromEntity(entity);
      expect(model.formattedDuration, '03:30');
    });

    test('formattedDuration includes hours when >= 1 hour', () {
      entity.duration = 3661000; // 1h 1m 1s
      final model = AudioModel.fromEntity(entity);
      expect(model.formattedDuration, '01:01:01');
    });

    test('formattedSize shows MB correctly', () {
      final model = AudioModel.fromEntity(entity);
      expect(model.formattedSize, contains('MB'));
    });

    test('formattedSize shows KB for small files', () {
      entity.size = 500 * 1024;
      final model = AudioModel.fromEntity(entity);
      expect(model.formattedSize, contains('KB'));
    });

    test('copyWith updates only specified fields', () {
      final model = AudioModel.fromEntity(entity);
      final updated = model.copyWith(isFavorite: true, playCount: 5);

      expect(updated.isFavorite, true);
      expect(updated.playCount, 5);
      expect(updated.title, model.title); // unchanged
    });

    test('equality is based on id, path, isFavorite, playCount', () {
      final m1 = AudioModel.fromEntity(entity);
      final m2 = m1.copyWith();
      expect(m1, equals(m2));
    });

    test('models with different ids are not equal', () {
      final m1 = AudioModel.fromEntity(entity);
      entity.id = 2;
      final m2 = AudioModel.fromEntity(entity);
      expect(m1, isNot(equals(m2)));
    });
  });
}
