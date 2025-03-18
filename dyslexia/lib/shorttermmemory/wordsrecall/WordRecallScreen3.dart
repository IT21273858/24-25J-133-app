import 'package:flutter/material.dart';

class WordRecallScreen3 extends StatefulWidget {
  final String word;

  const WordRecallScreen3({super.key, required this.word});

  @override
  _WordRecallScreen3State createState() => _WordRecallScreen3State();
}

class _WordRecallScreen3State extends State<WordRecallScreen3> {
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF), // Preserve background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '🎉 Congratulations!',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'You successfully recalled the word!',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.05),
            // Panda Celebration Image
            Container(
              width: screenWidth * 0.6, // 60% of screen width
              height: screenHeight * 0.3, // 30% of screen height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/panda_celebration.png',
                  ), // Add a celebration image
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Play Again Button
            ElevatedButton(
              onPressed:
                  () => Navigator.popUntil(context, ModalRoute.withName('/')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Play Again',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
