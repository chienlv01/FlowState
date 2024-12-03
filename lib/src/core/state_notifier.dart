import 'dart:async';
import 'package:state_management/state_management.dart';

import '../mixins/disposable.dart';
import '../errors/exceptions.dart';
import '../middleware/middleware.dart';

class StateNotifier<T> with Disposable {
StateNotifier(T initialState) : _state = initialState {
  _controller = StreamController<T>.broadcast();
  _middlewareManager = MiddlewareManager<T>();
  

  addMiddleware(loggerMiddleware);
}

  late final StreamController<T> _controller;
  late final MiddlewareManager<T> _middlewareManager;
  T _state;
  bool _disposed = false;
  T? _previousState;

  T get state => _state;
  Stream<T> get stream => _controller.stream;

  void addMiddleware(Middleware<T> middleware) {
    _middlewareManager.use(middleware);
  }

  void setState(T newState) {
    if (_disposed) {
      throw StateException('Cannot update state after disposal');
    }
    
    if (newState != _state) {
      _previousState = _state;
      _state = newState;
      _middlewareManager.apply(_state, _previousState, setState);
      _controller.add(_state);
    }
  }

  void update(T Function(T currentState) updater) {
    setState(updater(state));
  }

  @override
  void dispose() {
    if (!_disposed) {
      _controller.close();
      _disposed = true;
      _middlewareManager.clear();
    }
  }

  StreamSubscription<T> addListener(void Function(T) listener) {
    return stream.listen(listener);
  }
}