/// Represents a value that can be in different asynchronous states
class AsyncValue<T> {
  const AsyncValue.data(this._data) 
      : _status = AsyncStatus.data,
        _error = null;
        
  const AsyncValue.loading() 
      : _status = AsyncStatus.loading,
        _data = null,
        _error = null;
        
  const AsyncValue.error(this._error) 
      : _status = AsyncStatus.error,
        _data = null;

  final AsyncStatus _status;
  final T? _data;
  final Object? _error;

  bool get isLoading => _status == AsyncStatus.loading;
  bool get hasData => _status == AsyncStatus.data;
  bool get hasError => _status == AsyncStatus.error;

  T? get data => _data;
  Object? get error => _error;

  /// Maps the value to a new type
  AsyncValue<R> map<R>(R Function(T) mapper) {
    switch (_status) {
      case AsyncStatus.data:
        return AsyncValue.data(mapper(_data as T));
      case AsyncStatus.loading:
        return AsyncValue.loading();
      case AsyncStatus.error:
        return AsyncValue.error(_error!);
    }
  }

  /// When pattern matching on this value
  R when<R>({
    required R Function(T) data,
    required R Function() loading,
    required R Function(Object) error,
  }) {
    switch (_status) {
      case AsyncStatus.data:
        return data(_data as T);
      case AsyncStatus.loading:
        return loading();
      case AsyncStatus.error:
        return error(_error!);
    }
  }
}

enum AsyncStatus { data, loading, error }