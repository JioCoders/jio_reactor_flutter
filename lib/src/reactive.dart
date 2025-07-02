// `obs` marks a variable as reactive.
import 'package:jio_reactor/src/reactive.dart' as reactive show obs;

T obs<T>(T value) {
  return reactive.obs(value);
}
