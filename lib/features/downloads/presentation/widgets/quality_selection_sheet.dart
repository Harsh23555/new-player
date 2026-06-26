import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/extractor_service.dart';

class QualitySelectionSheet extends StatelessWidget {
  final ExtractionResult result;
  final Function(MediaStreamInfo) onSelected;

  const QualitySelectionSheet({
    super.key,
    required this.result,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.darkBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Video Info Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: result.thumbnailUrl,
                    width: 120,
                    height: 68,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.author,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppTheme.darkBorder),
          
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const _CategoryHeader(title: 'Video'),
                ...result.streams.where((s) => s.isVideo).map((s) => _StreamTile(stream: s, onTap: () => onSelected(s))),
                
                const _CategoryHeader(title: 'Audio Only'),
                ...result.streams.where((s) => s.isAudioOnly).map((s) => _StreamTile(stream: s, onTap: () => onSelected(s))),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;
  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppTheme.primaryViolet,
        ),
      ),
    );
  }
}

class _StreamTile extends StatelessWidget {
  final MediaStreamInfo stream;
  final VoidCallback onTap;

  const _StreamTile({required this.stream, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: stream.isVideo ? AppTheme.accentCyan.withOpacity(0.1) : AppTheme.accentPink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          stream.isVideo ? Icons.videocam_rounded : Icons.audiotrack_rounded,
          size: 20,
          color: stream.isVideo ? AppTheme.accentCyan : AppTheme.accentPink,
        ),
      ),
      title: Text(
        stream.quality,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${stream.container?.toUpperCase() ?? 'MP4'} • ${stream.sizeInMb.toStringAsFixed(1)} MB',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.download_rounded, size: 20),
    );
  }
}
