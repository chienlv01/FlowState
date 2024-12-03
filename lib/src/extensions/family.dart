import '../core/state_provider.dart';

/// A mixin that allows creating families of providers based on parameters
mixin Family<T, P> {
  final _cache = <P, StateProvider<T>>{};

  /// Creates a provider for a specific parameter
  StateProvider<T> call(P param) {
    return _cache.putIfAbsent(param, () => _create(param));
  }

  /// Creates a new provider for the given parameter
  StateProvider<T> _create(P param);

  /// Removes a provider for a specific parameter
  void remove(P param) {
    final provider = _cache.remove(param);
    provider?.dispose();
  }

  /// Clears all providers
  void clear() {
    for (final provider in _cache.values) {
      provider.dispose();
    }
    _cache.clear();
  }
}