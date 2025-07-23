import 'package:flutter/widgets.dart';
import 'package:jio_reactor/src/reactor/rexcontroller.dart';

typedef RexBuilder<T extends RexController> = Widget Function(T controller);

class Rex<T extends RexController> extends StatefulWidget {
  final T Function() init;
  final RexBuilder<T> builder;

  const Rex({super.key, required this.init, required this.builder});

  @override
  State<Rex<T>> createState() => _RexState<T>();
}

class _RexState<T extends RexController> extends State<Rex<T>> {
  late final T _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.init();
    _controller.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.ready();
    });
  }

  @override
  void dispose() {
    _controller.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller);
  }
}
