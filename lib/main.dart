import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible
}

@immutable
class State {
  final double rotationDeg;
  final double alpha;
  const State({required this.rotationDeg, required this.alpha});

  const State.zero(): rotationDeg = 0.0, alpha = 1.0;

  State rotateRight() => State(rotationDeg: rotationDeg + 10, alpha: alpha);
  State rotateLeft() => State(rotationDeg: rotationDeg - 10, alpha: alpha);
  State increaseAlpha() => State(rotationDeg: rotationDeg, alpha: min(alpha + 0.1, 1));
  State decreaseAlpha() => State(rotationDeg: rotationDeg, alpha: max(alpha - 0.1, 0));
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

const String url = "https://bit.ly/3x7J5Qt";

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null
    );
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateLeft);
                },
                child: const Text("rotate left")
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateRight);
                },
                child: const Text("rotate right")
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.moreVisible);
                },
                child: const Text("increase alpha")
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.lessVisible);
                },
                child: const Text("decrease alpha")
              ),
            ],
          ),
          const SizedBox(height: 100,),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDeg/360),
              child: Image.network(url)
            ),
          ),
        ],
      ),
    );
  }
}
