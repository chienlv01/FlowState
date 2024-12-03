
class PerformanceMonitor {
  final _updates = <String, List<Duration>>{};
  final _updateTimes = <String, DateTime>{};
  
  void trackUpdate(String stateId) {
    final now = DateTime.now();
    if (_updateTimes.containsKey(stateId)) {
      final duration = now.difference(_updateTimes[stateId]!);
      _updates[stateId] ??= [];
      _updates[stateId]!.add(duration);
    }
    _updateTimes[stateId] = now;
  }

  Map<String, Duration> getAverageUpdateTimes() {
    return _updates.map((key, durations) {
      final total = durations.fold<Duration>(
        Duration.zero,
        (prev, curr) => prev + curr,
      );
      return MapEntry(key, total ~/ durations.length);
    });
  }

  void clearMetrics() {
    _updates.clear();
    _updateTimes.clear();
  }
}