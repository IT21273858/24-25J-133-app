import 'package:dyslexia/shorttermmemory/recall/Recallshape4.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RecallShape3Screen extends StatefulWidget {
  final String shapeToFind;

  const RecallShape3Screen({super.key, required this.shapeToFind});

  @override
  _RecallShape3ScreenState createState() => _RecallShape3ScreenState();
}

class _RecallShape3ScreenState extends State<RecallShape3Screen> {
  String? _selectedShape; // Stores selected shape name
  late List<String> shuffledShapes; // Stores the shuffled shape list

  @override
  void initState() {
    super.initState();
    shuffledShapes = List.from(['circle', 'triangle', 'square', 'star']);
    shuffledShapes.shuffle(Random()); // Shuffle once at the beginning
  }

  Widget getShapeWidget(String shapeName) {
    switch (shapeName) {
      case 'circle':
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        );
      case 'triangle':
        return CustomPaint(size: Size(100, 100), painter: TrianglePainter());
      case 'square':
        return Container(width: 100, height: 100, color: Colors.green);
      case 'star':
        return Icon(Icons.star, color: Colors.yellow, size: 100);
      default:
        return Container();
    }
  }

  void _submitAnswer() {
    if (_selectedShape != null && _selectedShape == widget.shapeToFind) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('✅ Correct!'),
              content: Text(
                'You found the correct shape: ${widget.shapeToFind}',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecallShape4Screen(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else {
      setState(() {
        _selectedShape = null; // Reset selection
      });

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
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          Text(
            'Recall Shape Task',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: shuffledShapes.length, // Use stored shuffled list
              itemBuilder: (context, index) {
                final shapeName = shuffledShapes[index];
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedShape = shapeName; // Store shape name
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedShape == shapeName
                            ? Colors.deepPurple
                            : Colors.white,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                  child: getShapeWidget(shapeName),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _submitAnswer, child: Text('Submit')),
        ],
      ),
    );
  }
}

// ✅ **TrianglePainter Definition**
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.fill;

    final path =
        Path()
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
