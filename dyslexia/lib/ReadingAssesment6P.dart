import 'dart:math';

import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/soundconfig.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class RhymeMatch extends StatefulWidget {
  @override
  State<RhymeMatch> createState() => _RhymeMatchState();
}

class _RhymeMatchState extends State<RhymeMatch> {
  // audio recoridnf
  final recorder = AudioRecorderService();
  TextToSpeechHelper tts = TextToSpeechHelper();
  String displayText = "_";
  String rhymics = "_";
  String selection = "_";
  List randomset = [];

  bool isrecording = false;
  bool isfetching = false;

  @override
  void initState() {
    isrecording = false;
    rhymics = "_";
    displayText = "_";
    selection = "_";
    randomset = [];
    fetchwords();
    super.initState();
  }

  Future<void> fetchwords() async {
    if (isfetching) {
      return;
    }

    setState(() {
      isfetching = true;
    });

    List rhymicspool = List.from(testRhymics);
    rhymicspool.shuffle(Random());
    Map<String, String> randomSet = rhymicspool[0];

    setState(() {
      displayText = randomSet['word']!;
      rhymics = randomSet['rhyme']!;
      List test = List.from([
        rhymics,
        randomSet['option1']!,
        randomSet['option2']!,
      ]);
      test.shuffle(Random());
      randomset = test;
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String textinstruction = "Choose the a Rhymic pronounciation";

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

    Future<void> validateSpell() async {
      if (selection == "_") {
        CustomSnakbar.showSnack(context, "Please Select a option");
        return;
      }

      if (selection == rhymics) {
        CustomSnakbar.showSnack(
          context,
          " Congratulation 🥳, You passed ",
          bgcolor: Colors.green.shade400,
          txtcolor: readingTitleColor,
        );
      } else {
        CustomSnakbar.showSnack(
          context,
          " Failed 🥺, Please Try Again",
          bgcolor: Colors.red.shade400,
        );
      }

      await fetchwords();
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
                              Text("Rhyme Match", style: rCheckpointTitle),
                              // Text("the Sound", style: rCheckpointTitle),
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
                                      Text("word", style: rCheckpointInst),
                                    ],
                                  ),
                                  Text(
                                    displayText,
                                    style: rCheckpointtxtDisplay,
                                  ),
                                  Image.asset(
                                    "assets/images/cath.png",
                                    width: screenWidth * 0.25,
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
                              Container(
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.1,
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
                                  ),
                                  color:
                                      selection == randomset[0]
                                          ? wordhighlight
                                          : Color.fromRGBO(166, 159, 204, 0.31),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    tts.speak(randomset[0]);
                                    setState(() {
                                      selection = randomset[0];
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
                              Container(
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.1,
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
                                  ),
                                  color:
                                      selection == randomset[1]
                                          ? wordhighlight
                                          : Color.fromRGBO(166, 159, 204, 0.31),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    tts.speak(randomset[1]);
                                    setState(() {
                                      selection = randomset[1];
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
                              Container(
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.1,
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
                                  ),
                                  color:
                                      selection == randomset[2]
                                          ? wordhighlight
                                          : Color.fromRGBO(166, 159, 204, 0.31),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    tts.speak(randomset[2]);
                                    setState(() {
                                      selection = randomset[2];
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
                              onPressed: validateSpell,
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
