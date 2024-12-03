import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// A widget that listens to state changes without rebuilding
class StateListener<T> extends StatefulWidget {
  const StateListener({
    Key? key,
    required this.child,
    required this.listener,
  }) : super(key: key);

  final Widget child;
  final void Function(BuildContext context, T state) listener;

  @override
  State<StateListener<T>> createState() => _StateListenerState<T>();
}

class _StateListenerState<T> extends State<StateListener<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Store.instance.watch<T>(
      context,
      (newState) => widget.listener(context, newState),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}