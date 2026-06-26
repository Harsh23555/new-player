# Nova Player — Advanced Download Feature Issues

> **Project:** `nova_player` · Flutter + Riverpod + Isar · `just_audio` / `video_player`  
> **Existing download infrastructure:** `DownloadService`, `DownloadRepository`, `DownloadManagerScreen`, `DownloadManagerNotifier`, `flutter_downloader`, `dio`, Isar `DownloadEntity` — all already wired in `main.dart`.  
> Each issue is **fully self-contained**. Implement them in the order listed.

---

## Issue #1 — Media Info Extraction (YouTube / Instagram / Public URLs)

### Summary
Add a media-info extraction layer that, given a shared/pasted URL (YouTube, Instagram, direct media link), fetches available streams with quality labels so the user can pick a quality before downloading. This is the foundation all other issues build on.

### Gap in existing code
`DownloadService.validateUrl()` only does an HTTP HEAD request — it cannot extract stream URLs or qualities from YouTube/Instagram. A dedicated extraction service is needed.

### New files to create
| File | Purpose |
|------|---------|
| `lib/data/services/media_extractor_service.dart` | Calls `yt-dlp` via platform channel OR uses `youtube_explode_dart` to get stream manifests |
| `lib/data/models/media_info_model.dart` | Holds title, thumbnail, duration, platform, and list of `StreamOption` |
| `lib/data/models/stream_option_model.dart` | Quality label, itag/url, format, file size estimate, mediaType (video/audio) |
| `lib/features/downloads/providers/media_extractor_provider.dart` | Riverpod `AsyncNotifier` wrapping `MediaExtractorService` |

### Package to add in `pubspec.yaml`
```yaml
  youtube_explode_dart: ^2.2.0   # YouTube stream extraction, no binary needed
  receive_sharing_intent: ^1.8.0  # Catches shared URLs from other apps
```

### `StreamOption` model
```dart
class StreamOption {
  final String qualityLabel; // "1080p", "720p", "audio only", etc.
  final String url;
  final String mimeType;     // video/mp4, audio/webm
  final MediaType mediaType; // MediaType.video | MediaType.audio
  final int? fileSizeBytes;
  final int? bitrate;
  final String ext;          // mp4, webm, m4a
}

enum MediaType { video, audio }
```

### `MediaInfoModel`
```dart
class MediaInfoModel {
  final String sourceUrl;
  final String title;
  final String? thumbnailUrl;
  final Duration? duration;
  final String platform;          // "YouTube", "Instagram", "Direct"
  final List<StreamOption> streams;
}
```

### `MediaExtractorService` skeleton
```dart
class MediaExtractorService {
  final _yt = YoutubeExplode();

  Future<MediaInfoModel> extract(String url) async {
    if (_isYouTube(url)) return _extractYouTube(url);
    if (_isInstagram(url)) return _extractInstagram(url);
    return _extractDirect(url); // falls back to HEAD request
  }

  Future<MediaInfoModel> _extractYouTube(String url) async {
    final videoId = VideoId(url);
    final video = await _yt.videos.get(videoId);
    final manifest = await _yt.videos.streamsClient.getManifest(videoId);
    final streams = <StreamOption>[
      ...manifest.videoOnly.map((s) => StreamOption(
        qualityLabel: s.videoQuality.name,
        url: s.url.toString(),
        mimeType: s.codec.mimeType,
        mediaType: MediaType.video,
        fileSizeBytes: s.size.totalBytes,
        ext: 'mp4',
      )),
      ...manifest.audioOnly.map((s) => StreamOption(
        qualityLabel: 'Audio Only (${(s.bitrate.bitsPerSecond / 1000).round()} kbps)',
        url: s.url.toString(),
        mimeType: s.codec.mimeType,
        mediaType: MediaType.audio,
        fileSizeBytes: s.size.totalBytes,
        ext: 'm4a',
      )),
    ];
    return MediaInfoModel(
      sourceUrl: url,
      title: video.title,
      thumbnailUrl: video.thumbnails.highResUrl,
      duration: video.duration,
      platform: 'YouTube',
      streams: streams,
    );
  }

  bool _isYouTube(String url) =>
      url.contains('youtube.com') || url.contains('youtu.be');
  bool _isInstagram(String url) => url.contains('instagram.com');
}
```

### Acceptance criteria
- [ ] Given a YouTube URL, returns a `MediaInfoModel` with streams at available qualities.
- [ ] Given a direct `.mp4`/`.mp3` URL, returns a single `StreamOption`.
- [ ] Instagram URLs: attempt extraction; return a helpful error if unavailable.
- [ ] Extraction runs in under 4 seconds on a typical connection.
- [ ] All errors surface as `AsyncError` in the provider (no silent failures).

---

## Issue #2 — Quality Picker Bottom Sheet UI

### Summary
When the user pastes/shares a URL, show a bottom sheet displaying the video thumbnail, title, duration, platform badge, and all available quality options as selectable tiles. The user taps a quality and then presses **Download**.

### New files to create
| File | Purpose |
|------|---------|
| `lib/features/downloads/presentation/widgets/quality_picker_sheet.dart` | Full bottom-sheet widget |
| `lib/features/downloads/presentation/widgets/stream_option_tile.dart` | Single quality row tile |

### Modify existing files
| File | Change |
|------|--------|
| `lib/features/downloads/presentation/screens/download_manager_screen.dart` | Replace `validateUrl()` + Download button flow with `_showQualityPicker()` call |
| `lib/features/downloads/providers/download_manager_provider.dart` | Add `startDownloadFromStream(StreamOption, MediaInfoModel)` method |

### `QualityPickerSheet` structure
```dart
showModalBottomSheet(
  isScrollControlled: true,
  builder: (_) => QualityPickerSheet(info: mediaInfo),
);

// Inside QualityPickerSheet:
// 1. Thumbnail + title + platform badge + duration chip
// 2. Two sections: "Video" streams and "Audio Only" streams
// 3. Each row: quality label, format badge, file-size estimate, radio selector
// 4. "Download" gradient button — disabled until a quality is selected
// 5. Loading shimmer while extraction is in progress
```

