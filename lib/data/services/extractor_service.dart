import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:logger/logger.dart';

import '../models/download_model.dart';

final extractorServiceProvider = Provider<ExtractorService>((ref) {
  return ExtractorService();
});

class ExtractionResult {
  final String title;
  final String author;
  final String thumbnailUrl;
  final Duration duration;
  final List<MediaStreamInfo> streams;

  ExtractionResult({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.duration,
    required this.streams,
  });
}

class MediaStreamInfo {
  final String url;
  final String quality;
  final String? container;
  final double sizeInMb;
  final bool isVideo;
  final bool isAudioOnly;

  MediaStreamInfo({
    required this.url,
    required this.quality,
    this.container,
    required this.sizeInMb,
    required this.isVideo,
    this.isAudioOnly = false,
  });
}

class ExtractorService {
  final _yt = YoutubeExplode();
  final _logger = Logger();

  Future<ExtractionResult?> extract(String url) async {
    try {
      if (url.contains('youtube.com') || url.contains('youtu.be')) {
        return await _extractYoutube(url);
      }
      // Add other extractors here (Facebook, Instagram, etc.) if needed
      return null;
    } catch (e, st) {
      _logger.e('Extraction error', error: e, stackTrace: st);
      return null;
    }
  }

  Future<ExtractionResult?> _extractYoutube(String url) async {
    try {
      final video = await _yt.videos.get(url);
      final manifest = await _yt.videos.streamsClient.getManifest(video.id);

      final streams = <MediaStreamInfo>[];

      // Video with Audio (Muxed)
      for (final stream in manifest.muxed) {
        streams.add(MediaStreamInfo(
          url: stream.url.toString(),
          quality: stream.videoQuality.qualityString,
          container: stream.container.name,
          sizeInMb: stream.size.totalMegaBytes,
          isVideo: true,
        ));
      }

      // Audio Only
      for (final stream in manifest.audioOnly) {
        streams.add(MediaStreamInfo(
          url: stream.url.toString(),
          quality: '${stream.bitrate.kiloBitsPerSecond.round()}kbps',
          container: stream.container.name,
          sizeInMb: stream.size.totalMegaBytes,
          isVideo: false,
          isAudioOnly: true,
        ));
      }

      return ExtractionResult(
        title: video.title,
        author: video.author,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration ?? Duration.zero,
        streams: streams,
      );
    } catch (e) {
      _logger.e('YouTube extraction failed', error: e);
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
