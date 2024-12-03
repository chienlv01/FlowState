
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:state_management/src/selectors/selector.dart';
import 'package:state_management/state_management.dart';

class MultiStateSelector extends StatefulWidget {
  const MultiStateSelector({
    super.key,
    required this.selectors,
    required this.builder,
    this.shouldRebuild,
  });

  final List<Selector> selectors;
  final Widget Function(BuildContext context, List<dynamic> selectedStates) builder;
  final bool Function(List<dynamic> previous, List<dynamic> current)? shouldRebuild;

  @override
  State<MultiStateSelector> createState() => _MultiStateSelectorState();
}

class _MultiStateSelectorState extends State<MultiStateSelector> {
  late List<dynamic> selectedStates;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateSelectedStates();
  }

  void updateSelectedStates() {
    final newStates = widget.selectors
        .map((selector) => selector(Store.instance))
        .toList();

    if (widget.shouldRebuild?.call(selectedStates, newStates) ??
        !listEquals(selectedStates, newStates)) {
      setState(() {
        selectedStates = newStates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, selectedStates);
  }
}