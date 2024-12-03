/// Signature for middleware functions
typedef Middleware<T> = void Function(
  T state,
  T? previousState,
  void Function(T) setState,
);

/// Manager for handling middleware chains
class MiddlewareManager<T> {
  final List<Middleware<T>> _middleware = [];
  
  /// Adds a middleware to the chain
  void use(Middleware<T> middleware) {
    _middleware.add(middleware);
  }
  
  /// Runs all middleware in the chain
  void apply(T state, T? previousState, void Function(T) setState) {
    for (final middleware in _middleware) {
      middleware(state, previousState, setState);
    }
  }
  
  /// Removes all middleware
  void clear() {
    _middleware.clear();
  }
}