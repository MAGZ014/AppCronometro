import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.mode == WearMode.active ? Colors.white : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace FlutterLogo with Icon
            const Icon(
              Icons.timer,
              color: Colors.green, // Set icon color to green
            ),
            const SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.mode == WearMode.active
                      ? Color.fromARGB(
                          255, 23, 98, 0) // Dark green for active mode
                      : Color.fromARGB(
                          255, 1, 187, 29), // Light green for ambient mode
                ),
              ),
            ),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == WearMode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _status == "Start" ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(
                  255, 60, 188, 0), // Set background color for Reset button
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              if (_timer != null) {
                _timer.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(
                  255, 60, 188, 0), // Set background color for Reset button
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count++;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
