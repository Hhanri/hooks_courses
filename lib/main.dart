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

const String url = "https://bit.ly/3x7J5Qt";
const double imageHeihgt = 300;

extension Normalize on num {
  num normalized(num selfRangeMin, num selfRangeMax, [num normalizedRangeMin = 0, num normalizedRangeMax = 1]){
    return (normalizedRangeMax - normalizedRangeMin) * ((this - selfRangeMin) / (selfRangeMax - selfRangeMin)) + normalizedRangeMin;
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController(
      duration: const Duration(seconds: 1),
      initialValue: 1,
      upperBound: 1,
      lowerBound: 0
    );
    final size = useAnimationController(
        duration: const Duration(seconds: 1),
        initialValue: 1,
        upperBound: 1,
        lowerBound: 0
    );
    final scrollController = useScrollController();
    useEffect(() {
     scrollController.addListener(() {
       final newOpacity = max(imageHeihgt - scrollController.offset, 0.0);
       final normalized = newOpacity.normalized(0, imageHeihgt).toDouble();
       opacity.value = normalized;
       size.value = normalized;
     });
    }, [scrollController]);

    return Scaffold(
      body: Column(
        children: [
          SizeTransition(
            sizeFactor: size,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: FadeTransition(
              opacity: opacity,
              child: Image.network(
                url,
                height: imageHeihgt,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text("Person ${index+1}"));
              },

            ),
          )
        ],
      ),
    );
  }
}
