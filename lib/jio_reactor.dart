library;

// Register Reactor Globally (like Get.put / Get.find)
// You could add a simple service locator later if needed.
// Generating example and test files
// Adding dependency injection (like Get.put / Get.find)

// final count = 0.reactor;
// Reactive<int>(
//   reactor: count,
//   builder: (_, value) => Text('Value: $value'),
// )
// class CounterWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Reactive<int>(
//           reactor: count,
//           builder: (_, value) => Text('Value: $value'),
//         ),
//         ElevatedButton(
//           onPressed: () => count.value++,
//           child: Text('Increment'),
//         ),
//       ],
//     );
//   }
// }

export 'package:jio_reactor/src/reactor.dart';
export 'package:jio_reactor/src/reactor/reactive.dart';
export 'package:jio_reactor/src/reactor/rexcontroller.dart';
