import 'package:flutter/material.dart';

/// The `Reactive` widget rebuilds when the state emitted by the stream changes.
class Reactive<T> extends StatelessWidget {
  final Stream<T> stream; // Stream to listen to
  final Widget Function(BuildContext, T) builder; // Builder function

  const Reactive({super.key, required this.stream, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading while waiting
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error handling
        }
        return builder(
          context,
          snapshot.data as T,
        ); // Rebuild widget when state changes
      },
    );
  }
}
