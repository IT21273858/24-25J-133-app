import 'dart:math';

import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/services/ReadServices/readApi.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ScrambleWord extends StatefulWidget {
  @override
  State<ScrambleWord> createState() => _ScrambleWordState();
}

class _ScrambleWordState extends State<ScrambleWord> {
  // audio recoridnf
  final recorder = AudioRecorderService();
  final TextToSpeechHelper tts = TextToSpeechHelper();
  bool isrecording = false;
  bool isfetching = false;

  List<String> correctWord = ['C', 'A', 'T'];
  List<String> wordscramble = ['T', 'A', 'C'];
  List<String> wordinput = [];

  int misscount = 0;

  @override
  void initState() {
    isrecording = false;
    fetchWord();
    super.initState();
  }

  Future<void> fetchWord() async {
    if (isfetching) {
      return;
    }

    List<String> difflevel = ["Easy"];
    difflevel.shuffle(Random());
    String levl = difflevel[0];

    setState(() {
      isfetching = true;
      correctWord = [];
      wordscramble = [];
      wordinput = [];
    });

    final response = await Readapi.fetchWord(difflevl: levl);

    if (response != null) {}

    setState(() {
      correctWord = response?['word'].toString().split("") ?? "Cat".split("");
      List<String> scramblehelper = List.from(correctWord);
      scramblehelper.shuffle(Random());
      wordscramble = scramblehelper;
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String textinstruction = "Drop the correct letter here";

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

    Future<void> handleWordOrder(String s) async {
      if (s.isNotEmpty) {
        int lenExist = wordinput.length;
        if (correctWord[lenExist] == s) {
          setState(() {
            // wordscramble.indexOf(s);
            wordscramble.remove(s);
            wordinput = [...wordinput, s];
            if (wordscramble.isEmpty) {
              fetchWord();
            }
          });
        } else {
          setState(() {
            misscount = misscount + 1;
          });
        }
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
                              Text("Scramble Word", style: rCheckpointTitle),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/rabi31.png",
                                      width: screenWidth * 0.3,
                                    ),
                                    Text(
                                      "press the audio",
                                      style: rCheckpointInst,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "to play again",
                                      style: rCheckpointInst,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: pointsBackgroundColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      tts.speak(correctWord.join(""));
                                    },
                                    iconSize: 42,
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Text(
                                      "Choose word here",
                                      style: rCheckpointInst,
                                    ),
                                  ),
                                  isfetching
                                      ? Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/dinowalk.gif",
                                            width: screenWidth * 0.4,
                                          ),
                                          Text(
                                            "Loading...",
                                            style: rCheckpointSkip,
                                          ),
                                        ],
                                      )
                                      : Row(
                                        spacing: 20,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            wordscramble.map((letter) {
                                              return Draggable<String>(
                                                feedback: Container(
                                                  width: screenWidth * 0.15,
                                                  height: screenHeight * 0.1,
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(17),
                                                        ),
                                                    color: Color.fromRGBO(
                                                      166,
                                                      159,
                                                      204,
                                                      0.6,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      letter,
                                                      style: cardtxtdisplay,
                                                    ),
                                                  ),
                                                ),
                                                data: letter,
                                                childWhenDragging: Container(
                                                  width: screenWidth * 0.15,
                                                  height: screenHeight * 0.1,
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(17),
                                                        ),
                                                    color: Color.fromRGBO(
                                                      166,
                                                      159,
                                                      204,
                                                      0.1,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      letter,
                                                      style: cardtxtdisplay,
                                                    ),
                                                  ),
                                                ),
                                                child: Container(
                                                  width: screenWidth * 0.15,
                                                  height: screenHeight * 0.1,
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(17),
                                                        ),
                                                    color: Color.fromRGBO(
                                                      166,
                                                      159,
                                                      204,
                                                      0.31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      letter,
                                                      style: cardtxtdisplay,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 0),
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
                          padding: const EdgeInsets.only(bottom: 12.0, top: 5),
                          child: DragTarget(
                            onAcceptWithDetails: (data) async {
                              print("data");
                              print(data.data);
                              await handleWordOrder(
                                data?.data.toString() ?? "",
                              );
                            },
                            builder: (context, acceptedItems, rejectedItems) {
                              return Container(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.1,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
                                  ),
                                  color: Color.fromRGBO(166, 159, 204, 0.31),
                                ),
                                child: Row(
                                  spacing: 5,
                                  children:
                                      wordinput.map((letter) {
                                        return Container(
                                          width: screenWidth * 0.15,
                                          height: screenHeight * 0.07,
                                          padding: const EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(17),
                                            ),
                                            color: Colors.green[200],
                                          ),
                                          child: Center(
                                            child: Text(
                                              letter,
                                              style: cardtxtValidate,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Center(
                      //   child: Column(
                      //     spacing: 9,
                      //     children: [
                      //       CustomButton(
                      //         text: "Check Spelling",
                      //         isLoading: false,
                      //         onPressed: () {},
                      //       ),

                      //       // TextButton(
                      //       //   onPressed: () {},
                      //       //   child: Text(
                      //       //     "Skip Word",
                      //       //     style: rCheckpointSkip,
                      //       //     textAlign: TextAlign.center,
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
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