### Quality grouping logic
```dart
final videoStreams = info.streams
    .where((s) => s.mediaType == MediaType.video)
    .toList()
  ..sort((a, b) => _qualityOrder(b.qualityLabel) - _qualityOrder(a.qualityLabel));

final audioStreams = info.streams
    .where((s) => s.mediaType == MediaType.audio)
    .toList();
```

### Acceptance criteria
- [ ] Sheet appears immediately with a shimmer while extraction is loading.
- [ ] Video qualities shown in descending order: 1080p → 720p → 480p → 360p → 240p → 144p.
- [ ] Audio-only streams shown in a separate section below.
- [ ] Each tile shows: quality label, file size (or "~XMB"), format extension badge.
- [ ] Only one option can be selected at a time (radio button pattern).
- [ ] Download button becomes active only after a quality is selected.
- [ ] If extraction fails, shows an error state with a Retry button inside the sheet.
- [ ] Sheet dismisses and a SnackBar confirms "Download started" on success.

---

## Issue #3 — Enhanced `DownloadEntity` + `DownloadModel` Schema

### Summary
Extend the Isar `DownloadEntity` and `DownloadModel` with the new fields needed to store quality, platform, thumbnail, media type, and source URL separately from the download URL (which may be a CDN stream URL).

### Modify existing files
| File | Change |
|------|--------|
| `lib/data/models/db/download_entity.dart` | Add new fields |
| `lib/data/models/download_model.dart` | Mirror new fields + add computed getters |
| `lib/data/repositories/download_repository.dart` | Add `getBySourceUrl(String)` for duplicate detection |

### New fields for `DownloadEntity`
```dart
@collection
class DownloadEntity {
  // ... existing fields unchanged ...

  String? sourceUrl;       // original YouTube/Instagram link
  String? platform;        // "YouTube", "Instagram", "Direct"
  String? qualityLabel;    // "720p", "Audio Only"
  String? mediaType;       // "video" | "audio"
  String? thumbnailUrl;    // remote thumbnail URL
  String? title;           // human-readable title (not just fileName)
  int? fileSizeEstimate;   // bytes, from manifest before download
}
```

### Duplicate detection method
```dart
// In DownloadRepository
Future<bool> existsBySourceUrlAndQuality(String sourceUrl, String quality) async {
  final entity = await _isar.downloadEntitys
      .filter()
      .sourceUrlEqualTo(sourceUrl)
      .and()
      .qualityLabelEqualTo(quality)
      .and()
      .statusEqualTo(2) // complete
      .findFirst();
  return entity != null;
}
```

### After modifying the Isar schema
Run code generation:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### Acceptance criteria
- [ ] All new fields are nullable (backward compatible with existing records).
- [ ] `DownloadModel.title` falls back to `fileName` if null.
- [ ] `DownloadModel.platformBadgeColor` returns a color per platform.
- [ ] `DownloadRepository.existsBySourceUrlAndQuality` returns `true` if an identical download already completed.
- [ ] Generated Isar `.g.dart` files compile without error.

---

## Issue #4 — Share Intent Integration (Receive Shared URLs)

### Summary
When a user shares a YouTube or media URL from any external app (YouTube, Chrome, Instagram) to Nova Player, automatically open the Quality Picker Sheet without requiring any manual pasting.

### New files to create
| File | Purpose |
|------|---------|
| `lib/core/utils/share_intent_handler.dart` | Listens to `receive_sharing_intent` and dispatches to extraction |

### Modify existing files
| File | Change |
|------|--------|
| `android/app/src/main/AndroidManifest.xml` | Add `intent-filter` for `ACTION_SEND` + `text/plain` MIME |
| `lib/core/app.dart` | Initialize share intent listener in root widget `initState` |
| `lib/core/router/app_router.dart` | Add `/downloads/pick-quality` route accepting `MediaInfoModel` extra |

### AndroidManifest intent filter (add inside `<activity>`)
```xml
<intent-filter>
  <action android:name="android.intent.action.SEND" />
  <category android:name="android.intent.category.DEFAULT" />
  <data android:mimeType="text/plain" />
</intent-filter>
```

### Share intent listener
```dart
class ShareIntentHandler {
  static StreamSubscription? _sub;

  static void init(BuildContext context, WidgetRef ref) {
    _sub = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedMediaFile> files) {
      final url = files.firstOrNull?.path;
      if (url != null && url.startsWith('http')) {
        ref.read(mediaExtractorProvider.notifier).extract(url);
        // navigate to download screen and show quality picker
      }
    });

    // Handle URL shared while app was closed
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      final url = files.firstOrNull?.path;
      if (url != null) {
        ref.read(mediaExtractorProvider.notifier).extract(url);
      }
    });
  }

  static void dispose() => _sub?.cancel();
}
```

### Acceptance criteria
- [ ] Sharing a YouTube URL from YouTube app to Nova Player opens the Quality Picker Sheet automatically.
- [ ] Sharing a direct `.mp4` link starts the download immediately (no quality selection needed).
- [ ] If the app is open, the sheet opens over the current screen without navigation disruption.
- [ ] If the app is closed, it opens to the Downloads tab with the sheet visible.
- [ ] Invalid/non-media URLs show a SnackBar: "This link doesn't contain downloadable media".

---

## Issue #5 — Real-time Download Progress with Speed, ETA & Notifications

### Summary
Upgrade the existing `DownloadManagerNotifier._onDownloadProgress` callback to compute real download speed (bytes/second) and ETA in real-time using a rolling window, and show a persistent Android notification with progress bar.

### Modify existing files
| File | Change |
|------|--------|
| `lib/features/downloads/providers/download_manager_provider.dart` | Add speed computation using timestamp deltas |
| `lib/data/services/download_service.dart` | Pass `headers` with `User-Agent` for CDN compatibility; add `saveInPublicStorage` flag |
| `lib/data/repositories/download_repository.dart` | `updateProgress` already takes speed — ensure it is called with computed value |

