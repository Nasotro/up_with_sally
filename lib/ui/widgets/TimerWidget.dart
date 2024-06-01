import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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

  final _bringSallyPath = 'Bring_Sally_Up.mp3';
  final _tickPath = 'tick.mp3';
  final _musicPlayer = AudioPlayer();
  final _tickPlayer = AudioPlayer();

  var times_to_tick = [30, 60, 90];

  void _startMusic() {
    _musicPlayer.play(AssetSource(_bringSallyPath));
  }

  void _stopMusic() {
    _musicPlayer.stop();
  }

  void _playTick() {
    if (_tickPlayer.state == PlayerState.playing) {
      _tickPlayer.stop();
    }
    _tickPlayer.play(AssetSource(_tickPath));
  }

  void _setTime(int secs) {
    setState(() {
      _elapsedTime = Duration(seconds: secs);
    });
  }

  Future<void> _startDecompte() async {
    await _tickPlayer.setReleaseMode(ReleaseMode.stop);
    await _musicPlayer.setReleaseMode(ReleaseMode.stop);
    _setTime(4);
    _playTick();
    setState(() {
      _isRunning = false;
      _hasStarted = true;
      _isGettingReady = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedTime.inSeconds == 0) {
        setState(() {
          _isGettingReady = false;
          _isRunning = true;
        });
        _startMusic();
      }
      if (_isGettingReady) {
        _playTick();
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
    _stopMusic();
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
                onPressed: !_isRunning ? _startDecompte : _stopRun,
                child: Text(!_isRunning ? 'Start' : 'Stop'),
              ),
      ],
    );
  }
}
