import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:up_with_sally/ui/screens/timer_screen.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('Times');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myBox = Hive.box('Times');
  var times = "";

  String showAll() {
    var r = "";
    for (int i = 0; i < _myBox.values.length; i++) {
      r += '${_myBox.keyAt(i)} : ${_myBox.get(_myBox.keyAt(i))}\n';
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    times = showAll();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Up With Sally'),
        ),
        body: Container(
            child: Center(
          child: Column(
            children: [
              const Text('Welcome to Up With Sally'),
              const Text('Press the button to start the timer'),
              Text(times),
              ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          times = showAll();
                        })
                      },
                  child: const Text('Show All'))
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimerScreen()),
            );
            setState(() {
              times = showAll();
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}
