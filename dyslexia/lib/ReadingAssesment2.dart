import 'dart:math';

import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/soundconfig.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class UnderstandSound extends StatefulWidget {
  @override
  State<UnderstandSound> createState() => _UnderstandSoundState();
}

class _UnderstandSoundState extends State<UnderstandSound> {
  // audio recoridnf
  final recorder = AudioRecorderService();
  String? selection = null;
  String? correctanswer = null;
  List<String> displayList = [];
  final TextToSpeechHelper tts = TextToSpeechHelper();
  bool isrecording = false;
  bool isfetching = false;
  bool isValidating = false;

  @override
  void initState() {
    setState(() {
      isrecording = false;
      isValidating = false;
      isfetching = false;
      displayList = [];
      selection = null;
      correctanswer = null;
    });
    assignWord();
    super.initState();
  }

  Future<void> assignWord() async {
    if (isfetching) {
      return;
    }
    setState(() {
      isfetching = true;
    });
    List<List<String>> phonicslistCopy = List.from(simplephonisc);
    phonicslistCopy.shuffle(Random());
    List<String> displayListlocal = List.from(phonicslistCopy[0]);
    final selectionlocal = displayListlocal[0];
    displayListlocal.shuffle(Random());
    setState(() {
      displayList = displayListlocal;
      correctanswer = selectionlocal;
      selection = null;
      isfetching = false;
    });
  }

  Future<void> validate() async {
    if (isfetching) return;

    if (selection == null) {
      CustomSnakbar.showSnack(context, "Select the matching audio first");
      return;
    }

    setState(() {
      isValidating = true;
    });

    if (selection == correctanswer) {
      CustomSnakbar.showSnack(
        context,
        " 🥳 Your Correct",
        bgcolor: Colors.green.shade200,
        txtcolor: readingTitleColor,
      );
    } else {
      CustomSnakbar.showSnack(
        context,
        " ❌ Your Prediction is wrong",
        bgcolor: Colors.redAccent.shade200,
      );
    }
    print(" correct is : $correctanswer");
    print(" your value is : $selection");
    await assignWord();
    setState(() {
      isValidating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String displayText = correctanswer ?? "_";
    String hintText = "Shoe";
    String textinstruction = "Choose the correct pronounciation";

    Future<void> startRecording() async {
      await recorder.startRecording();
      setState(() {
        isrecording = true;
      });
    }

    Future<void> stopRecording() async {
      String? outputpath = await recorder.stopRecording();
      setState(() {
        isrecording = false;
      });
      print("audio stoped");
      print(outputpath ?? "no path");
    }

    Future<void> handleRecording() async {
      if (!isrecording) {
        //start record here
        await startRecording();
      } else {
        //stop record here
        await stopRecording();
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
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
                    spacing: 24,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Understand", style: rCheckpointTitle),
                              Text("the Sound", style: rCheckpointTitle),
                              // Text("Level 1", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   "assets/images/rabi.png",
                            //   width: screenWidth * 0.6,
                            // ),
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.3,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17),
                                ),
                                color: Color.fromRGBO(166, 159, 204, 0.31),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text("Symbol", style: rCheckpointInst),
                                    ],
                                  ),
                                  Text(
                                    displayText,
                                    style: rCheckpointtxtDisplay,
                                  ),
                                  // Text(
                                  //   "Hint :$hintText",
                                  //   style: rCheckpointInst,
                                  // ),
                                  Image.asset(
                                    "assets/images/rabi2.png",
                                    width: screenWidth * 0.2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                        child: Center(
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
                                //     onPressed: handleRecording,
                                //     icon: Icon(
                                //       !isrecording
                                //           ? FeatherIcons.mic
                                //           : FeatherIcons.pause,
                                //       color: Colors.white,
                                //     ),
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
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, top: 12),
                          child: Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  tts.speak(displayList[0]);
                                  setState(() {
                                    selection = displayList[0];
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.1,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                    color:
                                        selection == displayList[0]
                                            ? wordhighlight
                                            : Color.fromRGBO(
                                              166,
                                              159,
                                              204,
                                              0.31,
                                            ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      tts.speak(displayList[0]);
                                      setState(() {
                                        selection = displayList[0];
                                      });
                                    },
                                    iconSize: 32,

                                    icon: Icon(
                                      !isrecording
                                          ? FeatherIcons.volume1
                                          : FeatherIcons.volume2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  tts.speak(displayList[1]);
                                  setState(() {
                                    selection = displayList[1];
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.1,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                    color:
                                        selection == displayList[1]
                                            ? wordhighlight
                                            : Color.fromRGBO(
                                              166,
                                              159,
                                              204,
                                              0.31,
                                            ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      tts.speak(displayList[1]);
                                      setState(() {
                                        selection = displayList[1];
                                      });
                                    },
                                    iconSize: 32,

                                    icon: Icon(
                                      !isrecording
                                          ? FeatherIcons.volume1
                                          : FeatherIcons.volume2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  tts.speak(displayList[2]);
                                  setState(() {
                                    selection = displayList[2];
                                  });
                                },
                                child: Container(
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.1,
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                    color:
                                        selection == displayList[2]
                                            ? wordhighlight
                                            : Color.fromRGBO(
                                              166,
                                              159,
                                              204,
                                              0.31,
                                            ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      tts.speak(displayList[2]);
                                      setState(() {
                                        selection = displayList[2];
                                      });
                                    },
                                    iconSize: 32,

                                    icon: Icon(
                                      !isrecording
                                          ? FeatherIcons.volume1
                                          : FeatherIcons.volume2,
                                      color: Colors.white,
                                    ),
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
                              text: "Check Spelling",
                              isLoading: false,
                              onPressed: validate,
                            ),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: Text(
                            //     "Skip Word",
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
