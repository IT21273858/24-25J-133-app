import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/services/memory_service.dart';
import 'package:dyslexia/shorttermmemory/wordsrecall/WordRecallScreen2.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WordRecallScreen1 extends StatefulWidget {
  @override
  _WordRecallScreen1State createState() => _WordRecallScreen1State();
}

class _WordRecallScreen1State extends State<WordRecallScreen1> {
  int _remainingSeconds = 0;
  Timer? _timer;
  String _wordToShow = "";
  String _level = "";

  @override
  void initState() {
    super.initState();
    _fetchGeneratedWord();
  }

  Future<void> _fetchGeneratedWord() async {
    var response = await MemoryService.generateWord();
    if (response != null && response['status'] == true) {
      setState(() {
        _wordToShow = response['generatedWord']['word']; // Example: "dog"
        _level = response['generatedWord']['true_level']; // Example: "Level 2"
        _remainingSeconds =
            response['generatedWord']['display_time']; // Example: 4 seconds
      });

      _startCountdown();
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
        });
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WordRecallScreen2(word: _wordToShow),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(context), // Header with profile and menu
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Word Recall Task',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth * 0.8, // 80% of screen width
              height: screenHeight * 0.3, // 30% of screen height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/quin1.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Display word inside a styled container
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _wordToShow,
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
    );
  }

  // Header Section with Profile and Menu
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

  // Icon button for menu
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
