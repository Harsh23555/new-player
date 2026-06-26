import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/download_model.dart';
import '../../providers/download_manager_provider.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../data/services/extractor_service.dart';
import '../widgets/quality_selection_sheet.dart';

class DownloadManagerScreen extends ConsumerStatefulWidget {
  const DownloadManagerScreen({super.key});

  @override
  ConsumerState<DownloadManagerScreen> createState() =>
      _DownloadManagerScreenState();
}

class _DownloadManagerScreenState
    extends ConsumerState<DownloadManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadManagerProvider.notifier).loadDownloads();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(downloadManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppTheme.accentPink,
          labelColor: AppTheme.accentPink,
          tabs: [
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.downloading_rounded, size: 16),
                const SizedBox(width: 4),
                Text('Active (${state.active.length + state.paused.length})'),
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_rounded, size: 16),
                const SizedBox(width: 4),
                Text('Done (${state.completed.length})'),
              ]),
            ),
            Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline_rounded, size: 16),
                const SizedBox(width: 4),
                Text('Failed (${state.failed.length})'),
              ]),
            ),
            const Tab(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.history_rounded, size: 16),
                SizedBox(width: 4),
                Text('All'),
              ]),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildUrlInput(context, state),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDownloadList(context,
                    [...state.active, ...state.paused], 'active'),
                _buildDownloadList(context, state.completed, 'completed'),
                _buildDownloadList(context, state.failed, 'failed'),
                _buildDownloadList(context, state.downloads, 'all'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlInput(BuildContext context, DownloadManagerState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkSurface
            : AppTheme.lightSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Download',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _urlController
                    ..text = state.urlInput,
                  onChanged: (v) => ref
                      .read(downloadManagerProvider.notifier)
                      .setUrlInput(v),
                  decoration: InputDecoration(
                    hintText: 'Paste video URL here…',
                    prefixIcon: const Icon(Icons.link_rounded, size: 20),
                    suffixIcon: state.isValidating
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                          )
                        : state.urlValid
                            ? const Icon(Icons.check_circle_rounded,
                                color: Colors.green, size: 20)
                            : null,
                    errorText: state.urlError,
                  ),
                  keyboardType: TextInputType.url,
                ),
              ),
              const SizedBox(width: 8),
              // Paste button
              IconButton(
                onPressed: () async {
                  final data = await Clipboard.getData('text/plain');
                  if (data?.text != null) {
                    _urlController.text = data!.text!;
                    ref
                        .read(downloadManagerProvider.notifier)
                        .setUrlInput(data.text!);
                  }
                },
                icon: const Icon(Icons.content_paste_rounded),
                tooltip: 'Paste',
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.darkCardAlt,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),

          // File info preview
          if (state.urlValid && state.suggestedFileName != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.file_present_rounded,
                      color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.suggestedFileName!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        if (state.suggestedFileSize != null)
                          Text(
                            _formatBytes(state.suggestedFileSize!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.isValidating
                      ? null
                      : () => ref
                          .read(downloadManagerProvider.notifier)
                          .validateUrl(),
                  icon: const Icon(Icons.verified_rounded, size: 16),
                  label: const Text('Validate URL'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GradientButton(
                  label: 'Download',
                  icon: Icons.download_rounded,
                  isLoading: state.isExtracting,
                  onPressed: !state.urlValid
                      ? null
                      : () async {
                          if (state.extractionResult != null) {
                            _showQualitySheet(context, state.extractionResult!);
                          } else {
                            final success = await ref
                                .read(downloadManagerProvider.notifier)
                                .startDownload();
                            if (success && mounted) {
                              _urlController.clear();
                              _showSuccessSnackBar(context);
                            }
                          }
                        },
                  colors: [AppTheme.accentPink, AppTheme.primaryViolet],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadList(BuildContext context,
      List<DownloadModel> downloads, String type) {
    if (downloads.isEmpty) {
      return EmptyState(
        icon: type == 'active'
            ? Icons.downloading_rounded
            : type == 'completed'
                ? Icons.cloud_done_rounded
                : type == 'failed'
                    ? Icons.cloud_off_rounded
                    : Icons.history_rounded,
        title: type == 'active'
            ? 'No Active Downloads'
            : type == 'completed'
                ? 'No Completed Downloads'
                : type == 'failed'
                    ? 'No Failed Downloads'
                    : 'No Downloads Yet',
        subtitle: 'Paste a URL above and tap Download to get started',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: downloads.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _DownloadCard(
        download: downloads[i],
        index: i,
        onPause: () => ref
            .read(downloadManagerProvider.notifier)
            .pauseDownload(downloads[i].taskId),
        onResume: () => ref
            .read(downloadManagerProvider.notifier)
            .resumeDownload(downloads[i].taskId),
        onCancel: () => ref
            .read(downloadManagerProvider.notifier)
            .cancelDownload(downloads[i].taskId),
        onRetry: () => ref
            .read(downloadManagerProvider.notifier)
            .retryDownload(downloads[i].taskId),
        onDelete: () => _confirmDelete(context, downloads[i].taskId),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String taskId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Download?'),
        content:
            const Text('Do you also want to delete the downloaded file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep File'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete File', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result != null) {
      ref
          .read(downloadManagerProvider.notifier)
          .deleteDownload(taskId, deleteFile: result);
    }
  }

  void _showQualitySheet(BuildContext context, ExtractionResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QualitySelectionSheet(
        result: result,
        onSelected: (stream) async {
          Navigator.pop(context);
          final success = await ref
              .read(downloadManagerProvider.notifier)
              .startDownloadWithStream(result: result, stream: stream);
          if (success && mounted) {
            _urlController.clear();
            _showSuccessSnackBar(context);
          }
        },
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _DownloadCard extends StatelessWidget {
  final DownloadModel download;
  final int index;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  const _DownloadCard({
    required this.download,
    required this.index,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(download.status);
    final statusLabel = _statusLabel(download.status);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: download.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: download.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                              _statusIcon(download.status),
                              color: statusColor,
                              size: 22),
                          errorWidget: (context, url, error) => Icon(
                              _statusIcon(download.status),
                              color: statusColor,
                              size: 22),
                        ),
                      )
                    : Icon(_statusIcon(download.status),
                        color: statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(statusLabel,
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        if (download.totalBytes > 0)
                          Text(download.formattedTotalSize,
                              style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              _buildActions(context),
            ],
          ),

          if (download.isActive || download.isPaused) ...[
            const SizedBox(height: 12),
            LinearPercentIndicator(
              percent: download.progress.clamp(0.0, 1.0),
              lineHeight: 6,
              backgroundColor: AppTheme.darkBorder,
              progressColor: statusColor,
              barRadius: const Radius.circular(3),
              padding: EdgeInsets.zero,
              animation: true,
              animateFromLastPercent: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(download.progress * 100).toInt()}% • ${download.formattedSpeed}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (download.eta > 0)
                  Text(
                    'ETA: ${download.formattedEta}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],

          if (download.isComplete && download.completedAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Completed ${timeago.format(download.completedAt!)}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.green),
            ),
          ],

          if (download.isFailed && download.errorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              download.errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.red),
              maxLines: 2,
            ),
          ],
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 30)).fadeIn().slideY(begin: 0.06);
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (download.isActive)
          IconButton(
            icon: const Icon(Icons.pause_rounded),
            onPressed: onPause,
            iconSize: 20,
            color: AppTheme.accentGold,
            tooltip: 'Pause',
            visualDensity: VisualDensity.compact,
          ),
        if (download.isPaused)
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: onResume,
            iconSize: 20,
            color: Colors.green,
            tooltip: 'Resume',
            visualDensity: VisualDensity.compact,
          ),
        if (download.isFailed)
          IconButton(
            icon: const Icon(Icons.replay_rounded),
            onPressed: onRetry,
            iconSize: 20,
            color: AppTheme.accentCyan,
            tooltip: 'Retry',
            visualDensity: VisualDensity.compact,
          ),
        if (download.isActive || download.isPaused)
          IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: onCancel,
            iconSize: 20,
            color: Colors.red,
            tooltip: 'Cancel',
            visualDensity: VisualDensity.compact,
          ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: onDelete,
          iconSize: 20,
          color: AppTheme.darkTextMuted,
          tooltip: 'Delete',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Color _statusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.running:
        return AppTheme.accentCyan;
      case DownloadStatus.enqueued:
        return AppTheme.accentGold;
      case DownloadStatus.complete:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.canceled:
        return AppTheme.darkTextMuted;
      case DownloadStatus.paused:
        return AppTheme.accentGold;
    }
  }

  IconData _statusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.running:
        return Icons.downloading_rounded;
      case DownloadStatus.enqueued:
        return Icons.schedule_rounded;
      case DownloadStatus.complete:
        return Icons.cloud_done_rounded;
      case DownloadStatus.failed:
        return Icons.cloud_off_rounded;
      case DownloadStatus.canceled:
        return Icons.cancel_rounded;
      case DownloadStatus.paused:
        return Icons.pause_circle_rounded;
    }
  }

  String _statusLabel(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.running:
        return 'Downloading';
      case DownloadStatus.enqueued:
        return 'Queued';
      case DownloadStatus.complete:
        return 'Complete';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.canceled:
        return 'Canceled';
      case DownloadStatus.paused:
        return 'Paused';
    }
  }
}
