import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  Timer? timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;

  void startTimer() {
    if (_isRunning) return;
    timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      _secondsElapsed++;
      notifyListeners();
    });
  }

  void stopTimer() {
    timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _secondsElapsed = 0;
    notifyListeners();
  }

  String getFormattedTime() {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final secs = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
