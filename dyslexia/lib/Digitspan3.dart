import 'package:flutter/material.dart';

class DigitSpan3TaskScreen extends StatefulWidget {
  @override
  _DigitSpan3TaskScreenState createState() => _DigitSpan3TaskScreenState();
}

class _DigitSpan3TaskScreenState extends State<DigitSpan3TaskScreen> {
  List<String> _selectedNumbers = []; // To hold the selected numbers

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
              backgroundImage:
                  AssetImage('assets/images/user.png'), // Profile image
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
              'Digit Span Task',
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
            Container(
              height: screenHeight * 0.15, // Size of the box
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                color:
                    Colors.deepPurple.shade50, // Light deep purple background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _selectedNumbers.isEmpty
                    ? const Text(
                        '---',
                        style: TextStyle(
                          fontSize: 100, // Set font size to 100
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        _selectedNumbers.join(', '),
                        style: const TextStyle(
                          fontSize: 100, // Set font size to 100
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
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .deepPurple.shade200, // Light deep purple button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedNumbers.add(index.toString());
                      });
                    },
                    child: Text(
                      index.toString(),
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
                // Add submit functionality here
              },
              child: const Text(
                'Submit',
                style:
                    TextStyle(fontSize: 18, color: Colors.white), // White text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DigitSpan3TaskScreen(),
  ));
}
