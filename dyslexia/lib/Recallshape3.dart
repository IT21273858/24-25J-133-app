import 'package:flutter/material.dart';
import 'dart:math';

class RecallShape3Screen extends StatefulWidget {
  @override
  _RecallShape3ScreenState createState() => _RecallShape3ScreenState();
}

class _RecallShape3ScreenState extends State<RecallShape3Screen> {
  String shapeToFind = ''; // The shape that needs to be found
  List<Widget> _selectedShapes = []; // List to hold selected shape widgets

  // Define the shape options
  List<String> shapeOptions = [
    'circle',
    'triangle',
    'square',
    'star',
  ];

  // Shuffle the shape options to display randomly
  List<String> get shuffledShapes {
    List<String> shuffled = List.from(shapeOptions);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  void initState() {
    super.initState();
    // Randomly select the shape to find
    shapeToFind = shapeOptions[Random().nextInt(shapeOptions.length)];
  }

  // Function to create a shape widget based on shape type
  Widget getShapeWidget(String shapeName) {
    switch (shapeName) {
      case 'circle':
        return Container(
          width: 100, // Increased size
          height: 100, // Increased size
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue, // Circle color
          ),
        );
      case 'triangle':
        return CustomPaint(
          size: Size(100, 100), // Increased size
          painter: TrianglePainter(),
        );
      case 'square':
        return Container(
          width: 100, // Increased size
          height: 100, // Increased size
          color: Colors.green, // Square color
        );
      case 'star':
        return Icon(
          Icons.star,
          color: Colors.yellow,
          size: 100, // Increased size
        );
      default:
        return Container();
    }
  }

  void _submitAnswer() {
    // Show dialog or handle logic to check the answer
    if (_selectedShapes.isNotEmpty &&
        _selectedShapes[0] == getShapeWidget(shapeToFind)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Correct!'),
          content: Text('You found the correct shape: $shapeToFind'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Incorrect!'),
          content: Text('Try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
                  const AssetImage('assets/images/user.png'), // Profile image
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
              'Recall Shape Task',
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
                child: _selectedShapes.isEmpty
                    ? const Text(
                        '---',
                        style: TextStyle(
                          fontSize: 100, // Set font size to 100
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _selectedShapes, // Show visual shapes here
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
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: shapeOptions.length,
                itemBuilder: (context, index) {
                  final shapeName =
                      shuffledShapes[index]; // Get the randomly shuffled shape
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
                        // Add shape widget instead of shape name to list
                        _selectedShapes.add(getShapeWidget(shapeName));
                      });
                    },
                    child:
                        getShapeWidget(shapeName), // Display the shape widget
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
              onPressed: _submitAnswer, // Check the user's selection
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

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Triangle color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RecallShape3Screen(), // No shapeToFind argument passed
  ));
}
