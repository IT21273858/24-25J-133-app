import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RecallShapeScreen2 extends StatefulWidget {
  @override
  _RecallShapeScreen2State createState() => _RecallShapeScreen2State();
}

class _RecallShapeScreen2State extends State<RecallShapeScreen2> {
  int _remainingSeconds = 3; // Set initial countdown seconds
  Timer? _timer;
  String _shapeToShow = ""; // Shape that will be displayed

  final List<String> _shapes = [
    'Circle',
    'Square',
    'Triangle'
  ]; // Shape options

  @override
  void initState() {
    super.initState();
    _generateShape();
    _startCountdown();
  }

  void _generateShape() {
    setState(() {
      // Randomly select a shape from the list
      _shapeToShow = _shapes[Random().nextInt(_shapes.length)];
    });
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        // Proceed to the next step (e.g., user input or next shape)
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
                  'Recall Shape',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Updated color
                    fontFamily: 'Risque',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                // Stack widget to overlay bunny image on top of the shape
                Container(
                  width: screenWidth * 0.8, // 80% of screen width
                  height: screenHeight * 0.3, // 30% of screen height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/bunny1.png'), // Updated to bunny1.png
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Display the random shape below the image
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100], // Updated color
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _buildShapeWidget(_shapeToShow),
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
            backgroundImage:
                AssetImage('assets/images/user.png'), // User profile image
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

  // Function to build the shape widget based on the selected shape
  Widget _buildShapeWidget(String shape) {
    switch (shape) {
      case 'Circle':
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepPurple,
          ),
        );
      case 'Square':
        return Container(
          width: 150,
          height: 150,
          color: Colors.deepPurple,
        );
      case 'Triangle':
        return CustomPaint(
          size: Size(150, 150),
          painter: TrianglePainter(),
        );
      default:
        return Container();
    }
  }
}

// CustomPainter for drawing a triangle
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecallShapeScreen2(),
  ));
}
