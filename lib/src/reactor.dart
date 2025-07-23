// `reactor` marks a variable as reactive.
// import 'package:jio_reactor/src/reactor.dart' as reaction show reactor;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jio_reactor/src/reactor/reactive_ctx.dart';

class Reactor<T> {
  T _value;
  final _controller = StreamController<T>.broadcast();
  final _listeners = <VoidCallback>{};

  Reactor(this._value);

  T get value {
    // Track access
    ReactiveContext.notifyDependency(this);
    return _value;
  }

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _controller.add(_value);
      for (var listener in _listeners) {
        listener();
      }
    }
  }

  Stream<T> get stream => _controller.stream;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
    _controller.close();
  }
}
