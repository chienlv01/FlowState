


import 'package:flutter/widgets.dart';
import 'package:state_management/state_management.dart';

/// Hook for logging state changes
class LoggerHook<T> extends StateHook<T> {
  @override
  void onStateChanged(BuildContext context, T previousState, T newState) {
    debugPrint('State changed from $previousState to $newState');
  }
}

/// Hook for performance monitoring
class PerformanceHook<T> extends StateHook<T> {
  final Stopwatch _stopwatch = Stopwatch();
  
  @override
  void onInit(BuildContext context, T initialState) {
    _stopwatch.start();
  }

  @override
  void onStateChanged(BuildContext context, T previousState, T newState) {
    debugPrint('Time since last state change: ${_stopwatch.elapsedMilliseconds}ms');
    _stopwatch.reset();
    _stopwatch.start();
  }
}