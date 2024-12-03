import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:state_management/state_management.dart';


/// A mixin that automatically disposes providers when they're no longer needed
mixin AutoDispose<T> on StateProvider<T> {
  final _keepAlive = ValueNotifier<bool>(false);
  Timer? _timer;

  /// Time to wait before disposing (default: 30 seconds)
  Duration get disposeTimeout => const Duration(seconds: 30);

  @override
  StateNotifier<T> read(BuildContext context) {
    _keepAlive.value = true;
    _cancelTimer();
    return super.read(context);
  }

  void _startTimer() {
    _timer = Timer(disposeTimeout, () {
      if (!_keepAlive.value) {
        dispose();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    _keepAlive.dispose();
    super.dispose();
  }

  /// Keeps the provider alive even when there are no listeners
  void keepAlive() {
    _keepAlive.value = true;
  }
}