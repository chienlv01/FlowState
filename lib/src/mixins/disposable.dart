/// A mixin that provides dispose functionality
mixin Disposable {
  bool _isDisposed = false;
  
  /// Whether this object has been disposed
  bool get isDisposed => _isDisposed;

  /// Disposes of any resources
  void dispose() {
    if (!_isDisposed) {
      onDispose();
      _isDisposed = true;
    }
  }

  /// Called when dispose is called
  /// Override this to add custom dispose logic
  void onDispose() {}

  /// Throws if this object has been disposed
  void throwIfDisposed() {
    if (_isDisposed) {
      throw StateError('This object has been disposed');
    }
  }
}