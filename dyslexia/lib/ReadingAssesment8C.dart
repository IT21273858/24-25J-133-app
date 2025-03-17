import 'package:dyslexia/RegisterChooseForChild.dart';
import 'package:dyslexia/serviceprovider/audio_recorder.dart';
import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class ReadnAnswer extends StatefulWidget {
  @override
  State<ReadnAnswer> createState() => _ReadnAnswerState();
}

class _ReadnAnswerState extends State<ReadnAnswer> {
  final recorder = AudioRecorderService();

  String displayText =
      " Reading a paragraph is like reading a imagination of a writer. We can immerse through the writers thought, emotion when the writer writting the para and the word that he thinks next";
  List<String> readWords = [];
  String textinstruction = "press the mic icon & speak the word displayed ";

  bool isrecording = false;

  @override
  void initState() {
    isrecording = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final timer = Provider.of<TimerService>(context);

    Future<void> startRecording() async {
      await recorder.startRecording();
      timer.startTimer();

      setState(() {
        isrecording = true;
      });
    }

    Future<void> stopRecording() async {
      String? outputpath = await recorder.stopRecording();
      timer.stopTimer();
      timer.resetTimer();
      setState(() {
        isrecording = false;
      });
      print("audio stoped");
      // print(outputpath ?? "no path");
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

    Future<void> handleReStart() async {
      //stop record here
      await stopRecording();
      // await speechHanlder.stop();
      setState(() {
        readWords = [];
      });
      timer.resetTimer();
    }

    Future<void> playWordPronunciation(String word) async {
      if (isrecording) {
        timer.stopTimer();
        // await speakWord(word);
        print("word");
        print(word);
        timer.startTimer();
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Read & Answer", style: rCheckpointTitle),
                              // Text("Word Count : 123", style: rCheckpointLv),
                            ],
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: cardBordercolor,
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(10),
                          //     ),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Row(
                          //       spacing: 3,
                          //       children: [
                          //         Icon(Icons.circle, color: Colors.white),
                          //         Text(
                          //           timer.getFormattedTime(),
                          //           style: timeClock,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17),
                                ),
                                color: Color.fromRGBO(166, 159, 204, 0.31),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children:
                                          displayText.split(" ").map((word) {
                                            bool isRead = readWords.contains(
                                              word.toLowerCase(),
                                            );
                                            return GestureDetector(
                                              onTap:
                                                  () => playWordPronunciation(
                                                    word,
                                                  ),
                                              child: Text(
                                                word,
                                                style:
                                                    isRead
                                                        ? readWordHighlighter
                                                        : rCheckpointParaDisplay,
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Center(
                      //   child: SizedBox(
                      //     width: screenWidth * 0.6,
                      //     child: Column(
                      //       spacing: 5,
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             color: pointsBackgroundColor,
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(40),
                      //             ),
                      //           ),
                      //           child: IconButton(
                      //             onPressed: handleReStart,
                      //             icon: Icon(
                      //               Icons.refresh,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //         // Text(
                      //         //   textinstruction,
                      //         //   style: rCheckpointInst,
                      //         //   textAlign: TextAlign.center,
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: Column(
                          spacing: 9,
                          children: [
                            CustomButton(
                              text: "Start Quiz",
                              isLoading: false,
                              onPressed: () {},
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Skip Paragraph",
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
