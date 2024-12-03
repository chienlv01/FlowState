void loggerMiddleware<T>(T state, T? previousState, void Function(T) setState) {
  print('Previous State: $previousState');
  print('Current State: $state');
  print('State Type: ${T.toString()}');
  print('-------------------');
}