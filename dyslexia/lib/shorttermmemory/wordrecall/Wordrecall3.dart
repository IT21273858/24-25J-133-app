import 'package:dyslexia/shorttermmemory/wordrecall/Wordrecall4.dart';
import 'package:flutter/material.dart';

class WordRecallTaskScreen3 extends StatefulWidget {
  final String? wordToShow;

  const WordRecallTaskScreen3({super.key, required this.wordToShow});

  @override
  _WordRecallTaskScreenState createState() => _WordRecallTaskScreenState();
}

class _WordRecallTaskScreenState extends State<WordRecallTaskScreen3> {
  List<String> _selectedWords = []; // To hold the selected words
  final List<String> _wordOptions = [
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
    'ME',
    'NO',
    'OF',
    'ON',
    'OR',
    'TO',
    'UP',
    'WE',
    'YE',
  ]; // Word options

  @override
  void initState() {
    super.initState();
    print(widget.wordToShow); // Debugging log
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Remove color from AppBar
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black), // Menu icon color
          onPressed: () {}, // Add menu functionality here
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: screenWidth * 0.07,
              backgroundImage: AssetImage(
                'assets/images/user.png',
              ), // Profile image
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Word Recall Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Risque',
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              'assets/images/panda.png', // Replace with your panda image path
              height: screenHeight * 0.2,
            ),
            SizedBox(height: screenHeight * 0.02),

            SizedBox(height: screenHeight * 0.02),

            // Box displaying selected words
            Container(
              height: screenHeight * 0.15, // Size of the box
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100, // Slightly darker background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _selectedWords.isEmpty ? "---" : _selectedWords.join(', '),
                  style: const TextStyle(
                    fontSize: 40, // Set font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Make sure the GridView takes up available space but doesn't overflow
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _wordOptions.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors
                              .deepPurple
                              .shade200, // Light deep purple button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedWords.add(_wordOptions[index]);
                      });
                    },
                    child: Text(
                      _wordOptions[index],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // White text on buttons for contrast
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurple, // Deep purple for submit button
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _checkSuccess(context);
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ), // White text
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  // Function to check if user selected the correct word
  void _checkSuccess(BuildContext context) {
    if (_selectedWords.contains(widget.wordToShow)) {
      // Navigate to Success Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WordRecallTaskLevel4()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect! Try Again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
