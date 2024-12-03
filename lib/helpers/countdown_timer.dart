import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onTimerComplete;

  const CountdownTimer({
    Key? key,
    required this.initialSeconds,
    required this.onTimerComplete,
  }) : super(key: key);

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  /// Start the timer
  void _startTimer() {
    _stopTimer(); // Ensure only one timer is running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
        widget.onTimerComplete();
      }
    });
  }

  /// Stop the timer
  void _stopTimer() {
    _timer?.cancel();
  }

  /// Reset the timer to the initial state
  void resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = widget.initialSeconds;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _formatTime(_remainingSeconds),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Format time as MM:SS
  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