### Speed computation (add to `DownloadManagerNotifier`)
```dart
final Map<String, _ProgressSample> _samples = {};

void _onDownloadProgress(String taskId, int status, int progress) {
  final now = DateTime.now();
  final prev = _samples[taskId];

  double speedBps = 0;
  int eta = 0;

  final download = state.downloads.firstWhere(
    (d) => d.taskId == taskId, orElse: () => null,
  );

  if (download != null && prev != null) {
    final elapsed = now.difference(prev.time).inMilliseconds / 1000.0;
    final downloaded = (download.totalBytes * progress / 100).toInt();
    final delta = downloaded - prev.downloadedBytes;
    if (elapsed > 0) speedBps = delta / elapsed;
    final remaining = download.totalBytes - downloaded;
    if (speedBps > 0) eta = (remaining / speedBps).round();
  }

  _samples[taskId] = _ProgressSample(
    time: now,
    downloadedBytes: (download?.totalBytes ?? 0) * progress ~/ 100,
  );
  // update state and persist
}

class _ProgressSample {
  final DateTime time;
  final int downloadedBytes;
  const _ProgressSample({required this.time, required this.downloadedBytes});
}
```

### Notification channel (already configured via `flutter_downloader`)
Ensure `showNotification: true` and add `notificationContent` with progress text. `flutter_downloader` handles the system notification automatically — no extra code needed for the notification bar.

### Acceptance criteria
- [ ] `download.formattedSpeed` shows a non-zero value (e.g., "2.3 MB/s") within 2 seconds of starting.
- [ ] `download.formattedEta` shows a reasonable estimate (e.g., "1m 23s").
- [ ] Speed and ETA update at most every 500 ms (avoid excessive rebuilds).
- [ ] Android notification shows file name, progress percentage, and speed.
- [ ] Notification persists after the app is backgrounded.
- [ ] On completion, notification changes to "Download complete — tap to open".

---

## Issue #6 — Auto-Library Integration (Downloaded Files Appear in App)

### Summary
When a download completes, automatically scan the downloaded file and add it to the Audio or Video library so it's immediately playable in the built-in player without requiring a manual rescan.

### Modify existing files
| File | Change |
|------|--------|
| `lib/features/downloads/providers/download_manager_provider.dart` | Call `_onDownloadComplete(download)` when `status == 2` |
| `lib/data/repositories/audio_repository.dart` | Add `insertFromPath(String path)` |
| `lib/data/repositories/video_repository.dart` | Add `insertFromPath(String path)` |
| `lib/features/audio/providers/audio_library_provider.dart` | Expose `rescanSingle(String path)` |
| `lib/features/video/providers/video_library_provider.dart` | Expose `rescanSingle(String path)` |

### Completion handler
```dart
Future<void> _onDownloadComplete(DownloadModel download) async {
  final path = '${download.savePath}/${download.fileName}';
  final file = File(path);
  if (!await file.exists()) return;

  final ext = p.extension(path).toLowerCase();
  final isAudio = ['.mp3', '.m4a', '.flac', '.wav', '.aac', '.ogg'].contains(ext);
  final isVideo = ['.mp4', '.mkv', '.webm', '.avi', '.mov'].contains(ext);

  if (isAudio) {
    await _ref.read(audioLibraryProvider.notifier).rescanSingle(path);
  } else if (isVideo) {
    await _ref.read(videoLibraryProvider.notifier).rescanSingle(path);
  }
}
```

### Acceptance criteria
- [ ] A downloaded `.mp4` appears in Video Library within 5 seconds of completion without manual rescan.
- [ ] A downloaded `.m4a` / `.mp3` appears in Audio Library similarly.
- [ ] The new library entry is playable in both the built-in player and external players (VLC, Nova Player).
- [ ] Duplicate insertion is prevented (check by file path before inserting).
- [ ] If the library scan fails, it is logged — download record is still marked complete.

---

## Issue #7 — Duplicate File Detection

### Summary
Before starting any download, check if an identical file (same source URL + quality) already exists as a completed download, and warn the user rather than downloading again.

### Modify existing files
| File | Change |
|------|--------|
| `lib/features/downloads/providers/download_manager_provider.dart` | Call `_checkDuplicate()` inside `startDownloadFromStream()` |
| `lib/data/repositories/download_repository.dart` | Use `existsBySourceUrlAndQuality()` from Issue #3 |

### Duplicate check flow
```dart
Future<bool> startDownloadFromStream(StreamOption stream, MediaInfoModel info) async {
  // 1. Check duplicate
  final isDuplicate = await _service.repository.existsBySourceUrlAndQuality(
    info.sourceUrl, stream.qualityLabel,
  );
  if (isDuplicate) {
    state = state.copyWith(duplicateWarning: '${info.title} at ${stream.qualityLabel} is already downloaded.');
    return false;
  }

  // 2. Also check if file physically exists
  final fileName = _buildFileName(info.title, stream);
  final destPath = '${await _service.downloadDirectory}/$fileName';
  if (await File(destPath).exists()) {
    state = state.copyWith(duplicateWarning: 'File already exists at $destPath');
    return false;
  }

  // 3. Proceed with download
  ...
}
```

### UI — show duplicate warning
In `DownloadManagerScreen` / `QualityPickerSheet`, watch `state.duplicateWarning` and show an `AlertDialog`:
```
"Already Downloaded"
"[Title] at 720p is already in your library. Download again?"
[Cancel]  [Download Again]
```

### Acceptance criteria
- [ ] If the same YouTube video at the same quality was previously downloaded (complete status), user sees the warning dialog.
- [ ] User can choose to skip or force re-download.
- [ ] Physical file existence check is independent of the DB check (covers manual deletions).
- [ ] `duplicateWarning` is cleared after the dialog is dismissed.

