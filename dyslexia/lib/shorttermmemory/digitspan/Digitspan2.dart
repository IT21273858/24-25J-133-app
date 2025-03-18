import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/services/memory_service.dart';
import 'package:dyslexia/shorttermmemory/digitspan/Digitspan3.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DigitSpanTaskScreen2 extends StatefulWidget {
  @override
  _DigitSpanTaskScreen2State createState() => _DigitSpanTaskScreen2State();
}

class _DigitSpanTaskScreen2State extends State<DigitSpanTaskScreen2> {
  int _remainingSeconds = 0; // Countdown for each digit
  Timer? _timer;
  List<int> _digitSequence = [];
  int _currentIndex = 0;
  String _currentDigit = "";

  @override
  void initState() {
    super.initState();
    _fetchDigitSequence();
  }

  Future<void> _fetchDigitSequence() async {
    var response = await MemoryService.generateDigitSequence();
    if (response != null && response['status'] == true) {
      List<int> fetchedSequence = List<int>.from(
        response['digitSequence']['digitSequence'],
      );
      int displayTime = response['digitSequence']['displayTime'];

      setState(() {
        _digitSequence = fetchedSequence;
        _remainingSeconds = displayTime;
        _currentDigit =
            _digitSequence.isNotEmpty ? _digitSequence[0].toString() : "";
      });

      _startCountdown();
    } else {
      print("Failed to fetch digit sequence");
    }
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _navigateToNextScreen();
      } else {
        setState(() {
          _remainingSeconds--;
          if (_currentIndex < _digitSequence.length - 1) {
            _currentIndex++;
            _currentDigit = _digitSequence[_currentIndex].toString();
          }
        });
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => DigitSpan3TaskScreen(digitSequence: _digitSequence),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context), // Profile and Menu
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Digit Span Task',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontFamily: 'Risque',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/panda.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Digit Display
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _currentDigit,
                  style: TextStyle(
                    fontSize: screenWidth * 0.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Countdown Timer
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '00 : ${_remainingSeconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.menu, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomDrawer()),
            );
          }),
          CircleAvatar(
            radius: screenWidth * 0.07,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
