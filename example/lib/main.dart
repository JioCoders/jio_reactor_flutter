import 'package:example/bloc_test.dart';
import 'package:example/src/provider/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:jio_reactor/jio_reactor.dart' show Reactive, RexController;

void main() {
  runApp(const MyBlocApp());
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
      home: UserListScreen(),
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
      appBar: AppBar(title: Text('Reactive Counterr')),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: counterController.decrement,
            child: Icon(Icons.arrow_left_outlined),
          ),
          FloatingActionButton(
            onPressed: counterController.increment,
            child: Icon(Icons.arrow_right_outlined),
          ),
        ],
      ),
      body: Center(
        // Use `Reactive` widget to rebuild when the counter value changes
        child: Reactive(
          builder: () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Counter: ${counterController.state}',
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 10),
                Text(
                  'Demo app to increase/ decrease \nthe counter value',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
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
  CounterController() : super(0);

  void increment() => updateState(state + 1);
  void decrement() => updateState(state - 1);

  @override
  void onInit() {
    super.onInit();
    debugPrint('CounterController: onInit');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('CounterController: onReady');
  }

  @override
  void onDispose() {
    debugPrint('CounterController: onDispose');
    super.onDispose();
  }
}