---

## Issue #8 — Background Download + Android Permissions

### Summary
Ensure downloads continue when the app is backgrounded or the screen locks, and that all required Android 13/14/15 permissions are correctly declared and requested at runtime.

### Modify existing files
| File | Change |
|------|--------|
| `android/app/src/main/AndroidManifest.xml` | Add all required permissions |
| `lib/data/services/permission_service.dart` | Add `requestDownloadPermissions()` method |
| `lib/features/downloads/presentation/screens/download_manager_screen.dart` | Request permissions in `initState` before any download |
| `lib/main.dart` | Confirm `FlutterDownloader.initialize()` already present (it is — line 53) |

### AndroidManifest permissions to add
```xml
<!-- Android ≤12 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />

<!-- Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

<!-- All versions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Android 14+ -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
```

### Permission request helper
```dart
// In PermissionService (lib/data/services/permission_service.dart)
Future<bool> requestDownloadPermissions() async {
  if (Platform.isAndroid) {
    final sdk = int.tryParse(
      (await DeviceInfoPlugin().androidInfo).version.release,
    ) ?? 0;

    if (sdk >= 33) {
      final statuses = await [
        Permission.videos,
        Permission.audio,
        Permission.notification,
      ].request();
      return statuses.values.every((s) => s.isGranted);
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }
  return true;
}
```

### Acceptance criteria
- [ ] On first download attempt, app requests all required permissions with a rationale dialog.
- [ ] If `POST_NOTIFICATIONS` is denied, downloads still work but notification is silently skipped.
- [ ] Downloads continue running when the app is sent to background (verified via notification).
- [ ] Downloads survive screen lock.
- [ ] No `SecurityException` or `Permission denied` crashes on Android 13, 14, or 15.
- [ ] `flutter_downloader`'s background isolate callback (`downloadCallback`) remains registered — do not remove it.

---

## Issue #9 — Download History Screen UI Overhaul

### Summary
Replace the current basic `download_manager_screen.dart` tab layout with a polished, feature-rich Download Manager that includes: search, filter by status, thumbnail preview, platform badges, quality badges, open-file action, and share action.

### Modify existing files
| File | Change |
|------|--------|
| `lib/features/downloads/presentation/screens/download_manager_screen.dart` | Full overhaul — keep existing provider wiring, replace UI |
| `lib/features/downloads/presentation/widgets/download_card.dart` | **Extract** `_DownloadCard` into its own reusable file |

### New UI layout for `DownloadManagerScreen`
```
AppBar: "Downloads"  [search icon]  [filter chip row]
│
├─ Sticky input section (collapsed when scrolled down):
│   ─ URL TextField  [Paste]  [Analyze]
│   ─ QualityPickerSheet triggered on Analyze
│
└─ TabBar: Active | Done | Failed | All
    └─ ListView of DownloadCard widgets
```

### Enhanced `DownloadCard` features
- Left: 60×60 thumbnail (from `thumbnailUrl`) or file-type icon fallback
- Center: title, platform badge (YouTube=red, Instagram=purple, Direct=cyan), quality badge, file size
- Right: action buttons (pause/resume/cancel/retry/delete)
- Bottom: animated `LinearPercentIndicator` with speed + ETA labels
- Completed: "Open" button (`open_file` package) + share button
- Long-press: context menu with Open, Share, Copy Path, Delete

### New packages to add
```yaml
  open_file_plus: ^3.4.1    # open downloaded file in system player
  share_plus: ^9.0.0        # already in pubspec.yaml
```

### Acceptance criteria
- [ ] Thumbnail loads from `thumbnailUrl` using `CachedNetworkImage`; falls back to file-type icon.
- [ ] Platform badge (YouTube / Instagram / Direct) shown on each card.
- [ ] Quality badge (720p / Audio) shown on each card.
- [ ] "Open" button on completed downloads opens file in system default player.
- [ ] Search bar filters downloads by title/filename in real-time.
- [ ] Filter chips (All / Video / Audio) filter by media type.
- [ ] Pull-to-refresh reloads download list.
- [ ] All existing pause/resume/cancel/retry/delete actions still work.
- [ ] Empty state shows platform-specific instructions ("Share a YouTube link to Nova Player").

---

## Issue #10 — Error Handling & Retry Logic

### Summary
Implement robust, user-facing error handling for all failure modes: network loss, CDN URL expiry, unsupported platform, storage full, and permission denied. Each failure mode should have a specific, actionable error message and a retry strategy.

### Modify existing files
| File | Change |
|------|--------|
| `lib/data/services/media_extractor_service.dart` | Wrap all calls in typed exceptions |
| `lib/data/services/download_service.dart` | Detect and surface specific errors |
| `lib/features/downloads/providers/download_manager_provider.dart` | Map exception types to user messages |

### Custom exception types
```dart
// lib/core/exceptions/download_exceptions.dart
class ExtractionException implements Exception {
  final String message;
  final String? platform;
  const ExtractionException(this.message, {this.platform});
}

class UnsupportedPlatformException extends ExtractionException {
  UnsupportedPlatformException(String platform)
      : super('$platform links are not supported yet', platform: platform);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class StorageFullException implements Exception {
  final int requiredBytes;
  const StorageFullException(this.requiredBytes);
}

class PermissionDeniedException implements Exception {}
```

### Error → user message mapping
```dart
String _userFriendlyError(Object e) {
  if (e is UnsupportedPlatformException)
    return 'Downloads from ${e.platform} are not supported yet.';
  if (e is ExtractionException) return 'Could not read media info: ${e.message}';
  if (e is NetworkException) return 'No internet connection. Check your network.';
  if (e is StorageFullException)
    return 'Not enough storage. Need ${_formatBytes(e.requiredBytes)}.';
  if (e is PermissionDeniedException)
    return 'Storage permission required. Tap to open Settings.';
  return 'Download failed. Please try again.';
}
```

