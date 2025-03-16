import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RapidWords extends StatefulWidget {
  @override
  State<RapidWords> createState() => _RapidWordsState();
}

class _RapidWordsState extends State<RapidWords> {
  // audio recoridnf
  // final recorder = AudioRecorderService();
  final speechtxt = SpeechToText();
  final gametime = 10; //in sec
  bool isGameStarted = false;
  bool isrecording = false;
  bool isCorrect = false;

  List<String> WordsPool = [];
  String displayText = "Bamboo";

  @override
  void initState() {
    isrecording = false;
    isGameStarted = false;
    isCorrect = false;
    initSpeech();
    super.initState();
  }

  void initSpeech() async {
    await speechtxt.initialize(
      onStatus: (status) async {
        // print("status $status");
        // print(speechtxt.isListening);

        if (status != "listening") {
          await stopRecording();
          // if (!isCorrect) startRecording();
        }
      },
      finalTimeout: Duration(seconds: 30),
      onError: (errorNotification) {
        // print("on Error");
        // print(errorNotification);
      },
    );
    setState(() {});
  }

  Future<void> startRecording() async {
    // await recorder.startRecording();
    speechtxt.listen(
      onResult: (result) async {
        bool response = result.recognizedWords
            .toLowerCase()
            .split(" ")
            .contains(displayText.toLowerCase());
        // print("result.recognizedWords");
        // print(result.recognizedWords);
        if (response) {
          print("✅");
          setState(() {
            isCorrect = true;
          });
          await stopRecording();
        } else {
          // print("not spelled");
        }
      },
      listenFor: Duration(minutes: 5),
      pauseFor: Duration(seconds: 5),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
      ),
    );
    setState(() {
      isrecording = true;
    });
  }

  Future<void> stopRecording() async {
    // String? outputpath = await recorder.stopRecording();
    speechtxt.stop();
    setState(() {
      isrecording = false;
    });
    print("audio stoped");
    // print(outputpath ?? "no path");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final timer = Provider.of<TimerService>(context);
    String textinstruction = "Press the mic to speak ";

    void gameHandler() {
      if (WordsPool.isNotEmpty) {
        setState(() {
          isCorrect = false;
          displayText = WordsPool.removeAt(0);
          timer.restartwithSeconds(gametime);
        });
      } else {
        isGameStarted = false;
        timer.stopStopWatch();
      }
    }

    Future<void> startRecording() async {
      // await recorder.startRecording();
      speechtxt.listen(
        onResult: (result) async {
          bool response = result.recognizedWords
              .toLowerCase()
              .split(" ")
              .contains(displayText.toLowerCase());
          print("result.recognizedWords");
          print(result.recognizedWords);
          if (response) {
            // print("✅");
            setState(() {
              isCorrect = true;
            });
            timer.stopTimer();
            await stopRecording();
            await Future.delayed(Duration(seconds: 2));
            gameHandler();
          } else {
            print("not spelled");
          }
        },
        listenFor: Duration(minutes: 5),
        pauseFor: Duration(seconds: 5),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
        ),
      );
      setState(() {
        isrecording = true;
      });
    }

    Future<void> handleRecording() async {
      if (!isrecording) {
        //start record here
        await startRecording();
      }
    }

    void startGame() {
      if (isGameStarted) return;
      setState(() {
        isGameStarted = true;
        WordsPool = [
          "Flower",
          "Bamboo",
          "Apple",
          "Banana",
          "Leaf",
          "Car",
          "House",
          "Shop",
          "Star",
          "Fish",
        ];
        displayText = WordsPool.removeAt(0);
      });
      timer.initStopwatch(gametime, onTimeup: gameHandler);
      timer.startStopwatch();
    }

    void stopGame() {
      setState(() {
        isGameStarted = false;
        WordsPool = [];
      });
      stopRecording();
      timer.stopStopWatch();
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
                              Text("Rapid Word", style: rCheckpointTitle),
                              // Text("Level 1", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isGameStarted
                                ? Container(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    ),
                                    color:
                                        isCorrect
                                            ? const Color.fromARGB(
                                              208,
                                              75,
                                              205,
                                              140,
                                            )
                                            : Color.fromRGBO(
                                              166,
                                              159,
                                              204,
                                              0.31,
                                            ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        displayText,
                                        style: rCheckpointtxtDisplay,
                                      ),
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
                                            onPressed: handleRecording,
                                            icon: Icon(
                                              FeatherIcons.volume2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : Text(
                                  "Find all Word to Pass the Level",
                                  style: rCheckpointInst2,
                                  textAlign: TextAlign.center,
                                ),
                            Image.asset(
                              "assets/images/beare.png",
                              width:
                                  isGameStarted
                                      ? screenWidth * 0.4
                                      : screenWidth * 0.8,
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
                              Text(
                                "Time Remaining",
                                style: rCheckpointInst,
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(166, 159, 204, 0.6),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 3,
                                    children: [
                                      Icon(
                                        FeatherIcons.clock,
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
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.6,
                          child: Column(
                            spacing: 5,
                            children:
                                isGameStarted
                                    ? [
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
                                        isrecording
                                            ? "Recording..."
                                            : textinstruction,
                                        style: rCheckpointInst,
                                        textAlign: TextAlign.center,
                                      ),
                                    ]
                                    : [],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          spacing: 9,
                          children: [
                            CustomButton(
                              text: isGameStarted ? "Stop Game" : "Start Game",
                              isLoading: false,
                              onPressed: isGameStarted ? stopGame : startGame,
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
