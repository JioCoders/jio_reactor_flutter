import 'package:jio_reactor/jio_reactor.dart';

typedef ReactiveListener = void Function();

class ReactiveContext {
  static final stack = <ReactiveListener>[];

  static void addListener(ReactiveListener listener) {
    stack.add(listener);
  }

  static void removeListener(ReactiveListener listener) {
    stack.remove(listener);
  }

  static void notifyDependency(Reactor<dynamic> reactor) {
    for (final listener in stack) {
      reactor.addListener(listener);
    }
  }
}