import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// Base class to manage reactive state using RxDart
abstract class RexController<T> {
  final BehaviorSubject<T> _stateSubject;
  bool _isInitialized = false;

  // Constructor initializes the controller with an initial state
  RexController(T initialState)
      : _stateSubject = BehaviorSubject<T>.seeded(initialState);

  // The stream that emits the state changes
  Stream<T> get stateStream => _stateSubject.stream;

  // The current value of the state
  T get state => _stateSubject.value;

  // Sink to add new state values
  Sink<T> get stateSink => _stateSubject.sink;

  // Update the state
  void updateState(T newState) {
    stateSink.add(newState);
  }

  /// Lifecycle: Called once when controller is first created
  @mustCallSuper
  void onInit() {}

  /// Lifecycle: Called when UI is ready (optional)
  @mustCallSuper
  void onReady() {}

  /// Lifecycle: Called when the controller is destroyed
  @mustCallSuper
  void onDispose() {
    // Dispose the subject to avoid memory leaks  
    _stateSubject.close();
  }
  
  /// Call this when initializing the controller
  void init() {
    if (!_isInitialized) {
      _isInitialized = true;
      onInit();
    }
  }

  /// Call this after build is complete
  void ready() => onReady();

  /// Clean up
  void disposeController() {
    if (_isInitialized) {
      onDispose();
      _isInitialized = false;
    }
  }
}
