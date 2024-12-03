import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// A widget that combines both builder and listener functionality
class StateConsumer<T> extends StatefulWidget {
  const StateConsumer({
    Key? key,
    required this.builder,
    required this.listener,
  }) : super(key: key);

  final Widget Function(BuildContext context, T state) builder;
  final void Function(BuildContext context, T state) listener;

  @override
  State<StateConsumer<T>> createState() => _StateConsumerState<T>();
}

class _StateConsumerState<T> extends State<StateConsumer<T>> {
  late T currentState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentState = Store.instance.watch<T>(
      context,
      (newState) {
        setState(() {
          currentState = newState;
        });
        widget.listener(context, newState);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentState);
  }
}