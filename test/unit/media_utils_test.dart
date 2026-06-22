import 'package:flutter_test/flutter_test.dart';
import 'package:nova_player/core/utils/media_utils.dart';

void main() {
  group('MediaUtils', () {
    group('isAudioFile', () {
      test('returns true for mp3', () => expect(MediaUtils.isAudioFile('song.mp3'), isTrue));
      test('returns true for flac', () => expect(MediaUtils.isAudioFile('song.flac'), isTrue));
      test('returns true for m4a', () => expect(MediaUtils.isAudioFile('song.m4a'), isTrue));
      test('returns false for mp4', () => expect(MediaUtils.isAudioFile('video.mp4'), isFalse));
      test('is case insensitive', () => expect(MediaUtils.isAudioFile('song.MP3'), isTrue));
    });

    group('isVideoFile', () {
      test('returns true for mp4', () => expect(MediaUtils.isVideoFile('video.mp4'), isTrue));
      test('returns true for mkv', () => expect(MediaUtils.isVideoFile('video.mkv'), isTrue));
      test('returns false for mp3', () => expect(MediaUtils.isVideoFile('song.mp3'), isFalse));
      test('is case insensitive', () => expect(MediaUtils.isVideoFile('video.MKV'), isTrue));
    });

    group('formatDuration', () {
      test('formats seconds correctly', () {
        expect(MediaUtils.formatDuration(const Duration(seconds: 75)), '01:15');
      });
      test('formats hours correctly', () {
        expect(MediaUtils.formatDuration(const Duration(hours: 1, minutes: 30, seconds: 45)), '01:30:45');
      });
      test('formats zero duration', () {
        expect(MediaUtils.formatDuration(Duration.zero), '00:00');
      });
    });

    group('formatFileSize', () {
      test('formats bytes', () => expect(MediaUtils.formatFileSize(500), '500 B'));
      test('formats KB', () => expect(MediaUtils.formatFileSize(1536), contains('KB')));
      test('formats MB', () => expect(MediaUtils.formatFileSize(5 * 1024 * 1024), contains('MB')));
      test('formats GB', () {
        expect(MediaUtils.formatFileSize(2 * 1024 * 1024 * 1024), contains('GB'));
      });
      test('returns 0 B for 0 bytes', () => expect(MediaUtils.formatFileSize(0), '0 B'));
    });

    group('formatSpeed', () {
      test('formats KB/s', () {
        expect(MediaUtils.formatSpeed(512 * 1024), contains('KB/s'));
      });
      test('formats MB/s', () {
        expect(MediaUtils.formatSpeed(5 * 1024 * 1024), contains('MB/s'));
      });
    });

    group('formatEta', () {
      test('shows seconds for < 60s', () => expect(MediaUtils.formatEta(45), contains('s')));
      test('shows minutes for > 60s', () => expect(MediaUtils.formatEta(120), contains('m')));
      test('shows hours for > 3600s', () {
        expect(MediaUtils.formatEta(3700), contains('h'));
      });
      test('returns -- for 0', () => expect(MediaUtils.formatEta(0), '--'));
    });

    group('resolutionLabel', () {
      test('4K for 2160', () => expect(MediaUtils.resolutionLabel(3840, 2160), '4K UHD'));
      test('1080p for 1080', () => expect(MediaUtils.resolutionLabel(1920, 1080), '1080p FHD'));
      test('720p for 720', () => expect(MediaUtils.resolutionLabel(1280, 720), '720p HD'));
      test('Unknown for 0x0', () => expect(MediaUtils.resolutionLabel(0, 0), 'Unknown'));
    });

    group('getFileNameWithoutExtension', () {
      test('strips extension', () {
        expect(MediaUtils.getFileNameWithoutExtension('/path/to/song.mp3'), 'song');
      });
      test('works for files with dots in name', () {
        expect(MediaUtils.getFileNameWithoutExtension('my.song.name.mp3'), 'my.song.name');
      });
    });
  });
}
