// `reactor` marks a variable as reactive.
import 'package:jio_reactor/src/reactor.dart' as reaction show reactor;

T reactor<T>(T value) {
  return reaction.reactor(value);
}
