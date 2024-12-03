import 'package:flutter/widgets.dart';
import 'state_notifier.dart';

/// A provider that creates and manages a [StateNotifier]
class StateProvider<T> {
  /// Creates a [StateProvider] with a builder function
  StateProvider(T Function() create) : _create = create;

  final T Function() _create;
  StateNotifier<T>? _notifier;
  final _dependents = <BuildContext, void Function(T)>{};

  /// Gets the current state notifier, creating it if necessary
  StateNotifier<T> read(BuildContext context) {
    _notifier ??= StateNotifier<T>(_create());
    return _notifier!;
  }

  /// Watches state changes and rebuilds when the state changes
  StateNotifier<T> watch(BuildContext context, [void Function(T)? onStateChanged]) {
    final notifier = read(context);
    
    if (onStateChanged != null) {
      _dependents[context] = onStateChanged;
      
      // Add listener if this is a new dependent
      notifier.addListener((state) {
        if (_dependents.containsKey(context)) {
          onStateChanged(state);
        }
      });
    }

    return notifier;
  }

  /// Removes a dependent context
  void _removeDependent(BuildContext context) {
    _dependents.remove(context);
    
    // Dispose notifier if there are no more dependents
    if (_dependents.isEmpty) {
      _notifier?.dispose();
      _notifier = null;
    }
  }

  /// Disposes the provider and its notifier
  void dispose() {
    _notifier?.dispose();
    _notifier = null;
    _dependents.clear();
  }
}