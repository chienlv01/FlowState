import '../errors/exceptions.dart';

/// A simple dependency injection container
class DependencyContainer {
  DependencyContainer._();
  static final DependencyContainer instance = DependencyContainer._();

  final _factories = <Type, Function>{};
  final _singletons = <Type, dynamic>{};

  /// Registers a factory function for a type
  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// Registers a singleton instance
  void registerSingleton<T>(T instance) {
    _singletons[T] = instance;
  }

  /// Gets an instance of a type
  T get<T>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }

    throw StateException('No registration found for type $T');
  }

  /// Clears all registrations
  void clear() {
    _factories.clear();
    _singletons.clear();
  }

  /// Checks if a type is registered
  bool isRegistered<T>() {
    return _factories.containsKey(T) || _singletons.containsKey(T);
  }
}