### Retry with re-extraction
CDN stream URLs expire (typically after 6 hours for YouTube). On retry, always re-extract the manifest rather than retrying the original URL:
```dart
Future<void> retryDownload(String taskId) async {
  final download = await _service.repository.getByTaskId(taskId);
  if (download?.sourceUrl != null) {
    // Re-extract fresh URL from original source
    final info = await _extractorService.extract(download!.sourceUrl!);
    final stream = info.streams.firstWhere(
      (s) => s.qualityLabel == download.qualityLabel,
    );
    await startDownloadFromStream(stream, info);
    await _service.deleteDownload(taskId, deleteFile: false);
  } else {
    await _service.retryDownload(taskId); // fallback
  }
}
```

### Acceptance criteria
- [ ] Network loss during download shows "No internet connection" on the card.
- [ ] Retrying a failed YouTube download re-extracts a fresh stream URL.
- [ ] Unsupported platforms (TikTok, Twitter) show "not supported yet" — no crash.
- [ ] Storage full detection shows required vs. available space.
- [ ] Permission denied shows a tappable snackbar linking to app Settings.
- [ ] All errors are logged via `AppLogger.error()` (already present in project).
- [ ] No `UnhandledException` crashes reach the user.

---

## Implementation Order

```
#1 Extraction Service  →  #3 Schema  →  #2 Quality Picker UI
  →  #4 Share Intent  →  #5 Progress  →  #6 Library Integration
  →  #7 Duplicate Detection  →  #8 Permissions  →  #9 UI Overhaul  →  #10 Error Handling
```

## New packages summary (add to `pubspec.yaml`)

```yaml
  youtube_explode_dart: ^2.2.0
  receive_sharing_intent: ^1.8.0
  open_file_plus: ^3.4.1
```

Run after adding:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

---

# Nova Player — Player Feature Issues

> **Architecture context for Issues #11–#13:**  
> Audio player: `lib/features/audio/presentation/screens/audio_player_screen.dart` (569 lines) · `AudioPlayerNotifier` in `audio_player_provider.dart` · service: `AudioPlayerService` (`just_audio`).  
> Video player: `lib/features/video/presentation/screens/video_player_screen.dart` (746 lines) · `VideoPlayerNotifier` in `video_player_provider.dart` · `video_player` package.  
> State management: Riverpod `StateNotifier`. DB: Isar (existing collections: `AudioEntity`, `VideoEntity`, `DownloadEntity`, `SettingsEntity`, `RecentlyPlayedEntity`).  
> Each issue is **fully self-contained** — an AI tool needs only the issue text and the listed files.

---

## Issue #11 — Delete Media File (Audio & Video)

### Summary
Add the ability to permanently delete a local audio or video file from device storage directly within the app. The action must show a confirmation dialog, stop playback if the file is currently playing, remove the file from the Isar database, refresh the library list, and show a SnackBar result — all without restarting the app.

### Current state (what is missing)
- `AudioPlayerScreen._showOptions()` (lines 539–561 of `audio_player_screen.dart`) contains only "Share" and "Song Info" stubs with `Navigator.pop` — no delete.
- `AudioLibraryScreen` tiles (`_AudioTile`) have only a favourite heart icon — no long-press menu.
- `VideoLibraryScreen` grid/list cards (`_VideoGridCard`, `_VideoListTile`) have only a favourite icon.
- No `deleteTrack` or `deleteVideo` method exists anywhere in providers or repositories.

### Affected files
| File | Change |
|------|--------|
| `lib/data/repositories/audio_repository.dart` | Add `deleteByPath(String path)` |
| `lib/data/repositories/video_repository.dart` | Add `deleteByPath(String path)` |
| `lib/features/audio/providers/audio_library_provider.dart` | Add `deleteTrack(AudioModel track)` to `AudioLibraryNotifier` |
| `lib/features/video/providers/video_library_provider.dart` | Add `deleteVideo(VideoModel video)` to `VideoLibraryNotifier` |
| `lib/features/audio/presentation/screens/audio_library_screen.dart` | Add long-press on `_AudioTile` → options menu with Delete |
| `lib/features/audio/presentation/screens/audio_player_screen.dart` | Add "Delete" `ListTile` inside `_showOptions()` |
| `lib/features/video/presentation/screens/video_library_screen.dart` | Add long-press on `_VideoGridCard` and `_VideoListTile` → options menu |
| `lib/shared/widgets/common_widgets.dart` | Add reusable `showConfirmDeleteDialog` helper |

### Step 1 — Repository methods
```dart
// lib/data/repositories/audio_repository.dart  — add at bottom
Future<void> deleteByPath(String path) async {
  // 1. Delete physical file
  final file = File(path);
  if (await file.exists()) await file.delete();
  // 2. Remove from Isar
  await _isar.writeTxn(() async {
    await _isar.audioEntitys.filter().pathEqualTo(path).deleteAll();
  });
}
```
Mirror the same method in `video_repository.dart` using `_isar.videoEntitys`.

### Step 2 — Provider methods
```dart
// In AudioLibraryNotifier  (audio_library_provider.dart)
Future<void> deleteTrack(AudioModel track) async {
  await ref.read(audioRepositoryProvider).deleteByPath(track.path);
  state = state.copyWith(
    tracks: state.tracks.where((t) => t.id != track.id).toList(),
  );
}
```
Mirror for `VideoLibraryNotifier.deleteVideo(VideoModel)`.

### Step 3 — Shared confirmation dialog
```dart
// lib/shared/widgets/common_widgets.dart  — add helper
Future<bool> showConfirmDeleteDialog(BuildContext context, String title) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete file?'),
          content: Text(
            'Permanently delete "$title"?\nThis cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(_, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(_, true),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ??
      false;
}
```

