import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration _elapsedTime = const Duration(seconds: 5);
  bool _isGettingReady = true;
  bool _isRunning = false;
  bool _hasStarted = false;

  void _startRun() {
    setState(() {
      _isRunning = false;
      _hasStarted = false;
      _isGettingReady = true;
    });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_hasStarted == false) {
        setState(() {
          _hasStarted = true;
          _elapsedTime = const Duration(seconds: 5);
        });
      }
      if (_elapsedTime.inSeconds == 0) {
        setState(() {
          _isGettingReady = false;
          _isRunning = true;
        });
      }
      if (_isGettingReady) {
        setState(() {
          _elapsedTime = _elapsedTime - const Duration(seconds: 1);
        });
      } else if (_isRunning) {
        setState(() {
          _elapsedTime = _elapsedTime + const Duration(seconds: 1);
        });
      }
    });
  }

  void _stopRun() {
    setState(() {
      _isRunning = false;
      _hasStarted = false;
      _isGettingReady = false;
    });
    timer?.cancel();
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '${_elapsedTime.inMinutes.toString().padLeft(2, '0')}:${(_elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        _isGettingReady && _hasStarted
            ? const SizedBox()
            : ElevatedButton(
                onPressed: !_isRunning ? _startRun : _stopRun,
                child: Text(!_isRunning ? 'Start' : 'Stop'),
              ),
      ],
    );
  }
}
