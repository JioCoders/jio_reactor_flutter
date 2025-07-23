import 'package:flutter/material.dart';
import 'package:jio_reactor/src/reactor/reactive_ctx.dart';
import 'package:jio_reactor/src/reactor.dart';

/// The `Reactive` widget rebuilds when the state emitted by the stream changes.
class Reactive extends StatefulWidget {
  final Widget Function() builder;

  const Reactive({super.key, required this.builder});

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  final _reactors = <Reactor<dynamic>>{};

  void _track() {
    for (final reactor in _reactors) {
      reactor.removeListener(_onRebuild);
    }
    _reactors.clear();

    ReactiveContext.addListener(_onReactorUsed);
    final widgetTree = widget.builder();
    ReactiveContext.removeListener(_onReactorUsed);

    setState(() {
      _currentChild = widgetTree;
    });
  }

  late Widget _currentChild;

  void _onRebuild() => _track();

  void _onReactorUsed() {
    final reactor = ReactiveContext.stack.last as Reactor<dynamic>;
    _reactors.add(reactor);
    reactor.addListener(_onRebuild);
  }

  @override
  void initState() {
    super.initState();
    _track();
  }

  @override
  void dispose() {
    for (final reactor in _reactors) {
      reactor.removeListener(_onRebuild);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _currentChild;
}
