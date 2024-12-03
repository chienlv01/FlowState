
import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// Base class for state hooks
abstract class StateHook<T> {
  void onInit(BuildContext context, T initialState) {}
  void onStateChanged(BuildContext context, T previousState, T newState) {}
  void onDispose(BuildContext context, T finalState) {}
}

/// Mixin to add hook support to state widgets
mixin StateHooksMixin<T> on State<StatefulWidget> {
  final List<StateHook<T>> _hooks = [];
  T? _previousState;
  late T _currentState;

  void addHook(StateHook<T> hook) {
    _hooks.add(hook);
  }

  void removeHook(StateHook<T> hook) {
    _hooks.remove(hook);
  }

  @override
  void initState() {
    super.initState();
    _currentState = Store.instance.read<T>(context);
    for (final hook in _hooks) {
      hook.onInit(context, _currentState);
    }
  }

  void _notifyHooks(T newState) {
    if (_previousState != newState) {
      for (final hook in _hooks) {
        hook.onStateChanged(context, _previousState!, newState);
      }
      _previousState = newState;
    }
  }

  @override
  void dispose() {
    for (final hook in _hooks) {
      hook.onDispose(context, _currentState);
    }
    _hooks.clear();
    super.dispose();
  }
}
