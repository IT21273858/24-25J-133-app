import 'dart:math';

import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/services/ReadServices/readApi.dart';
import 'package:dyslexia/speechTotext/speech2Text.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReadPronounceWord extends StatefulWidget {
  @override
  State<ReadPronounceWord> createState() => _ReadPronounceWordState();
}

class _ReadPronounceWordState extends State<ReadPronounceWord> {
  // audio recoridnf
  // final recorder = AudioRecorderService();
  bool isInizalited = false;
  final TextToSpeechHelper tts = TextToSpeechHelper();

  Speecht2text stt = Speecht2text();
  String displayText = "Bamboo";

  bool isrecording = false;
  bool isfetching = false;
  List<String> speaks = [];

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

    List<String> difflevel = ["Easy", "Medium", "Hard"];
    difflevel.shuffle(Random());
    String levl = difflevel[0];

    setState(() {
      isfetching = true;
      speaks = [];
    });

    final response = await Readapi.fetchWord(difflevl: levl);

    if (response != null) {}

    setState(() {
      displayText = response?['word'] ?? "Text";
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String textinstruction = "press the mic icon & speak the word displayed ";

    // Future<void> startRecording() async {
    //   await recorder.startRecording();
    //   setState(() {
    //     isrecording = true;
    //   });
    // }
    Future<void> startRecording() async {
      if (!isInizalited) {
        bool istatus = await stt.initSpeech(
          onstoplisten: () {
            isrecording = false;
          },
        );
        if (istatus) {
          setState(() {
            isInizalited = true;
          });
        } else {
          return;
        }
      }

      setState(() {
        isrecording = true;
      });

      await stt.listen(
        onResult: (result) {
          print(result.recognizedWords);
          setState(() {
            speaks = result.recognizedWords.toLowerCase().trim().split(" ");
          });
        },
      );
    }

    // Future<void> stopRecording() async {
    //   String? outputpath = await recorder.stopRecording();
    //   setState(() {
    //     isrecording = false;
    //   });
    //   print("audio stoped");
    //   print(outputpath ?? "no path");
    // }

    Future<void> checkspelling() async {
      if (isrecording) {
        CustomSnakbar.showSnack(
          context,
          "Con't check spelling while Recording",
        );
        return;
      }

      if (speaks.isEmpty) {
        CustomSnakbar.showSnack(context, "Press Mic to speak");
        return;
      }

      print("speaks");
      print(speaks);
      if (speaks.contains(displayText.toLowerCase())) {
        CustomSnakbar.showSnack(context, "✅ Valid Pronounciation");
      } else {
        if (displayText.toLowerCase() == speaks.join()) {
          CustomSnakbar.showSnack(context, "✅ Valid Pronounciation");
        }
        CustomSnakbar.showSnack(context, "❌ Incorrect Pronounciation");
      }

      await fetchWord();
    }

    Future<void> stopRecording() async {
      await stt.stoplistening();

      setState(() {
        isrecording = false;
      });
      // print("audio stoped");
      // print(outputpath ?? "no path");
    }

    Future<void> handleRecording() async {
      if (isfetching) {
        CustomSnakbar.showSnack(context, "Wait till word display");
        return;
      }

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
                              Text("Repeat the Word", style: rCheckpointTitle),
                              // Text("Level 1", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/rabi.png",
                              width: screenWidth * 0.6,
                            ),
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17),
                                ),
                                color: Color.fromRGBO(166, 159, 204, 0.31),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    isfetching
                                        ? [
                                          Image.asset(
                                            "assets/images/dinowalk.gif",
                                            width: screenWidth * 0.4,
                                          ),
                                          Text(
                                            "Loading...",
                                            style: rCheckpointSkip,
                                          ),
                                        ]
                                        : [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: pointsBackgroundColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(40),
                                                ),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  tts.speak(displayText);
                                                },
                                                icon: Icon(
                                                  FeatherIcons.volume2,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            displayText,
                                            style: rCheckpointtxtDisplay,
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
                              Container(
                                decoration: BoxDecoration(
                                  color: pointsBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: handleRecording,
                                  icon: Icon(
                                    !isrecording
                                        ? FeatherIcons.mic
                                        : FeatherIcons.pause,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                isrecording ? "Recording..." : textinstruction,
                                style: rCheckpointInst,
                                textAlign: TextAlign.center,
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
                              onPressed: checkspelling,
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
