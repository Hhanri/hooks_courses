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

Stream<String> getTime() => Stream.periodic(
  const Duration(seconds: 1),
  (_) => DateTime.now().toIso8601String()
);

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState('');
    useEffect(() {
      controller.addListener(() {
        text.value = controller.text;
      });
    }, [controller]);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text.value),
          TextField(
            controller: controller,
          )
        ],
      ),
    );
  }
}
