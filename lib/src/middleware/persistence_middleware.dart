import 'dart:convert';
import 'package:flutter/foundation.dart';

typedef PersistenceStorage = Future<void> Function(String key, String data);
typedef PersistenceLoader = Future<String?> Function(String key);

class PersistenceMiddleware<T> {
  final String key;
  final PersistenceStorage saveState;
  final PersistenceLoader loadState;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  PersistenceMiddleware({
    required this.key,
    required this.saveState,
    required this.loadState,
    required this.fromJson,
    required this.toJson,
  });

  void create() => (T state, T? previousState, void Function(T) setState) {
    if (previousState != state) {
      saveState(key, jsonEncode(toJson(state)));
    }
  };

  Future<T?> loadPersistedState() async {
    final data = await loadState(key);
    if (data != null) {
      try {
        return fromJson(jsonDecode(data));
      } catch (e) {
        debugPrint('Error loading persisted state: $e');
        return null;
      }
    }
    return null;
  }
}