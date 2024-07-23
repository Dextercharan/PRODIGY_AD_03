import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopwatchHomePage(),
    );
  }
}

class StopwatchHomePage extends StatefulWidget {
  @override
  _StopwatchHomePageState createState() => _StopwatchHomePageState();
}

class _StopwatchHomePageState extends State<StopwatchHomePage> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> _laps = [];

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
  }

  void _startStopwatch() {
    _stopwatch.start();
    _startTimer();
  }

  void _pauseStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {
      _laps.clear();
    });
  }

  void _markLap() {
    setState(() {
      _laps.add(_formatTime(_stopwatch.elapsedMilliseconds));
    });
  }

  String _formatTime(int milliseconds) {
    int minutes = (milliseconds / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    int milliSeconds = (milliseconds % 1000) ~/ 10;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}:'
        '${milliSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff4682b4),
        title: Text('Stopwatch',
        style: TextStyle(
          fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: Colors.white
        ),),
      ),
      backgroundColor: Color(0xff4682b4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formatTime(_stopwatch.elapsedMilliseconds),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _stopwatch.isRunning ? _pauseStopwatch : _startStopwatch,
                  child: Text(_stopwatch.isRunning ? 'Pause' : 'Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _stopwatch.isRunning ? _markLap : null,
                  child: Text('Lap'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Lap ${index + 1}'),
                    trailing: Text(_laps[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
