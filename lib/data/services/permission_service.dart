import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

enum PermissionType { storage, audio, video, notification }

class PermissionResult {
  final bool granted;
  final bool permanentlyDenied;
  final String? message;
  const PermissionResult({
    required this.granted,
    this.permanentlyDenied = false,
    this.message,
  });
}

class PermissionService {
  final _logger = Logger();
  int _androidVersion = 0;

  Future<void> init() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      _androidVersion = info.version.sdkInt;
    }
  }

  Future<PermissionResult> requestStoragePermission() async {
    await init();
    if (!Platform.isAndroid) return const PermissionResult(granted: true);

    if (_androidVersion >= 33) {
      // Android 13+ — request granular media permissions
      final results = await [
        Permission.audio,
        Permission.videos,
        Permission.photos,
      ].request();

      final allGranted = results.values.every((s) =>
          s == PermissionStatus.granted || s == PermissionStatus.limited);
      final anyPermanentlyDenied =
          results.values.any((s) => s == PermissionStatus.permanentlyDenied);

      return PermissionResult(
        granted: allGranted,
        permanentlyDenied: anyPermanentlyDenied,
        message: allGranted ? null : 'Media permissions required to scan files',
      );
    } else if (_androidVersion >= 30) {
      // Android 11/12 — legacy storage permission
      final status = await Permission.storage.request();
      return PermissionResult(
        granted: status.isGranted,
        permanentlyDenied: status.isPermanentlyDenied,
        message: status.isGranted ? null : 'Storage permission required',
      );
    } else {
      final status = await Permission.storage.request();
      return PermissionResult(
        granted: status.isGranted,
        permanentlyDenied: status.isPermanentlyDenied,
      );
    }
  }

  Future<PermissionResult> requestNotificationPermission() async {
    if (!Platform.isAndroid) return const PermissionResult(granted: true);
    await init();
    if (_androidVersion < 33) return const PermissionResult(granted: true);

    final status = await Permission.notification.request();
    return PermissionResult(
      granted: status.isGranted,
      permanentlyDenied: status.isPermanentlyDenied,
    );
  }

  Future<bool> hasStoragePermission() async {
    await init();
    if (!Platform.isAndroid) return true;
    if (_androidVersion >= 33) {
      return await Permission.audio.isGranted &&
          await Permission.videos.isGranted;
    }
    return await Permission.storage.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
