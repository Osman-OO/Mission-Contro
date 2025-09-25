import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  //set counter value
  int _counter = 0;
  
  void _ignite() {
    setState(() {
      _counter = (_counter +1).clamp(0,100);
    });
  }

  void _decrement() {
    setState(() {
      _counter = (_counter -1).clamp(0,100);
    });
  }

  void _abort() {
    setState(() {
      _counter = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mission aborted!')),
    );
  }

  void _reset() {
    setState(() {
      _counter = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset to 0!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sky.jpg'),
          fit: BoxFit.cover,
          ),
        ),
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Rocket Launch Controller!!'),
        ),
        //set up the widget alignement
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical:20, horizontal: 23),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius :BorderRadius.circular(24),
                ),
                child: Text(
                  //to displays current number
                  '$_counter',
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),
            ElevatedButton(
              onPressed: () {
                // Action to be performed when the button is pressed
                print('Rocket Launched with power $_counter!');
              },
              child: const Text('Launch Rocket'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child:
                ElevatedButton(
                  onPressed: _ignite,
                  child: const Text('Ignite +'),
                ),
                ),
                const SizedBox(width: 20),
                Expanded(child:
                ElevatedButton(
                  onPressed: _decrement, 
                  child: const Text('Decrement -')
                ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child:
                ElevatedButton(
                  onPressed: _abort,
                  child: const Text('Abort'),
                ),
                ),
                const SizedBox(width: 20),
                Expanded(child:
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      )
    );
  }
}
