import 'package:flutter/widgets.dart';
import '../core/store.dart';

/// A utility class for reading state without watching it
class StateReader {
  const StateReader._();

  /// Reads the current state without watching it
  static T read<T>(BuildContext context) {
    return Store.instance.read<T>(context);
  }

  /// Reads multiple states at once
  static List<dynamic> readMany(BuildContext context, List<Type> types) {
    return types.map((type) => Store.instance.read(context)).toList();
  }
}