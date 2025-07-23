import 'package:jio_reactor/src/reactor.dart';

extension ReactorExtension<T> on T {
  Reactor<T> get reactor => Reactor<T>(this);
}