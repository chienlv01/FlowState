import 'package:flutter/widgets.dart';
import 'store.dart';
import 'state_provider.dart';

/// A widget that provides state management capabilities to its subtree
class StateContainer extends StatefulWidget {
  const StateContainer({
    Key? key,
    required this.child,
    this.providers = const [],
  }) : super(key: key);

  final Widget child;
  final List<StateProvider> providers;

  @override
  State<StateContainer> createState() => _StateContainerState();

  /// Gets the nearest [Store] instance
  static Store of(BuildContext context) {
    final scope = context.findAncestorStateOfType<_StateContainerState>();
    if (scope == null) {
      throw FlutterError(
        'StateContainer.of() called with a context that does not contain a StateContainer.\n'
        'No StateContainer ancestor could be found starting from the context that was passed '
        'to StateContainer.of(). This usually happens when the context provided is from the '
        'same StatefulWidget as that whose build function actually creates the StateContainer widget.\n'
        'The context used was:\n'
        '  $context',
      );
    }
    return scope.store;
  }
}

class _StateContainerState extends State<StateContainer> {
  late final Store store;

  @override
  void initState() {
    super.initState();
    store = Store.instance;
    
    // Register all provided providers
    for (var provider in widget.providers) {
      // Using public providers map
      store.providers[provider.runtimeType] = provider;
    }
  }

  @override
  void dispose() {
    // Clean up providers that were registered by this container
    for (var provider in widget.providers) {
      // Using public providers map
      store.providers.remove(provider.runtimeType);
      provider.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}