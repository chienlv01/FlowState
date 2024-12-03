
import 'package:flutter/widgets.dart';

enum LogLevel { debug, info, warning, error }

class DebugLogger {
  static bool _enabled = false;
  static LogLevel _minLevel = LogLevel.info;
  
  static void enable() => _enabled = true;
  static void disable() => _enabled = false;
  
  static set minLevel(LogLevel level) => _minLevel = level;
  
  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (!_enabled || level.index < _minLevel.index) return;
    
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp][${level.name}] $message');
  }

  static void logStateChange<T>(T oldState, T newState) {
    log(
      'State changed:\nFrom: $oldState\nTo: $newState',
      level: LogLevel.debug,
    );
  }
}