### Step 4 — Audio library tile (long-press)
In `_AudioTile.build()`, change the outer `InkWell` to add `onLongPress`:
```dart
onLongPress: () => _showTileOptions(context, ref, track),
```
Then add the `_showTileOptions` function:
```dart
void _showTileOptions(BuildContext context, WidgetRef ref, AudioModel track) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              final ok = await showConfirmDeleteDialog(context, track.title);
              if (ok) {
                await ref.read(audioLibraryProvider.notifier).deleteTrack(track);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${track.title}" deleted')),
                  );
                }
              }
            },
          ),
        ],
      ),
    ),
  );
}
```

### Step 5 — Audio player screen options
In `_showOptions()` (line ~547 of `audio_player_screen.dart`), add after the "Song Info" `ListTile`:
```dart
ListTile(
  leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
  title: const Text('Delete', style: TextStyle(color: Colors.red)),
  onTap: () async {
    Navigator.pop(ctx); // close options sheet
    final track = ref.read(currentTrackProvider);
    if (track == null) return;
    final ok = await showConfirmDeleteDialog(context, track.title);
    if (ok) {
      // Stop playback first
      await ref.read(audioPlayerNotifierProvider.notifier).pause();
      await ref.read(audioLibraryProvider.notifier).deleteTrack(track);
      if (mounted) {
        Navigator.pop(context); // pop player screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${track.title}" deleted')),
        );
      }
    }
  },
),
```

### Step 6 — Video library cards (long-press)
In `_VideoGridCard.build()` and `_VideoListTile.build()`, wrap the outer `GestureDetector`/`InkWell` with `onLongPress`:
```dart
onLongPress: () => _showVideoOptions(context, ref, video),
```
Implement `_showVideoOptions` following the same bottom-sheet pattern as Step 4 but calling `videoLibraryProvider.notifier.deleteVideo(video)`.

### Acceptance criteria
- [ ] Long-pressing any audio tile shows an options sheet with a red Delete item.
- [ ] Long-pressing any video card shows the same options sheet.
- [ ] The more-vert menu (`_showOptions`) in `AudioPlayerScreen` contains a red Delete option.
- [ ] Tapping Delete always shows the `AlertDialog` confirmation before acting.
- [ ] On confirm: file deleted from filesystem, removed from Isar, library list updates immediately (no rescan).
- [ ] If the deleted track is currently playing, playback stops and the player screen is popped.
- [ ] On cancel: nothing happens, no state change.
- [ ] A SnackBar appears: `"[Title] deleted"` on success.
- [ ] `FileSystemException` (file already gone) is caught and treated as success.
- [ ] No extra packages required — uses `dart:io`, Isar, and existing Riverpod providers.

---

## Issue #12 — True Fullscreen Toggle (Video Player)

### Summary
Add an on-demand fullscreen toggle button to the video player. Tapping it switches between portrait (default) and immersive landscape (hidden system UI), updating the button icon to reflect the current state. The current `_setImmersive()` startup method forces landscape permanently — this must be changed so the player opens in portrait and the user opts into fullscreen.

### Current state (what is missing)
- `_setImmersive()` at line 59 of `video_player_screen.dart` runs unconditionally in `initState`, forcing landscape + `SystemUiMode.immersiveSticky` from the moment the player opens.
- The bottom control row (lines 569–627) ends with the resolution badge — there is **no fullscreen button**.
- There is no `_isFullscreen` state variable or toggle method anywhere.

### Affected files
| File | Change |
|------|--------|
| `lib/features/video/presentation/screens/video_player_screen.dart` | All changes — add state, toggle method, button, fix initState |

### Step 1 — Add state variable (in `_VideoPlayerScreenState`, alongside `_controlsVisible`)
```dart
bool _isFullscreen = false;
```

### Step 2 — Replace `_setImmersive()` so the player opens in portrait
```dart
// BEFORE (line 59–66):
Future<void> _setImmersive() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

// AFTER — only hide system UI; keep portrait:
Future<void> _setImmersive() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}
```

### Step 3 — Add the toggle method
```dart
Future<void> _toggleFullscreen() async {
  final next = !_isFullscreen;
  setState(() => _isFullscreen = next);
  if (next) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } else {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
```

### Step 4 — Add the fullscreen button to the bottom control row
In `_buildControls()`, inside the bottom `Row` (after the resolution badge chip, ~line 624), add:
```dart
IconButton(
  visualDensity: VisualDensity.compact,
  onPressed: _toggleFullscreen,
  icon: Icon(
    _isFullscreen
        ? Icons.fullscreen_exit_rounded
        : Icons.fullscreen_rounded,
    color: Colors.white,
    size: 22,
  ),
  tooltip: _isFullscreen ? 'Exit Fullscreen' : 'Fullscreen',
),
```

### Step 5 — Keep `dispose()` correct (it already is)
The existing `dispose()` at line 109 resets orientation to portrait — **leave it unchanged**.

### Step 6 — (Optional) Sync `_isFullscreen` when user physically rotates device
```dart
// In build(), read orientation and sync _isFullscreen:
final isLandscape =
    MediaQuery.of(context).orientation == Orientation.landscape;
if (isLandscape != _isFullscreen) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => setState(() => _isFullscreen = isLandscape),
  );
}
```

### Acceptance criteria
- [ ] Player opens in **portrait** by default (no forced landscape on launch).
- [ ] A fullscreen icon (`Icons.fullscreen_rounded`) is visible in the bottom control bar, to the right of the resolution badge.
- [ ] Tapping it enters landscape immersive fullscreen; icon changes to `Icons.fullscreen_exit_rounded`.
- [ ] Tapping it again returns to portrait; system UI (status bar + nav bar) is restored.
- [ ] The back button correctly restores portrait orientation when pressed from either state.
- [ ] `_isFullscreen` visually stays in sync when the user physically rotates the device.
- [ ] No new packages required — uses only `flutter/services.dart` (already imported on line 4).
- [ ] Wakelock and PiP features are unaffected.

---

## Issue #13 — In-App Equalizer (Audio Player)

