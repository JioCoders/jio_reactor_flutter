import 'package:flutter/material.dart';
import 'package:jio_reactor/jio_reactor.dart' show Reactive, RexController;

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
      home: const ReactiveCounterView(),
    );
  }
}

class ReactiveCounterView extends StatelessWidget {
  const ReactiveCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Bind the CounterController using `RexController` or directly
    final CounterController counterController = CounterController();

    return Scaffold(
      appBar: AppBar(title: Text('Reactive Counter')),
      body: Center(
        // Use `Reactive` widget to rebuild when the counter value changes
        child: Reactive<int>(
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

class CounterController extends RexController<int> {
  CounterController() : super(0); // Initialize with a counter of 0

  // Increment the counter value
  void increment() {
    updateState(state + 5);
  }

  // Decrement the counter value
  void decrement() {
    updateState(state - 5);
  }
}
