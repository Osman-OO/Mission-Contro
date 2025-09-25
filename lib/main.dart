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
  bool _launched = false;
  final double _rocketHeight = 140.0;
  final double _rocketBottom = 20.0;

  void _ignite() {
    setState(() {
      _counter = (_counter + 1).clamp(0, 100);
    });
  }

  void _decrement() {
    setState(() {
      _counter = (_counter - 1).clamp(0, 100);
    });
  }

  void _abort() {
    setState(() {
      _counter = 0;
      _launched = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mission aborted!')),
    );
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _launched = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset to 0!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final double _offscreenDy = -(screenH / _rocketHeight + 0.6);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sky.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Rocket Launch Controller!!'),
        ),
        //set up the widget alignement
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 23),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    //to displays current number
                    '$_counter',
                    style: TextStyle(fontSize: 50.0),
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
                    if (_counter == 100) {
                      setState(() {
                        _launched = true; // start the animation
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Fuel to 100 to launch!')),
                      );
                    }
                    // Action to be performed when the button is pressed
                    print('Rocket Launched with power $_counter!');
                  },
                  child: const Text('Launch Rocket'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _ignite,
                        child: const Text('Ignite +'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _decrement,
                        child: const Text('Extinguish -'),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _abort,
                        child: const Text('Abort'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _reset,
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: _rocketBottom,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedSlide(
                  offset: _launched ? Offset(0, _offscreenDy) : Offset.zero, // slide up off-screen
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeIn,
                  child: Image.asset(
                    'assets/rocket.png',
                    height: _rocketHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
