import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

/// Animated shimmer placeholder for audio tracks
class AudioTrackShimmer extends StatelessWidget {
  final int count;
  const AudioTrackShimmer({super.key, this.count = 8});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEEFF);
    final highlightColor = isDark ? const Color(0xFF2A2A45) : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              // Artwork placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 11,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 11,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated shimmer for video grid items
class VideoGridShimmer extends StatelessWidget {
  final int columns;
  final int count;
  const VideoGridShimmer({super.key, this.columns = 2, this.count = 8});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEEFF);
    final highlightColor = isDark ? const Color(0xFF2A2A45) : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 16 / 10,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: count,
        itemBuilder: (context, _) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for download list items
class DownloadItemShimmer extends StatelessWidget {
  final int count;
  const DownloadItemShimmer({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEEFF);
    final highlightColor = isDark ? const Color(0xFF2A2A45) : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(
          count,
          (_) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Generic shimmer card placeholder
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const ShimmerCard({
    super.key,
    required this.height,
    this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEEFF);
    final highlightColor = isDark ? const Color(0xFF2A2A45) : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Convenience alias - used by VideoLibraryScreen
class ShimmerGrid extends StatelessWidget {
  final int columns;
  final int count;
  const ShimmerGrid({super.key, this.columns = 2, this.count = 8});

  @override
  Widget build(BuildContext context) =>
      VideoGridShimmer(columns: columns, count: count);
}

/// Convenience shimmer list - used by VideoLibraryScreen
class ShimmerList extends StatelessWidget {
  final int count;
  final double itemHeight;
  const ShimmerList({super.key, this.count = 8, this.itemHeight = 72});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEEEEFF);
    final highlightColor = isDark ? const Color(0xFF2A2A45) : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, __) => Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
