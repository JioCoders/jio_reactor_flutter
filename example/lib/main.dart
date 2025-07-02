import 'package:flutter/material.dart';
import 'package:jio_reactor/jio_reactor.dart' show Obx, RxStateController;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ObxCounterView(),
    );
  }
}

class ObxCounterView extends StatelessWidget {
  const ObxCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Bind the CounterController using `RxStateBinding` or directly
    final CounterController counterController = CounterController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reactive Counter with RxDart'),
      ),
      body: Center(
        // Use `Obx` widget to rebuild when the counter value changes
        child: Obx<int>(
          stream: counterController.stateStream,
          builder: (context, counter) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Counter: $counter', style: TextStyle(fontSize: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: counterController.increment,
                      child: Text('Increment'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: counterController.decrement,
                      child: Text('Decrement'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CounterController extends RxStateController<int> {
  CounterController() : super(0); // Initialize with a counter of 0

  // Increment the counter value
  void increment() {
    updateState(state + 1);
  }

  // Decrement the counter value
  void decrement() {
    updateState(state - 1);
  }
}
