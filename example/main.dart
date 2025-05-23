import 'package:flutter/material.dart';
import 'package:flutter_build_tracker/flutter_build_tracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build Tracker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Build Tracker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final BuildTrackerController _controller = BuildTrackerController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Wrap the counter display with BuildTracker
            BuildTracker(
              name: 'CounterDisplay',
              maxRebuilds: 5,
              showOverlay: true,
              logToConsole: true,
              controller: _controller,
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            // Another widget with BuildTracker
            BuildTracker(
              name: 'InfoCard',
              maxRebuilds: 3,
              overlayAlignment: Alignment.topLeft,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('This card rebuilds with the counter'),
                      Text('Current value: $_counter'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Print all build statistics
                final stats = _controller.allStats;
                for (final entry in stats.entries) {
                  print('Stats for ${entry.key}: ${entry.value}');
                }
              },
              child: const Text('Print All Build Stats'),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset all build counts
                _controller.resetAll();
              },
              child: const Text('Reset All Build Counts'),
            ),
          ],
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
