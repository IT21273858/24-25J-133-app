import 'package:dyslexia/ReadingCheckpoint2.dart';
import 'package:dyslexia/services/ReadServices/checkPointOne.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReadCheckpointOne extends StatefulWidget {
  @override
  State<ReadCheckpointOne> createState() => _ReadCheckpointOneState();
}

class _ReadCheckpointOneState extends State<ReadCheckpointOne> {
  // audio recoridnf
  final recorder = AudioRecorderService();

  String displayText = "Bamboo";
  bool isrecording = false;
  bool isfetching = true;
  bool isvalidating = false;
  String? audiopath;

  @override
  void initState() {
    setState(() {
      isrecording = false;
    });
    assignWord();
    super.initState();
  }

  Future<void> assignWord() async {
    setState(() {
      isfetching = true;
      isvalidating = false;
      audiopath = null;
    });
    final wordfetchted = await Checkpointone.fetchWord();
    setState(() {
      displayText = wordfetchted?['word'] ?? "Text";
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String textinstruction = "press the mic icon & speak the word displayed ";

    Future<void> startRecording() async {
      await recorder.startRecording();
      setState(() {
        isrecording = true;
      });
    }

    Future<void> stopRecording() async {
      String? outputpath = await recorder.stopRecording();
      if (outputpath != null) {
        print("outputpath");
        print(outputpath);
        setState(() {
          audiopath = outputpath;
        });
      }
      setState(() {
        isrecording = false;
      });
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
                              Text("Spell the word", style: rCheckpointTitle),
                              Text("Level 1", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/test123.png",
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
                                children: [
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
                                      : Text(
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
                              text:
                                  isvalidating
                                      ? "Processing"
                                      : "Check Spelling",
                              isLoading: false,
                              onPressed: () async {
                                if (!isfetching) {
                                  if (audiopath != null) {
                                    if (isvalidating) {
                                      CustomSnakbar.showSnack(
                                        context,
                                        "Plese hold, processing previous request",
                                      );
                                      return;
                                    }

                                    setState(() {
                                      isvalidating = true;
                                    });
                                    var aresponse =
                                        await Checkpointone.getTextfromSpeech(
                                          audiopath!,
                                          displayText,
                                          "Easy",
                                        );

                                    print("aresponse");
                                    print(aresponse);

                                    if (aresponse['result']) {
                                      CustomSnakbar.showSnack(
                                        context,
                                        "😀 Correct Pronounce",
                                        bgcolor: sucess,
                                        txtcolor: readingTitleColor,
                                      );
                                      setState(() {
                                        audiopath = null;
                                        isvalidating = false;
                                      });
                                    } else {
                                      CustomSnakbar.showSnack(
                                        context,
                                        "🙀 Incorrect Pronounce, Retry...",
                                        txtcolor: Colors.white,
                                        bgcolor: Colors.deepOrange.shade400,
                                      );
                                      setState(() {
                                        audiopath = null;
                                        isvalidating = false;
                                      });
                                    }

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ReadCheckpointTwo(),
                                      ),
                                    );
                                  } else {
                                    CustomSnakbar.showSnack(
                                      context,
                                      "Please Press mic to record audio",
                                    );
                                  }
                                } else {
                                  CustomSnakbar.showSnack(
                                    context,
                                    "Finding word, Please Hold...",
                                  );
                                }
                              },
                            ),
                            TextButton(
                              onPressed: assignWord,
                              child: Text(
                                "Skip Word",
                                style: rCheckpointSkip,
                                textAlign: TextAlign.center,
                              ),
                            ),
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
