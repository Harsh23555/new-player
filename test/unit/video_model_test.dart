import 'package:flutter_test/flutter_test.dart';
import 'package:nova_player/data/models/video_model.dart';
import 'package:nova_player/data/models/db/video_entity.dart';

void main() {
  group('VideoModel', () {
    late VideoEntity entity;

    setUp(() {
      entity = VideoEntity()
        ..id = 1
        ..path = '/storage/emulated/0/Movies/test.mp4'
        ..title = 'Test Video'
        ..duration = '01:30:00'
        ..durationMs = 5400000
        ..size = 700 * 1024 * 1024 // 700 MB
        ..width = 1920
        ..height = 1080
        ..dateAdded = DateTime(2024, 1, 1)
        ..dateModified = DateTime(2024, 1, 1)
        ..playCount = 0
        ..isFavorite = false
        ..isDownloaded = false;
    });

    test('fromEntity creates correct model', () {
      final model = VideoModel.fromEntity(entity);
      expect(model.id, 1);
      expect(model.title, 'Test Video');
      expect(model.width, 1920);
      expect(model.height, 1080);
    });

    test('resolution returns 1080p for 1080 height', () {
      final model = VideoModel.fromEntity(entity);
      expect(model.resolution, '1080p');
    });

    test('resolution returns 4K for 2160 height', () {
      entity.height = 2160;
      final model = VideoModel.fromEntity(entity);
      expect(model.resolution, '4K');
    });

    test('resolution returns 720p for 720 height', () {
      entity.height = 720;
      final model = VideoModel.fromEntity(entity);
      expect(model.resolution, '720p');
    });

    test('resolution returns Unknown for zero dimensions', () {
      entity.width = 0;
      entity.height = 0;
      final model = VideoModel.fromEntity(entity);
      expect(model.resolution, 'Unknown');
    });

    test('formattedSize shows GB for large files', () {
      entity.size = 2 * 1024 * 1024 * 1024; // 2 GB
      final model = VideoModel.fromEntity(entity);
      expect(model.formattedSize, contains('GB'));
    });

    test('formattedSize shows MB for medium files', () {
      final model = VideoModel.fromEntity(entity);
      expect(model.formattedSize, contains('MB'));
    });

    test('copyWith updates isFavorite', () {
      final model = VideoModel.fromEntity(entity);
      final updated = model.copyWith(isFavorite: true);
      expect(updated.isFavorite, true);
      expect(updated.title, model.title); // unchanged
    });

    test('equality based on id, path, isFavorite, playCount', () {
      final m1 = VideoModel.fromEntity(entity);
      final m2 = m1.copyWith();
      expect(m1, equals(m2));
    });
  });
}
