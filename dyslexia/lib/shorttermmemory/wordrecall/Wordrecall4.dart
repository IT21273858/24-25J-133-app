import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/shorttermmemory/wordrecall/Wordrecall2.dart';
import 'package:flutter/material.dart';

class WordRecallTaskLevel4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Word Recall Task",
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Risque', // Custom font
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Great Job!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Risque',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "You Passed Level 1",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Risque',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  width: screenWidth * 0.8, // 80% of screen width
                  height: screenHeight * 0.4, // 40% of screen height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/quin1.png'),
                      fit: BoxFit.contain, // Fits the panda image
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordRecallTaskScreen2(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3,
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  child: Text(
                    'Next Level',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  // Header Section
  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(context, Icons.menu, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomDrawer()),
            );
          }),
          CircleAvatar(
            radius: screenWidth * 0.07,
            backgroundImage: AssetImage(
              'assets/images/user.png',
            ), // User profile image
          ),
        ],
      ),
    );
  }

  // Icon button for menu
  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return IconButton(
      iconSize: MediaQuery.of(context).size.width * 0.07, // Adjust size
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordRecallTaskLevel4(),
    ),
  );
}
