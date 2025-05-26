// MorphGameScreen.dart
import 'dart:convert';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';

class MorphGameScreen extends StatefulWidget {
  const MorphGameScreen({super.key});

  @override
  State<MorphGameScreen> createState() => _MorphGameScreenState();
}

class _MorphGameScreenState extends State<MorphGameScreen> {
  final List<String> difficultyLevels = ['easy', 'medium', 'hard', 'very_hard'];
  int levelIndex = 0;
  bool showShapes = false;
  List<String?> dropZones = [];
  Uint8List? gifBytes;
  List<String> shapeOptions = [];
  List<String> correctOrder = [];
  String currentDifficulty = 'easy';

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _fetchGifAndShapes();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchGifAndShapes() async {
    setState(() {
      showShapes = false;
      gifBytes = null;
      dropZones = [];
      shapeOptions = [];
    });

    try {
      final response = await http.post(
        Uri.parse('https://x4mf7d5w-5000.asse.devtunnels.ms/generate-morph'),
        body: jsonEncode({"difficulty": currentDifficulty}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String base64Gif = data['base64_gif'];
        List<String> shapes = List<String>.from(data['shape_order']);

        setState(() {
          gifBytes = base64Decode(base64Gif);
          correctOrder = shapes;
          shapeOptions = List<String>.from(shapes)..shuffle();
          dropZones = List<String?>.filled(shapes.length, null);
        });

        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          showShapes = true;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching GIF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF4),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Morphing Game"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child:
                gifBytes == null
                    ? const Center(child: CircularProgressIndicator())
                    : (showShapes
                        ? _buildShapeGame(screenWidth, screenHeight)
                        : _buildGifScreen(screenWidth, screenHeight)),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGifScreen(double screenWidth, double screenHeight) {
    return Center(
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.memory(gifBytes!, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildShapeGame(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Text(
          "Drag the shapes in the correct order:",
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            correctOrder.length,
            (index) => DragTarget<String>(
              onAccept: (data) {
                setState(() {
                  dropZones[index] = data;
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color:
                        dropZones[index] != null
                            ? Colors.deepPurpleAccent.withOpacity(0.6)
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child:
                      dropZones[index] != null
                          ? buildShapeWidget(dropZones[index]!)
                          : const Icon(Icons.add, color: Colors.black38),
                );
              },
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.04),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              shapeOptions
                  .map(
                    (shape) => Draggable<String>(
                      data: shape,
                      feedback: Material(
                        color: Colors.transparent,
                        child: buildShapeWidget(shape, size: 50),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.4,
                        child: buildShapeWidget(shape, size: 50),
                      ),
                      child: buildShapeWidget(shape, size: 50),
                    ),
                  )
                  .toList(),
        ),
        SizedBox(height: screenHeight * 0.04),
        ElevatedButton(
          onPressed: _submitOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text("Submit", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget buildShapeWidget(String shape, {double size = 40}) {
    switch (shape.toLowerCase()) {
      case 'circle':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        );
      case 'square':
        return Container(width: size, height: size, color: Colors.green);
      case 'triangle':
        return CustomPaint(size: Size(size, size), painter: TrianglePainter());
      case 'star':
        return CustomPaint(size: Size(size, size), painter: StarPainter());
      default:
        return Text(shape);
    }
  }

  void _submitOrder() async {
    if (dropZones.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all drop zones!")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://x4mf7d5w-5000.asse.devtunnels.ms/evaluate-morph'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "user_guess": dropZones,
        "correct_order": correctOrder,
        "difficulty": currentDifficulty,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      bool passed = data["passed"];
      int score = data["score"];
      int minScore = data["min_score"];

      if (passed) {
        if (levelIndex < difficultyLevels.length - 1) {
          levelIndex++;
          currentDifficulty = difficultyLevels[levelIndex];

          _showScoreDialog(
            title: "✅ Passed!",
            message: "Score: $score / ${shapeOptions.length}",
            buttonText: "Next Level",
            onClose: () {
              Navigator.pop(context);
              _fetchGifAndShapes();
            },
          );
        } else {
          _confettiController.play();
          _showScoreDialog(
            title: "🏆 All Levels Complete!",
            message: "🎉 You've completed all levels!\nHere's your reward 🎁",
            buttonText: "Yay!",
          );
        }
      } else {
        _showScoreDialog(
          title: "❌ Try Again",
          message:
              "Score: $score / ${shapeOptions.length}\n"
              "Minimum to pass: $minScore\n\n"
              "Correct Order:\n${correctOrder.join(' ➝ ')}",
          buttonText: "Retry",
        );
      }
    }
  }

  void _showScoreDialog({
    required String title,
    required String message,
    required String buttonText,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 24)),
            content: Text(message, style: const TextStyle(fontSize: 18)),
            actions: [
              TextButton(
                onPressed: onClose ?? () => Navigator.pop(context),
                child: Text(buttonText),
              ),
            ],
          ),
    );
  }
}

// Shape Painters
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.orange;
    final path =
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.pink;
    final path = Path();
    final double r = size.width / 2;
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    for (int i = 0; i < 5; i++) {
      double angle = (i * 144) * 3.1415926535 / 180;
      double x = cx + r * Math.cos(angle);
      double y = cy + r * Math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
