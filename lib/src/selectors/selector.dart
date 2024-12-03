import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// A function that selects a specific part of the state
typedef Selector<T, R> = R Function(T state);

/// A widget that rebuilds only when selected state changes
class StateSelector<T, R> extends StatefulWidget {
  const StateSelector({
    Key? key,
    required this.selector,
    required this.builder,
    this.shouldRebuild,
  }) : super(key: key);

  final Selector<T, R> selector;
  final Widget Function(BuildContext context, R selectedState) builder;
  final bool Function(R previous, R current)? shouldRebuild;

  @override
  State<StateSelector<T, R>> createState() => _StateSelectorState<T, R>();
}

class _StateSelectorState<T, R> extends State<StateSelector<T, R>> {
  late R selectedState;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedState = widget.selector(Store.instance.read<T>(context));
    Store.instance.watch<T>(
      context,
      (newState) {
        final newSelectedState = widget.selector(newState);
        if (widget.shouldRebuild?.call(selectedState, newSelectedState) ?? 
            selectedState != newSelectedState) {
          setState(() {
            selectedState = newSelectedState;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, selectedState);
  }
}
