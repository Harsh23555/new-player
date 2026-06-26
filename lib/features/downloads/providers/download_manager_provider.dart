import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../../../data/models/download_model.dart';
import '../../../data/services/download_service.dart';
import '../../../data/services/extractor_service.dart';

// ── Download Manager State ───────────────────────────────────────────────────
class DownloadManagerState {
  final List<DownloadModel> downloads;
  final bool isLoading;
  final String? error;
  final String urlInput;
  final bool urlValid;
  final String? urlError;
  final bool isValidating;
  final String? suggestedFileName;
  final int? suggestedFileSize;
  final ExtractionResult? extractionResult;
  final bool isExtracting;

  const DownloadManagerState({
    this.downloads = const [],
    this.isLoading = false,
    this.error,
    this.urlInput = '',
    this.urlValid = false,
    this.urlError,
    this.isValidating = false,
    this.suggestedFileName,
    this.suggestedFileSize,
    this.extractionResult,
    this.isExtracting = false,
  });

  DownloadManagerState copyWith({
    List<DownloadModel>? downloads,
    bool? isLoading,
    String? error,
    String? urlInput,
    bool? urlValid,
    String? urlError,
    bool? isValidating,
    String? suggestedFileName,
    int? suggestedFileSize,
    ExtractionResult? extractionResult,
    bool? isExtracting,
  }) =>
      DownloadManagerState(
        downloads: downloads ?? this.downloads,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        urlInput: urlInput ?? this.urlInput,
        urlValid: urlValid ?? this.urlValid,
        urlError: urlError,
        isValidating: isValidating ?? this.isValidating,
        suggestedFileName: suggestedFileName ?? this.suggestedFileName,
        suggestedFileSize: suggestedFileSize ?? this.suggestedFileSize,
        extractionResult: extractionResult ?? this.extractionResult,
        isExtracting: isExtracting ?? this.isExtracting,
      );

  List<DownloadModel> get active =>
      downloads.where((d) => d.isActive).toList();
  List<DownloadModel> get paused =>
      downloads.where((d) => d.isPaused).toList();
  List<DownloadModel> get completed =>
      downloads.where((d) => d.isComplete).toList();
  List<DownloadModel> get failed =>
      downloads.where((d) => d.isFailed).toList();
}

class DownloadManagerNotifier extends StateNotifier<DownloadManagerState> {
  final DownloadService _service;
  final ExtractorService _extractor;
  ReceivePort? _port;

  DownloadManagerNotifier(this._service, this._extractor) : super(const DownloadManagerState()) {
    _init();
  }

  void _init() {
    _port = ReceivePort();
    IsolateNameServer.registerPortWithName(
        _port!.sendPort, 'downloader_send_port');
    _port!.listen((dynamic data) {
      if (data is List) {
        final taskId = data[0] as String;
        final status = data[1] as int;
        final progress = data[2] as int;
        _onDownloadProgress(taskId, status, progress);
      }
    });

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    loadDownloads();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  void _onDownloadProgress(String taskId, int status, int progress) {
    final updated = state.downloads.map((d) {
      if (d.taskId == taskId) {
        return DownloadModel(
          id: d.id,
          taskId: d.taskId,
          url: d.url,
          fileName: d.fileName,
          savePath: d.savePath,
          status: DownloadStatus.values[status.clamp(0, 5)],
          progress: progress / 100.0,
          totalBytes: d.totalBytes,
          downloadedBytes: (d.totalBytes * progress / 100).toInt(),
          speed: d.speed,
          eta: d.eta,
          thumbnailUrl: d.thumbnailUrl,
          errorMessage: d.errorMessage,
          createdAt: d.createdAt,
          completedAt: status == 2 ? DateTime.now() : d.completedAt,
        );
      }
      return d;
    }).toList();
    state = state.copyWith(downloads: updated);

    // Persist to DB
    _service.updateProgress(
      taskId: taskId,
      status: status,
      progress: progress / 100.0,
    );
  }

  Future<void> loadDownloads() async {
    state = state.copyWith(isLoading: true);
    try {
      final downloads = await _service.getAllDownloads();
      state = state.copyWith(downloads: downloads, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setUrlInput(String url) {
    state = state.copyWith(
      urlInput: url,
      urlValid: false,
      urlError: null,
      suggestedFileName: null,
      suggestedFileSize: null,
      extractionResult: null,
    );
  }

  Future<void> validateUrl() async {
    if (state.urlInput.isEmpty) return;
    state = state.copyWith(isValidating: true, urlError: null, extractionResult: null);
    
    // Try extraction first for media sites
    if (state.urlInput.contains('youtube') || state.urlInput.contains('youtu.be')) {
      final extraction = await _extractor.extract(state.urlInput);
      if (extraction != null) {
        state = state.copyWith(
          isValidating: false,
          urlValid: true,
          extractionResult: extraction,
          suggestedFileName: extraction.title,
        );
        return;
      }
    }

    final result = await _service.validateUrl(state.urlInput);
    state = state.copyWith(
      isValidating: false,
      urlValid: result.valid,
      urlError: result.error,
      suggestedFileName: result.fileName,
      suggestedFileSize: result.fileSize,
    );
  }

  Future<bool> startDownloadWithStream({
    required ExtractionResult result,
    required MediaStreamInfo stream,
  }) async {
    final fileName = '${result.title}.${stream.container ?? (stream.isVideo ? 'mp4' : 'mp3')}';
    
    final taskId = await _service.startDownload(
      url: stream.url,
      fileName: _sanitizeFileName(fileName),
      thumbnailUrl: result.thumbnailUrl,
    );

    if (taskId == null) {
      state = state.copyWith(error: 'Failed to start download');
      return false;
    }

    await loadDownloads();
    state = state.copyWith(
      urlInput: '',
      urlValid: false,
      extractionResult: null,
    );
    return true;
  }

  String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  Future<bool> startDownload({String? customFileName}) async {
    if (!state.urlValid) return false;

    final fileName = customFileName ?? state.suggestedFileName ?? 'download.mp4';
    final taskId = await _service.startDownload(
      url: state.urlInput,
      fileName: fileName,
    );

    if (taskId == null) {
      state = state.copyWith(error: 'Failed to start download');
      return false;
    }

    await loadDownloads();
    state = state.copyWith(
      urlInput: '',
      urlValid: false,
      suggestedFileName: null,
      suggestedFileSize: null,
    );
    return true;
  }

  Future<void> pauseDownload(String taskId) async {
    await _service.pauseDownload(taskId);
    await loadDownloads();
  }

  Future<void> resumeDownload(String taskId) async {
    await _service.resumeDownload(taskId);
    await loadDownloads();
  }

  Future<void> cancelDownload(String taskId) async {
    await _service.cancelDownload(taskId);
    await loadDownloads();
  }

  Future<void> retryDownload(String taskId) async {
    await _service.retryDownload(taskId);
    await loadDownloads();
  }

  Future<void> deleteDownload(String taskId, {bool deleteFile = false}) async {
    await _service.deleteDownload(taskId, deleteFile: deleteFile);
    await loadDownloads();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _port?.close();
    super.dispose();
  }
}

final downloadManagerProvider =
    StateNotifierProvider<DownloadManagerNotifier, DownloadManagerState>((ref) {
  return DownloadManagerNotifier(
    ref.watch(downloadServiceProvider),
    ref.watch(extractorServiceProvider),
  );
});
