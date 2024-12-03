import 'package:flutter/widgets.dart';
import 'state_provider.dart';
import '../errors/exceptions.dart';

/// A central store that manages all providers
class Store {
  Store._();
  static final Store instance = Store._();

  // Changed from private to public to be accessible from StateContainer
  final Map<Type, StateProvider> providers = {};
  final Map<Type, dynamic> singletons = {};

  /// Registers a provider for a specific type
  void register<T>(StateProvider<T> provider) {
    if (providers.containsKey(T)) {
      throw StateException('Provider for type $T is already registered');
    }
    providers[T] = provider;
  }

  /// Gets a provider for a specific type
  StateProvider<T> provider<T>() {
    if (!providers.containsKey(T)) {
      throw StateException('No provider registered for type $T');
    }
    return providers[T] as StateProvider<T>;
  }

  /// Reads the current state for a specific type
  T read<T>(BuildContext context) {
    return provider<T>().read(context).state;
  }

  /// Watches state changes for a specific type
  T watch<T>(BuildContext context, [void Function(T)? onStateChanged]) {
    return provider<T>().watch(context, onStateChanged).state;
  }

  /// Registers a singleton instance
  void registerSingleton<T>(T instance) {
    singletons[T] = instance;
  }

  /// Gets a singleton instance
  T getSingleton<T>() {
    if (!singletons.containsKey(T)) {
      throw StateException('No singleton registered for type $T');
    }
    return singletons[T] as T;
  }

  /// Disposes all providers
  void dispose() {
    for (var provider in providers.values) {
      provider.dispose();
    }
    providers.clear();
    singletons.clear();
  }
}