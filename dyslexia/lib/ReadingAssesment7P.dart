import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/Sketch.dart';
import 'package:dyslexia/services/ReadServices/readApi.dart';
import 'package:dyslexia/soundconfig.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class WriteSound extends StatefulWidget {
  @override
  State<WriteSound> createState() => _WriteSoundState();
}

class _WriteSoundState extends State<WriteSound> {
  final GlobalKey _globalKey = GlobalKey();
  final TextToSpeechHelper tts = TextToSpeechHelper();
  List<Offset?> _points = [];

  String? Word = null;
  bool isfeatching = false;
  bool isValidating = false;
  bool showText = false;

  String generateRandomFileName({String extension = 'png'}) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomNumber = random.nextInt(100000); // Random 5-digit number
    return 'sketches_$timestamp-$randomNumber.$extension';
  }

  Future<void> saveSketch() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // save file
      final dir = await getDownloadsDirectory();
      File file = File(dir!.path + generateRandomFileName());
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchLeter() async {
    if (isfeatching) {
      return;
    }
    setState(() {
      isfeatching = true;
    });

    List test = List.from(testAlpha);
    test.shuffle(Random());
    setState(() {
      Word = test[0];
    });

    setState(() {
      isfeatching = false;
    });
  }

  Future<void> validateSketch() async {
    //get the sketch ( letter return by User ) and validate with the audio (sound of A). if the Audio and the Sketch matches.
    //user passes level

    if (isValidating) return;

    setState(() {
      isValidating = true;
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

      // save file
      final dir = await getDownloadsDirectory();
      String rfilename = generateRandomFileName();
      File file = File(dir!.path + rfilename);
      await file.writeAsBytes(pngBytes);

      //validate with Google-ML
      // final inputImage = InputImage.fromFile(file);
      // final textRecognizer = TextRecognizer(
      //   script: TextRecognitionScript.latin,
      // );
      // final RecognizedText recognizedText = await textRecognizer.processImage(
      //   inputImage,
      // );
      // String extractedText = recognizedText.text.trim();
      // await textRecognizer.close();
      // print("extxt $extractedText");

      //validate with tesserat
      // String txtext = await FlutterTesseractOcr.extractText(
      //   file.path,
      //   language: "eng",
      // );
      // print(txtext);

      final response = await Readapi.verifyHandwriting(file.path);

      if (response != null) {
        if (response['result']['predictedChar']
            .toString()
            .toLowerCase()
            .split(" ")
            .contains(Word!.toLowerCase())) {
          CustomSnakbar.showSnack(
            context,
            "Congratulations 🥳, sketch is valid",
            bgcolor: Colors.greenAccent.shade400,
            txtcolor: readingTitleColoropaHalf,
          );
          await fetchLeter();
          setState(() {
            _points.clear();
          });
        } else {
          CustomSnakbar.showSnack(
            context,
            "Invalid ❌, sketch is invalid",
            bgcolor: Colors.redAccent.shade400,
          );
          setState(() {
            _points.clear();
          });
        }
      }
    } catch (e) {
      print("error");
      print(e);
    } finally {
      setState(() {
        isValidating = false;
      });
    }
  }

  @override
  void initState() {
    Word = null;
    isfeatching = false;
    isValidating = false;
    showText = false;
    fetchLeter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String displayText = "Circle";
    String textinstruction = "Hear the sound and write the letter";
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Column(
                spacing: 20,
                children: [
                  _buildHeader(context),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       'Your Child Performance this week',
                  //       style: TextStyle(color: Colors.black, fontSize: 16),
                  //     ),
                  //     Padding(padding: EdgeInsets.all(10)),
                  //   ],
                  // ),
                  // _buildChildSelection(),
                  // _buildPerformanceSection(),
                  // _buildManageChildrenSection(context),
                  // Padding(padding: EdgeInsets.only(bottom: 10)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      spacing: 1,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Write the Sound",
                                  style: rCheckpointTitle,
                                ),
                                // Text("Level 1", style: rCheckpointLv),
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
                                  ),
                                  // color: Color.fromRGBO(166, 159, 204, 0.31),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: readingTitleColoropaHalf,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40),
                                              ),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showText = !showText;
                                                });
                                              },
                                              icon: Icon(
                                                FeatherIcons.gift,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.7,
                                          child: Row(
                                            spacing: 12,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            readingTitleColoropaHalf,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                40,
                                                              ),
                                                            ),
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          if (Word != null) {
                                                            tts.speak(Word!);
                                                          }
                                                        },
                                                        icon: Icon(
                                                          FeatherIcons.volume2,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Let",
                                                    style: rCheckpointInst,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "Sound",
                                                    style: rCheckpointInst,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                              Image.asset(
                                                isValidating
                                                    ? "assets/images/dinowalk.gif"
                                                    : "assets/images/teddy.png",
                                                width: screenWidth * 0.25,
                                              ),
                                              showText
                                                  ? Text(
                                                    Word!,
                                                    style:
                                                        rCheckpointtxtDisplay,
                                                  )
                                                  : Text(""),
                                            ],
                                          ),
                                        ),
                                      ],
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
                              spacing: 5,
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: pointsBackgroundColor,
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(40),
                                //     ),
                                //   ),
                                //   child: IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(Icons.mic, color: Colors.white),
                                //   ),
                                // ),
                                Text(
                                  textinstruction,
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
                              spacing: 9,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: const ui.Color.fromARGB(
                                      255,
                                      0,
                                      0,
                                      0,
                                    ),
                                  ),
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.3,
                                  child: RepaintBoundary(
                                    key: _globalKey,
                                    child: Container(
                                      color: const ui.Color.fromARGB(
                                        255,
                                        0,
                                        0,
                                        0,
                                      ),
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

                                          Size containerSize = renderBox.size;
                                          if (localPosition.dx >= 0 &&
                                              localPosition.dx <=
                                                  containerSize.width &&
                                              localPosition.dy >= 0 &&
                                              localPosition.dy <=
                                                  containerSize.height) {
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
                                          child: Container(
                                            width: screenWidth * 0.8,
                                            height: screenHeight * 0.3,
                                          ),
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
                                    onPressed: () async {
                                      setState(() {
                                        _points.clear();
                                      });
                                      // await fetchLeter();
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
                            spacing: 9,
                            children: [
                              CustomButton(
                                text:
                                    isValidating
                                        ? "Validating"
                                        : "Validate Sketch",
                                isLoading: false,
                                onPressed: validateSketch,
                              ),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     "Skip Shape",
                              //     style: rCheckpointSkip,
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeader(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(42),
      //     bottomRight: Radius.circular(42),
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       spreadRadius: 2,
      //       blurRadius: 10,
      //       offset: Offset(0, 4),
      //     ),
      //   ],
      // ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
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
        ],
      ),
    );
  }

  // Scrollable Child Selection
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   shape: BoxShape.circle,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       spreadRadius: 1,
      //       blurRadius: 5,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
