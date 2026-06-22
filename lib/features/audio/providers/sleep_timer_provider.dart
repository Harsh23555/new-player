import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Sleep Timer ───────────────────────────────────────────────────────────────
final sleepTimerProvider =
    StateNotifierProvider<SleepTimerNotifier, SleepTimerState>((ref) {
  return SleepTimerNotifier();
});

class SleepTimerState {
  final bool isActive;
  final Duration remaining;
  final Duration total;

  const SleepTimerState({
    this.isActive = false,
    this.remaining = Duration.zero,
    this.total = Duration.zero,
  });

  double get progress {
    if (total.inSeconds == 0) return 0.0;
    return (remaining.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }

  SleepTimerState copyWith({
    bool? isActive,
    Duration? remaining,
    Duration? total,
  }) {
    return SleepTimerState(
      isActive: isActive ?? this.isActive,
      remaining: remaining ?? this.remaining,
      total: total ?? this.total,
    );
  }
}

class SleepTimerNotifier extends StateNotifier<SleepTimerState> {
  Timer? _timer;
  VoidCallback? _onExpire;

  SleepTimerNotifier() : super(const SleepTimerState());

  void start(Duration duration, {VoidCallback? onExpire}) {
    _timer?.cancel();
    _onExpire = onExpire;
    state = SleepTimerState(
      isActive: true,
      remaining: duration,
      total: duration,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final newRemaining = state.remaining - const Duration(seconds: 1);
      if (newRemaining.inSeconds <= 0) {
        _timer?.cancel();
        state = state.copyWith(isActive: false, remaining: Duration.zero);
        _onExpire?.call();
      } else {
        state = state.copyWith(remaining: newRemaining);
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    state = const SleepTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
