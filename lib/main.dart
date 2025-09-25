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

  // Function to get text color based on counter value (Objective 3)
  Color _getCounterTextColor() {
    if (_counter == 0) {
      return Colors.red;
    } else if (_counter > 50) {
      return Colors.green;
    } else {
      return Colors.orange; // For values between 1 and 50
    }
  }

  // Function to show launch success popup (Bonus objective)
  void _showLaunchSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '🚀 LAUNCH SUCCESS! 🚀',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.rocket_launch,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations, Mission Control!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your rocket has successfully launched into space! 🌌',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✨ Mission Accomplished ✨',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reset(); // Reset the mission for another launch
              },
              child: const Text(
                'Start New Mission',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
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
                  child: Column(
                    children: [
                      Text(
                        //to displays current number with color based on value (Objective 3)
                        '$_counter',
                        style: TextStyle(
                          fontSize: 50.0,
                          color: _getCounterTextColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Show LIFTOFF message when counter reaches 100 (Objective 4)
                      if (_counter == 100)
                        const Text(
                          'LIFTOFF!',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                    ],
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
                      // Show success popup after a short delay to let animation start
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _showLaunchSuccessPopup();
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
