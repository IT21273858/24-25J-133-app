import 'package:flutter/material.dart';
import 'dart:async';

class DigitSpanTaskScreen2 extends StatefulWidget {
  @override
  _DigitSpanTaskScreen2State createState() => _DigitSpanTaskScreen2State();
}

class _DigitSpanTaskScreen2State extends State<DigitSpanTaskScreen2> {
  int _remainingSeconds = 3; // Set initial countdown seconds
  Timer? _timer;
  String _digitToShow = ""; // Digit that will be displayed

  @override
  void initState() {
    super.initState();
    _generateDigit();
    _startCountdown();
  }

  void _generateDigit() {
    setState(() {
      _digitToShow =
          (1 + (9 * (DateTime.now().millisecondsSinceEpoch % 10) / 10))
              .toInt()
              .toString();
    });
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        // Proceed to next step (e.g., asking user input or next digit)
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF), // Updated background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context), // Header with profile and menu
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Digit Span Task',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Updated color
                    fontFamily: 'Risque',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.8, // 80% of screen width
                  height: screenHeight * 0.3, // 30% of screen height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/panda.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Make the digit display more prominent
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100], // Updated color
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _digitToShow,
                    style: TextStyle(
                      fontSize: screenWidth *
                          0.2, // Increased font size for visibility
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Updated color
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Countdown Timer
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100], // Updated color
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '00 : ${_remainingSeconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Updated color
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
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
            // Add functionality for menu button
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DigitSpanTaskScreen2(),
  ));
}
