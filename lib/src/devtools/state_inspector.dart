import '../core/state_notifier.dart';

class StateInspector<T> {
  final StateNotifier<T> notifier;
  final List<StateSnapshot<T>> _history = [];
  final int maxHistoryLength;

  StateInspector(this.notifier, {this.maxHistoryLength = 50}) {
    notifier.addListener(_recordState);
  }

  void _recordState(T state) {
    _history.add(StateSnapshot(
      state: state,
      timestamp: DateTime.now(),
    ));
    
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
    }
  }

  List<StateSnapshot<T>> get history => List.unmodifiable(_history);

  StateSnapshot<T>? getStateAt(DateTime timestamp) {
    return _history.firstWhere(
      (snapshot) => snapshot.timestamp.isAtSameMomentAs(timestamp),
      orElse: () => _history.first,
    );
  }

  void clearHistory() {
    _history.clear();
  }
}

class StateSnapshot<T> {
  final T state;
  final DateTime timestamp;

  StateSnapshot({required this.state, required this.timestamp});
}