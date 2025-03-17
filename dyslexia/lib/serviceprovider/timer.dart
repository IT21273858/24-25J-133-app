import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  Timer? timer;
  int _secondsElapsed = 0;
  VoidCallback? onTimeupCallback;
  bool _isRunning = false;

  void initStopwatch(int seconds, {VoidCallback? onTimeup}) {
    _secondsElapsed = seconds;
    onTimeupCallback = onTimeup;
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
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

  void startStopwatch() {
    if (_isRunning) return;
    _isRunning = true;
    timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      if (_secondsElapsed == 0) {
        stopTimer();

        if (onTimeupCallback != null) {
          onTimeupCallback!();
        }
        return;
      }
      _secondsElapsed--;
      notifyListeners();
    });
  }

  void restartwithSeconds(int seconds) {
    if (!_isRunning) {
      _secondsElapsed = seconds;
      // _isRunning = true;
      startStopwatch();
    }
  }

  void stopStopWatch() {
    if (!_isRunning) return;

    resetTimer();
    onTimeupCallback = null;
    notifyListeners();
  }

  bool isTimeup() {
    return _secondsElapsed == 0;
  }
}
