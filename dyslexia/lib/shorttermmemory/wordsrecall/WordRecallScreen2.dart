import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/shorttermmemory/wordsrecall/WordRecallScreen3.dart';
import 'package:flutter/material.dart';

class WordRecallScreen2 extends StatefulWidget {
  final String word;

  const WordRecallScreen2({super.key, required this.word});

  @override
  _WordRecallScreen2State createState() => _WordRecallScreen2State();
}

class _WordRecallScreen2State extends State<WordRecallScreen2> {
  TextEditingController _controller = TextEditingController();

  void _submitAnswer() {
    if (_controller.text.trim().toLowerCase() == widget.word.toLowerCase()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WordRecallScreen3(word: widget.word),
        ),
      );
    } else {
      _controller.clear();

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('❌ Incorrect!'),
              content: Text('Try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          // Fix overflow when keyboard appears
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                      image: AssetImage('assets/images/panda.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Input field for typing the word
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text, // Ensure text input
                    textInputAction:
                        TextInputAction.done, // Better keyboard behavior
                    decoration: InputDecoration(
                      hintText: "Enter the word...",
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Submit button
                ElevatedButton(
                  onPressed: _submitAnswer,
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
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
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
