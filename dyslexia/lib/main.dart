import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Removed const to avoid hot reload issue
}

class MyApp extends StatelessWidget {
  // Removed const to prevent hot reload errors
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: appPrimaryColor,
        scaffoldBackgroundColor: appBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appPrimaryColor,
          foregroundColor: Colors.white, // Ensuring contrast
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: appTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: appTextColor, fontSize: 18),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: appSecondaryColor,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: appPrimaryColor),
      ),
      home: MyHomePage(), // Removed const
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key}); // Removed const

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(appBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                style: TextStyle(color: appTextColor, fontSize: 18),
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
