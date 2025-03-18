import 'dart:convert';
import 'dart:typed_data';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingGameSelect.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/components.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyslexia/services/game_service.dart';

class VisualProcessingPredictShapesLearning extends StatefulWidget {
  const VisualProcessingPredictShapesLearning({super.key});

  @override
  State<VisualProcessingPredictShapesLearning> createState() =>
      _VisualProcessingPredictShapesLearningState();
}

class _VisualProcessingPredictShapesLearningState
    extends State<VisualProcessingPredictShapesLearning> {
  int selection = -1;
  String level = "medium";
  String uId = '';
  List<Map<String, String>> pattern = [];
  String? correctShape;
  Uint8List? imageBytes; // Store decoded Base64 image to prevent flickering
  bool showSuccessGif = false;
  String? predictedShape;
  Future<void> _loadShapeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      level = prefs.getString('level') ?? "hard";
      uId = prefs.getString('user_id') ?? '';
    });

    final response = await GameService.generateShapes(level);

    if (response != null && response["status"] == true) {
      final shapes = response["patternPrediction"]["shapes"] as List<dynamic>;

      setState(() {
        pattern =
            shapes
                .map<Map<String, String>>(
                  (shape) => {
                    "shape": shape["shape"]?.toString() ?? "unknown",
                    "image": shape["image"]?.toString() ?? "",
                  },
                )
                .toList();

        if (pattern.isNotEmpty) {
          correctShape = pattern.first["shape"];
          // Decode Base64 once and store in memory
          imageBytes = base64Decode(pattern.first["image"]!);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadShapeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = Provider.of<TimerService>(context, listen: false);
      timer.resetTimer();
      timer.startTimer();
    });
  }

  Future<void> handleConfirm() async {
    if (selection == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a shape")));
      return;
    }

    String selectedShape =
        selection == 0
            ? "square"
            : selection == 1
            ? "triangle"
            : "circle";

    if (selectedShape == correctShape) {
      final timer = Provider.of<TimerService>(context, listen: false);
      timer.stopTimer();
      int totalSeconds = timer.getFormattedTimeInSeconds();

      print("✅ Correct! User selected: $selectedShape in ${totalSeconds}s");

      setState(() {
        showSuccessGif = true;
      });
      // generateNewShape();
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          showSuccessGif = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VisualprocessingGameselect(),
            ),
          );
        });
      });

      timer.resetTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error updating game progress")),
      );
    } else {
      print("❌ Wrong! Expected: $correctShape, but selected: $selectedShape");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Wrong! Expected $correctShape")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerService>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Stack(
        children: [
          ListView(
            children: [
              _buildHeader(context),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      spacing: 20,
                      children: [
                        Text("What shape is this?", style: rCheckpointTitle),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: cardBordercolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle, color: Colors.white),
                                // Timer only updates text, not the full widget tree
                                AnimatedBuilder(
                                  animation: timer,
                                  builder: (context, _) {
                                    return Text(
                                      timer.getFormattedTime(),
                                      style: timeClock,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        imageBytes != null
                            ? _buildBase64Image(imageBytes!)
                            : Image.asset('./assets/images/shape_gif1.gif'),
                        SizedBox(height: 10),
                        Text(
                          "Choose the correct shape",
                          style: rCheckpointInst2,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            shapeButton(
                              0,
                              "square",
                              "assets/images/square_shape.gif",
                            ),
                            shapeButton(
                              1,
                              "triangle",
                              "assets/images/triangle_shape.gif",
                            ),
                            shapeButton(
                              2,
                              "circle",
                              "assets/images/circle_shape.gif",
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            if (imageBytes != null)
                              CustomButton(
                                text: "Confirm",
                                isLoading: false,
                                onPressed: handleConfirm,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (showSuccessGif)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Image.asset(
                    "assets/images/pass-exam.gif",
                    width: screenWidth * 0.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Display Base64 image without flickering
  Widget _buildBase64Image(Uint8List bytes) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(
          bytes,
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
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
            radius: 20,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }

  Widget shapeButton(int index, String shape, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selection = index;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 2, right: 2, top: 0, bottom: 0),
        decoration: BoxDecoration(
          color: selection == index ? Colors.deepPurple[100] : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, width: 90, height: 80),
            SizedBox(height: 5),
            Text(shape, style: rCheckpointInst),
          ],
        ),
      ),
    );
  }
}