### Summary
Add a 5-band parametric equalizer with preset support (Flat, Rock, Pop, Classical, Jazz, Bass Boost, Vocal) to the audio player. Tapping a new EQ button in the top bar opens a `DraggableScrollableSheet` with vertical band sliders and preset chips. EQ state (enabled, preset, band gains) persists across sessions via a new Isar entity. The EQ icon in the top bar is highlighted when the EQ is active.

### Current state (what is missing)
- No equalizer exists — no EQ button, no EQ provider, no UI widget, no persistence.
- The top bar of `AudioPlayerScreen._buildTopBar()` (lines 107–163) has: back button, "NOW PLAYING" label, sleep timer button, more-vert button. The EQ button must be inserted **between the sleep timer button and the more-vert button**.
- `pubspec.yaml` does not include an EQ package.

### New package to add
```yaml
# pubspec.yaml — under dependencies
  just_audio_equalizer: ^0.0.7
```
Run `flutter pub get` after adding.

> **Note:** `just_audio_equalizer` wraps the Android `android.media.audiofx.Equalizer` class. On iOS it is a graceful no-op. Test on a **physical Android device** — emulators often disable `AudioEffect`.

### New files to create
| File | Purpose |
|------|---------|
| `lib/data/models/db/eq_settings_entity.dart` | Isar collection — singleton EQ settings row |
| `lib/features/audio/providers/equalizer_provider.dart` | `EqNotifier` + `EqState` with Isar persistence |
| `lib/features/audio/presentation/widgets/equalizer_sheet.dart` | Full bottom-sheet widget with sliders + preset chips |

### Modified files
| File | Change |
|------|--------|
| `lib/main.dart` | Register `EqSettingsEntitySchema` in `Isar.open()` (lines 57–67) |
| `lib/features/audio/presentation/screens/audio_player_screen.dart` | Add EQ `IconButton` in `_buildTopBar()` |

---

### Step 1 — Isar entity
```dart
// lib/data/models/db/eq_settings_entity.dart
import 'package:isar/isar.dart';
part 'eq_settings_entity.g.dart';

@collection
class EqSettingsEntity {
  Id id = 1;            // singleton — always write to id=1
  bool enabled = false;
  String preset = 'Flat';
  List<double> gains = [0, 0, 0, 0, 0]; // dB, index 0–4
}
```

Run code generation after creating this file:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

Register in `main.dart` — add `EqSettingsEntitySchema` to the `Isar.open` schemas list (line 58–64):
```dart
final isar = await Isar.open(
  [
    AudioEntitySchema,
    VideoEntitySchema,
    DownloadEntitySchema,
    SettingsEntitySchema,
    RecentlyPlayedEntitySchema,
    EqSettingsEntitySchema,   // ADD THIS
  ],
  ...
);
```

---

### Step 2 — EQ provider
```dart
// lib/features/audio/providers/equalizer_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../data/models/db/eq_settings_entity.dart';

/// Hz centre frequencies for the 5 bands
const kEqBandHz = [60, 230, 910, 3600, 14000];

/// Preset gain tables (dB per band)
const kEqPresets = <String, List<double>>{
  'Flat':       [ 0,  0,  0,  0,  0],
  'Rock':       [ 4,  2, -2,  2,  4],
  'Pop':        [-1,  3,  4,  3, -1],
  'Classical':  [ 4,  3, -2,  3,  4],
  'Jazz':       [ 3,  2,  0,  2,  3],
  'Bass Boost': [ 6,  4,  0, -1, -2],
  'Vocal':      [-2,  0,  4,  3,  1],
  'Custom':     [ 0,  0,  0,  0,  0],
};

class EqState {
  final bool enabled;
  final String preset;
  final List<double> gains; // -12 dB .. +12 dB

  const EqState({
    this.enabled = false,
    this.preset = 'Flat',
    this.gains = const [0, 0, 0, 0, 0],
  });

  EqState copyWith({bool? enabled, String? preset, List<double>? gains}) =>
      EqState(
        enabled: enabled ?? this.enabled,
        preset: preset ?? this.preset,
        gains: gains ?? this.gains,
      );
}

class EqNotifier extends StateNotifier<EqState> {
  final Isar _isar;

  EqNotifier(this._isar) : super(const EqState()) {
    _load();
  }

  /// Load persisted settings from Isar
  Future<void> _load() async {
    final entity = await _isar.eqSettingsEntitys.get(1);
    if (entity != null) {
      state = EqState(
        enabled: entity.enabled,
        preset: entity.preset,
        gains: List<double>.from(entity.gains),
      );
      if (state.enabled) _applyToPlayer();
    }
  }

  /// Persist current state to Isar
  Future<void> _save() async {
    final entity = EqSettingsEntity()
      ..id = 1
      ..enabled = state.enabled
      ..preset = state.preset
      ..gains = state.gains;
    await _isar.writeTxn(() => _isar.eqSettingsEntitys.put(entity));
  }

  void toggle() {
    state = state.copyWith(enabled: !state.enabled);
    _applyToPlayer();
    _save();
  }

  void applyPreset(String name) {
    final gains = List<double>.from(kEqPresets[name] ?? kEqPresets['Flat']!);
    state = state.copyWith(preset: name, gains: gains);
    _applyToPlayer();
    _save();
  }

  void setBandGain(int index, double db) {
    final gains = [...state.gains]..[index] = db;
    state = state.copyWith(gains: gains, preset: 'Custom');
    _applyToPlayer();
    _save();
  }

  void _applyToPlayer() {
    // Wire to just_audio_equalizer:
    // if (state.enabled) {
    //   for (int i = 0; i < state.gains.length; i++) {
    //     AudioPlayerEqualizer.setBandLevel(i, state.gains[i]);
    //   }
    //   AudioPlayerEqualizer.setEnabled(true);
    // } else {
    //   AudioPlayerEqualizer.setEnabled(false);
    // }
    //
    // Consult just_audio_equalizer README for the exact API — it varies
    // by minor version. The pattern above matches ^0.0.7.
  }
}

final eqProvider = StateNotifierProvider<EqNotifier, EqState>((ref) {
  return EqNotifier(ref.watch(isarProvider));
});
```

