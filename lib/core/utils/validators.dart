class Validators {
  Validators._();

  static bool isValidUrl(String url) {
    if (url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url.trim());
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static bool isValidFileName(String name) {
    if (name.trim().isEmpty) return false;
    // Check for invalid characters on most file systems
    final invalidChars = RegExp(r'[<>:"/\\|?*\x00-\x1f]');
    return !invalidChars.hasMatch(name.trim());
  }

  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return 'URL cannot be empty';
    if (!isValidUrl(value)) return 'Please enter a valid URL';
    return null;
  }

  static String? validateFileName(String? value) {
    if (value == null || value.trim().isEmpty) return 'File name cannot be empty';
    if (!isValidFileName(value)) return 'File name contains invalid characters';
    if (value.length > 255) return 'File name is too long';
    return null;
  }

  static bool hasMediaExtension(String url) {
    final lower = url.toLowerCase();
    const mediaExts = [
      '.mp4', '.mkv', '.mov', '.avi', '.webm', '.flv', '.m4v', '.3gp', '.ts',
      '.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg', '.opus', '.wma',
    ];
    return mediaExts.any((ext) => lower.contains(ext));
  }

  static String sanitizeFileName(String name) {
    // Remove invalid characters
    var sanitized = name.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1f]'), '_');
    // Trim periods and spaces from start and end
    sanitized = sanitized.trim().replaceAll(RegExp(r'^[. ]+|[. ]+$'), '');
    if (sanitized.isEmpty) sanitized = 'download';
    if (sanitized.length > 200) sanitized = sanitized.substring(0, 200);
    return sanitized;
  }
}
