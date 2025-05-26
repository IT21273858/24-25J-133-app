import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dyslexia/serviceprovider/Sketch1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';

class GANVisualProcessingDrawShapeLearning extends StatefulWidget {
  @override
  State<GANVisualProcessingDrawShapeLearning> createState() =>
      _GANVisualProcessingDrawShapeLearningState();
}

class _GANVisualProcessingDrawShapeLearningState
    extends State<GANVisualProcessingDrawShapeLearning> {
  final GlobalKey _globalKey = GlobalKey();
  List<Offset?> _points = [];

  List<String> shapes = ["circle", "square", "triangle", "star", "airplane"];
  late String displayText;
  String? displayImageBase64;
  String textInstruction = "Draw the above shape";
  String? predictedShape;
  double confidence = 0.0;
  bool isLoading = false;
  bool isValidating = false;
  bool showSuccessGif = false;

  @override
  void initState() {
    super.initState();
    generateNewShape();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerService>(context, listen: false).startTimer();
    });
  }

  Future<void> generateNewShape() async {
    setState(() {
      isLoading = true;
      predictedShape = null;
      _points.clear();
      displayImageBase64 = null;
    });

    displayText = shapes[Random().nextInt(shapes.length)];
    try {
      final response = await GameService.getGANShape(displayText);
      if (response != null && response["image_base64"] != null) {
        setState(() => displayImageBase64 = response["image_base64"]);
      }
    } catch (e) {
      print("❌ Error fetching GAN image: $e");
    } finally {
      setState(() => isLoading = false);
    }

    Provider.of<TimerService>(context, listen: false).resetTimer();
    Provider.of<TimerService>(context, listen: false).startTimer();
  }

  Future<void> stopTimer() async {
    Provider.of<TimerService>(context, listen: false).stopTimer();
  }

  Future<void> saveAndSendSketch() async {
    await stopTimer();
    setState(() => isValidating = true);

    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/${_generateFileName()}');
      await file.writeAsBytes(pngBytes);

      final response = await GameService.predictDrawnShape(file);
      if (response != null) {
        setState(() {
          predictedShape = response['prediction'];
          confidence = response['confidence'];
        });

        if (predictedShape!.toLowerCase() == displayText.toLowerCase()) {
          setState(() => showSuccessGif = true);
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              showSuccessGif = false;
              generateNewShape();
            });
          });
        } else {
          _points.clear();
        }
      } else {
        print("❌ No shape detected");
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      setState(() => isValidating = false);
    }
  }

  String _generateFileName() {
    return 'sketch_${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(100000)}.png';
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerService>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Match the Shape", style: rCheckpointTitle),
                          Container(
                            decoration: BoxDecoration(
                              color: cardBordercolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.circle, color: Colors.white),
                                  Text(
                                    timer.getFormattedTime(),
                                    style: timeClock,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            if (isLoading)
                              CircularProgressIndicator()
                            else if (displayImageBase64 != null)
                              Image.memory(
                                base64Decode(displayImageBase64!),
                                width: screenWidth * 0.6,
                                height: screenHeight * 0.3,
                                fit: BoxFit.contain,
                              )
                            else
                              Container(
                                width: screenWidth * 0.6,
                                height: screenHeight * 0.3,
                                color: Colors.grey[300],
                                child: Center(child: Text("No Image")),
                              ),
                            Text(
                              textInstruction,
                              style: rCheckpointInst,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            spacing: 5,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: cardBackgroundcolor,
                                ),
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.3,
                                child: RepaintBoundary(
                                  key: _globalKey,
                                  child: Container(
                                    color: Colors.black,
                                    child: GestureDetector(
                                      onPanUpdate: (details) {
                                        RenderBox renderBox =
                                            _globalKey.currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        Offset localPosition = renderBox
                                            .globalToLocal(
                                              details.globalPosition,
                                            );
                                        if (localPosition.dx >= 0 &&
                                            localPosition.dx <=
                                                renderBox.size.width &&
                                            localPosition.dy >= 0 &&
                                            localPosition.dy <=
                                                renderBox.size.height) {
                                          setState(
                                            () => _points.add(localPosition),
                                          );
                                        }
                                      },
                                      onPanEnd: (_) => _points.add(null),
                                      child: CustomPaint(
                                        painter: Drawing(_points),
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: pointsBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      generateNewShape();
                                      _points.clear();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            if (predictedShape != null)
                              Text(
                                predictedShape!.toLowerCase() ==
                                        displayText.toLowerCase()
                                    ? "✅ Predicted: $predictedShape\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%"
                                    : "❌ Not Matched",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      predictedShape!.toLowerCase() ==
                                              displayText.toLowerCase()
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: 10),
                            isValidating
                                ? CustomButton(
                                  text: "Validating...",
                                  onPressed: saveAndSendSketch,
                                  isLoading: true,
                                )
                                : CustomButton(
                                  text: "Validate Sketch",
                                  onPressed: saveAndSendSketch,
                                  isLoading: false,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showSuccessGif && predictedShape != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Image.asset(
                    "assets/images/pass-learning.gif",
                    width: screenWidth * 0.8,
                  ),
                ),
              ),
            ),
          if (isValidating)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        getLoaderGif(displayText),
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Validating...",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
            radius: 22,
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
}

String getLoaderGif(String shape) {
  switch (shape.toLowerCase()) {
    case "circle":
      return 'assets/images/circle-loader.gif';
    case "square":
      return 'assets/images/square-loader.gif';
    case "triangle":
      return 'assets/images/triangle-loader.gif';
    case "star":
      return 'assets/images/star-loader.gif';
    case "airplane":
      return 'assets/images/airplane-loader.gif';
    default:
      return 'assets/images/triangle_shape.gif';
  }
}
