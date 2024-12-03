import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// A widget that rebuilds when the watched state changes
class StateBuilder<T> extends StatefulWidget {
  const StateBuilder({
    Key? key,
    required this.builder,
    this.onStateChanged,
  }) : super(key: key);

  final Widget Function(BuildContext context, T state) builder;
  final void Function(T)? onStateChanged;

  @override
  State<StateBuilder<T>> createState() => _StateBuilderState<T>();
}

class _StateBuilderState<T> extends State<StateBuilder<T>> {
  late T currentState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Watch for state changes
    currentState = Store.instance.watch<T>(
      context,
      (newState) {
        setState(() {
          currentState = newState;
        });
        widget.onStateChanged?.call(newState);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentState);
  }
}