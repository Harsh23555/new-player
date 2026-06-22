import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_logger.dart';

/// Global error handler that catches unhandled exceptions
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.error(
        'Flutter error: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Handle errors from async zones
    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.fatal(
        'Uncaught platform error: $error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }

  static void handleRiverpodError(Object error, StackTrace stackTrace) {
    AppLogger.error(
      'Riverpod provider error: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static ProviderObserver get observer => _NovaProviderObserver();
}

class _NovaProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (newValue is AsyncError) {
      AppLogger.error(
        'Provider ${provider.name ?? provider.runtimeType} error',
        error: newValue.error,
        stackTrace: newValue.stackTrace,
      );
    }
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.error(
      'Provider ${provider.name ?? provider.runtimeType} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
