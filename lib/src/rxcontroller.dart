import 'dart:async';
import 'package:rxdart/rxdart.dart';

/// Base class to manage reactive state using RxDart
abstract class RxStateController<T> {
  final BehaviorSubject<T> _stateSubject;

  // The stream that emits the state changes
  Stream<T> get stateStream => _stateSubject.stream;

  // The current value of the state
  T get state => _stateSubject.value;

  // Sink to add new state values
  Sink<T> get stateSink => _stateSubject.sink;

  // Constructor initializes the controller with an initial state
  RxStateController(T initialState) : _stateSubject = BehaviorSubject<T>.seeded(initialState);

  // Update the state
  void updateState(T newState) {
    stateSink.add(newState);
  }

  // Dispose the subject to avoid memory leaks
  void dispose() {
    _stateSubject.close();
  }
}
