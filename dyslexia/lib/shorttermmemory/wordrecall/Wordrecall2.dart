import 'package:dyslexia/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordRecallTaskScreen2(level: 1),
    ),
  );
}

class WordRecallTaskScreen2 extends StatefulWidget {
  final int level;
  WordRecallTaskScreen2({required this.level});

  @override
  _WordRecallTaskScreenState createState() => _WordRecallTaskScreenState();
}

class _WordRecallTaskScreenState extends State<WordRecallTaskScreen2> {
  int _remainingSeconds = 3; // Countdown timer
  Timer? _timer;
  String _wordToShow = "";

  // Word lists for different levels
  final Map<int, List<String>> _wordLevels = {
    1: [
      'AN',
      'AT',
      'BY',
      'DO',
      'GO',
      'HE',
      'IF',
      'IN',
      'IS',
      'IT',
    ], // 2-letter words
    2: [
      'CAT',
      'DOG',
      'SUN',
      'MAP',
      'HAT',
      'PEN',
      'RUN',
      'CAR',
      'BAT',
      'TOP',
    ], // 3-letter words
    3: [
      'TREE',
      'FISH',
      'BIRD',
      'MOON',
      'STAR',
      'WIND',
      'HAND',
      'FOOT',
      'DOOR',
      'FARM',
    ], // 4-letter words
  };

  @override
  void initState() {
    super.initState();
    _generateWord();
    _startCountdown();
  }

  void _generateWord() {
    final words = _wordLevels[widget.level] ?? [];
    setState(() {
      _wordToShow =
          words[(DateTime.now().millisecondsSinceEpoch % words.length).toInt()];
    });
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (widget.level < 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => WordRecallTaskScreen2(level: widget.level + 1),
            ),
          );
        } else {
          // If last level, navigate to completion page or restart
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompletionScreen()),
          );
        }
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Level ${widget.level}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _wordToShow,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '00 : ${_remainingSeconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompletionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Congratulations! You completed all levels!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
