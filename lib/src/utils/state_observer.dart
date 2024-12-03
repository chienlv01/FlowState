import '../core/state_notifier.dart';

/// A class that observes state changes
class StateObserver<T> {
  StateObserver(this._notifier) {
    _subscription = _notifier.addListener(_onStateChanged);
  }

  final StateNotifier<T> _notifier;
  final _listeners = <void Function(T previous, T current)>[];
  late final _subscription;
  T? _previousState;

  /// Adds a listener that receives both previous and current state
  void addListener(void Function(T previous, T current) listener) {
    _listeners.add(listener);
  }

  /// Removes a listener
  void removeListener(void Function(T previous, T current) listener) {
    _listeners.remove(listener);
  }

  void _onStateChanged(T newState) {
    final previousState = _previousState;
    if (previousState != null) {
      for (final listener in _listeners) {
        listener(previousState, newState);
      }
    }
    _previousState = newState;
  }

  /// Disposes the observer
  void dispose() {
    _subscription.cancel();
    _listeners.clear();
  }
}