---

### Step 3 — Equalizer sheet widget
```dart
// lib/features/audio/presentation/widgets/equalizer_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/equalizer_provider.dart';

class EqualizerSheet extends ConsumerWidget {
  const EqualizerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eq = ref.watch(eqProvider);
    final notifier = ref.read(eqProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scroll) => Container(
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header row
              Row(children: [
                Icon(Icons.equalizer_rounded,
                    color: eq.enabled ? AppTheme.primaryViolet : AppTheme.darkTextMuted),
                const SizedBox(width: 8),
                Text('Equalizer',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                Switch(
                  value: eq.enabled,
                  onChanged: (_) => notifier.toggle(),
                  activeColor: AppTheme.primaryViolet,
                ),
              ]),
              const SizedBox(height: 16),

              // Preset chips
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: kEqPresets.keys.map((name) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(name,
                          style: const TextStyle(fontSize: 12)),
                      selected: eq.preset == name,
                      onSelected: eq.enabled
                          ? (_) => notifier.applyPreset(name)
                          : null,
                      selectedColor: AppTheme.primaryViolet,
                      labelStyle: TextStyle(
                        color: eq.preset == name
                            ? Colors.white
                            : AppTheme.darkTextSecondary,
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Band sliders
              SizedBox(
                height: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (i) => _BandSlider(
                    hz: kEqBandHz[i],
                    gain: eq.gains[i],
                    enabled: eq.enabled,
                    onChanged: (db) => notifier.setBandGain(i, db),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single vertical band slider with label
class _BandSlider extends StatelessWidget {
  final int hz;
  final double gain;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _BandSlider({
    required this.hz,
    required this.gain,
    required this.enabled,
    required this.onChanged,
  });

  String get _freqLabel =>
      hz >= 1000 ? '${(hz / 1000).toStringAsFixed(1)}k' : '$hz';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${gain >= 0 ? '+' : ''}${gain.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: enabled
                ? AppTheme.primaryViolet
                : AppTheme.darkTextMuted,
          ),
        ),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: gain,
              min: -12,
              max: 12,
              divisions: 24,
              onChanged: enabled ? onChanged : null,
              activeColor: AppTheme.primaryViolet,
              inactiveColor: AppTheme.darkBorder,
            ),
          ),
        ),
        Text(
          _freqLabel,
          style: const TextStyle(
              fontSize: 10, color: AppTheme.darkTextMuted),
        ),
        const Text(
          'Hz',
          style: TextStyle(fontSize: 9, color: AppTheme.darkTextMuted),
        ),
      ],
    );
  }
}
```

---

### Step 4 — Add EQ button to AudioPlayerScreen top bar
In `_buildTopBar()` (line ~107 of `audio_player_screen.dart`), add the EQ `IconButton` **between the sleep timer button and the more-vert button**:
```dart
// EXISTING sleep timer button (keep):
IconButton(
  onPressed: () => _showSleepTimerDialog(context),
  icon: Icon(
    Icons.timer_rounded,
    color: sleepTimer.isActive ? AppTheme.accentCyan : null,
  ),
),

// ADD EQ BUTTON HERE:
IconButton(
  onPressed: () => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const EqualizerSheet(),
  ),
  icon: Icon(
    Icons.equalizer_rounded,
    color: ref.watch(eqProvider).enabled
        ? AppTheme.primaryViolet
        : null,
  ),
  tooltip: 'Equalizer',
),

// EXISTING more-vert button (keep):
IconButton(
  onPressed: () => _showOptions(context),
  icon: const Icon(Icons.more_vert_rounded),
),
```

Also add the import at the top of `audio_player_screen.dart`:
```dart
import '../../providers/equalizer_provider.dart';
import '../widgets/equalizer_sheet.dart';
```

---

### Acceptance criteria
- [ ] After `flutter pub get` and `build_runner`, the app compiles without errors.
- [ ] `EqSettingsEntitySchema` is registered in `Isar.open()` in `main.dart`.
- [ ] A new `Icons.equalizer_rounded` button appears in the `AudioPlayerScreen` top bar between the timer and more-vert buttons.
- [ ] Tapping it opens a `DraggableScrollableSheet` with:
  - A toggle switch (enable / disable EQ).
  - 8 preset chips: Flat, Rock, Pop, Classical, Jazz, Bass Boost, Vocal, Custom.
  - 5 vertical sliders labeled: 60Hz, 230Hz, 910Hz, 3.6kHz, 14kHz.
  - Each slider shows the current gain value (e.g., "+4").
- [ ] When EQ is **disabled**, sliders and preset chips are visually greyed out and non-interactive.
- [ ] Selecting a preset snaps all 5 sliders to the preset values.
- [ ] Moving any slider sets the preset label to "Custom".
- [ ] The top-bar EQ icon is highlighted in `AppTheme.primaryViolet` when the EQ is enabled.
- [ ] EQ settings survive app restart (loaded from Isar on `EqNotifier` construction).
- [ ] On devices that do not support `AudioEffect`, the app does not crash — `_applyToPlayer()` fails silently with an `AppLogger.warning()`.
- [ ] All existing audio features (sleep timer, queue, speed, favourite, shuffle, loop) are unaffected.

---

## Implementation Order for Issues #11–#13

```
#11 Delete  →  #12 Fullscreen  →  #13 Equalizer
```

**Reason:** Delete and Fullscreen require no new packages — fastest wins. Equalizer needs a new package (`just_audio_equalizer`), a new Isar schema, and codegen — do it last to avoid blocking the others.

## Package changes for Issues #11–#13

| Package | Issue | Action |
|---------|-------|--------|
| `just_audio_equalizer: ^0.0.7` | #13 | Add to `pubspec.yaml` |

All other changes use packages already in `pubspec.yaml` or stdlib `dart:io`.

After adding the package run:
```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
