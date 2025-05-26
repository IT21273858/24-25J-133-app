import 'package:flutter/material.dart';
import 'WordRecallScreen1.dart';

class WordRecallScreen3 extends StatefulWidget {
  final String word;

  const WordRecallScreen3({super.key, required this.word});

  @override
  _WordRecallScreen3State createState() => _WordRecallScreen3State();
}

class _WordRecallScreen3State extends State<WordRecallScreen3> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF), // Background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section with Menu and Profile
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(context, Icons.menu, () {
                      // Add functionality for menu button
                    }),
                    CircleAvatar(
                      radius: screenWidth * 0.07,
                      backgroundImage: AssetImage(
                        'assets/images/user.png',
                      ), // Profile image
                    ),
                  ],
                ),
              ),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Text(
                  '🎉 Congratulations!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.085, // Slightly larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Text(
                  'You successfully recalled the word!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055, // Adjusted for clarity
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Panda Celebration Image with responsive size
              Container(
                width:
                    screenWidth *
                    0.75, // 75% of screen width for better scaling
                height: screenHeight * 0.35, // 35% of screen height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/quin1.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Play Again Button with padding adjustments
              ElevatedButton(
                onPressed: () {
                  // Navigate back to WordRecallScreen1
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordRecallScreen1(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * 0.3, // Adjusted horizontal padding
                    vertical:
                        screenHeight * 0.03, // Slightly larger vertical padding
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055, // Adjusted for readability
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon button for menu
  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    return IconButton(
      iconSize: screenWidth * 0.07, // Adjust size
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
