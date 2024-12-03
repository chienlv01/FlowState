import 'dart:async';

/// A mixin that provides observable functionality
mixin Observable<T> {
  final _controller = StreamController<T>.broadcast();
  
  /// Stream of value changes
  Stream<T> get stream => _controller.stream;

  /// Current value
  T? _value;
  T? get value => _value;

  /// Updates the value and notifies listeners
  void setValue(T newValue) {
    if (newValue != _value) {
      _value = newValue;
      _controller.add(newValue);
    }
  }

  /// Closes the stream controller
  void dispose() {
    _controller.close();
  }

  /// Adds a listener to value changes
  StreamSubscription<T> addListener(void Function(T) listener) {
    return stream.listen(listener);
  }
}