/// Base exception class for state management errors
class StateException implements Exception {
  const StateException(this.message);
  final String message;

  @override
  String toString() => 'StateException: $message';
}

/// Thrown when trying to access a disposed resource
class DisposedStateException extends StateException {
  const DisposedStateException(String message) : super(message);
}

/// Thrown when a required provider is not found
class ProviderNotFoundException extends StateException {
  const ProviderNotFoundException(String message) : super(message);
}

/// Thrown when there's an error in state initialization
class StateInitializationException extends StateException {
  const StateInitializationException(String message) : super(message);
}