import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  AtKey MyAtkey = AtKey()..key = 'distance';
  int _counter = 0;

  @override
  void initState() {
    getcount();
    super.initState();
  }

  Future<int?> getcount() async {
    AtClientManager atClientManager = AtClientManager.getInstance();
    var atClient = atClientManager.atClient;
    AtValue val = await atClient.get(MyAtkey);
    setState(() {
      _counter = val.value;
    });
    return _counter;
  }

  @override
  Widget build(BuildContext context) {
    AtClientManager atClientManager = AtClientManager.getInstance();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'distance: ',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text(
              'cm',
            ),
            if (_counter < 5)
              const Text("🚨 distance is less than 5cm, stop the robot!"),
          ],
        ),
      ),
    );
  }
}
