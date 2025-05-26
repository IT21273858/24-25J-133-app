import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dyslexia/serviceprovider/drawing.dart';
import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class VisualprocessingDrawshapes extends StatefulWidget {
  @override
  State<VisualprocessingDrawshapes> createState() =>
      _VisualprocessingDrawshapesState();
}

class _VisualprocessingDrawshapesState
    extends State<VisualprocessingDrawshapes> {
  final GlobalKey _globalKey = GlobalKey();
  List<Offset?> _points = [];
  List<String> shapes = ["Circle", "Square", "Triangle", "Star", "Airplane"];
  late String displayText;
  String textInstruction = "Draw the above-mentioned shape";
  String? predictedShape;
  bool isLoading = false;
  bool showSuccessGif = false;

  @override
  void initState() {
    super.initState();
    displayText = getRandomShape();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = Provider.of<TimerService>(context, listen: false);
      timer.resetTimer();
      timer.startTimer();
    });
  }

  String getRandomShape() {
    final random = Random();
    return shapes[random.nextInt(shapes.length)];
  }

  void generateNewShape() {
    setState(() {
      displayText = getRandomShape(); // Pick a new random shape
      predictedShape = null;
      _points.clear(); // Clear drawing
    });
    print(displayText);
    final timer = Provider.of<TimerService>(context, listen: false);
    timer.resetTimer();
    timer.startTimer();
  }

  Future<void> stopTimer() async {
    final timer = Provider.of<TimerService>(context, listen: false);
    timer.stopTimer();
    int totalSeconds = timer.getFormattedTimeInSeconds();
    print("⏳ Time taken: $totalSeconds seconds");
  }

  // 🔹 Capture, Save, and Send Drawing to Backend
  Future<void> saveAndSendSketch() async {
    await stopTimer();
    setState(() {
      isLoading = true;
    });

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
      File file = File('${dir.path}/${generateRandomFileName()}');
      await file.writeAsBytes(pngBytes);

      print("📤 File saved: ${file.path}");

      // 🔹 Send the Image to Backend
      Map<String, dynamic>? response = await GameService.predictDrawnShape(
        file,
      );

      if (response != null) {
        setState(() {
          print("Response is  ${response}");
          predictedShape = response['prediction'];
        });

        if (predictedShape!.toLowerCase() == displayText.toLowerCase()) {
          print("Setting gif");
          setState(() {
            showSuccessGif = true;
          });
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              showSuccessGif = false;
              generateNewShape();
            });
          });
        }

        print("✅ Predicted Shape: ${predictedShape}");
      } else {
        print("❌ No shape detected");
      }
    } catch (e) {
      print("❌ Error saving or sending sketch: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String generateRandomFileName({String extension = 'png'}) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomNumber = random.nextInt(100000);
    return 'sketch_$timestamp-$randomNumber.$extension';
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerService>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Stack(
        // padding: const EdgeInsets.symmetric(horizontal: 5.0),
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Predict Shape", style: rCheckpointTitle),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: cardBordercolor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                timer.getFormattedTime(),
                                                style: timeClock,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/beec.png",
                                        width: screenWidth * 0.25,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    displayText,
                                    style: rCheckpointtxtDisplayH,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          child: Column(
                            children: [
                              Text(
                                textInstruction,
                                style: rCheckpointInst,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            spacing: 10,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
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
                                          setState(() {
                                            _points.add(localPosition);
                                          });
                                        }
                                      },
                                      onPanEnd: (details) {
                                        _points.add(null);
                                      },
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
                            if (predictedShape != null &&
                                predictedShape!.toLowerCase() ==
                                    displayText.toLowerCase())
                              Text(
                                "Predicted: $predictedShape",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else if (predictedShape != null)
                              Text(
                                "Not Matched",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            SizedBox(height: 10),
                            isLoading
                                ? CircularProgressIndicator()
                                : CustomButton(
                                  text: "Validate Sketch",
                                  isLoading: false,
                                  onPressed: saveAndSendSketch,
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
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Background blur effect
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        getLoaderGif(
                          displayText,
                        ), // Function to get appropriate GIF
                        width: 200, // Adjust width of loader
                        height: 200, // Adjust height of loader
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Processing...",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
    default:
      return 'assets/images/triangle_shape.gif';
  }
}
