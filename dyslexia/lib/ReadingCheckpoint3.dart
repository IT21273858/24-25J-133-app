import 'package:dyslexia/ReadingCheckpoint3verify.dart';
import 'package:dyslexia/services/ReadServices/checkPointThree.dart';
import 'package:dyslexia/signup/RegisterChooseForChild.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';

class ReadCheckpointThree extends StatefulWidget {
  @override
  State<ReadCheckpointThree> createState() => _ReadCheckpointThreeState();
}

class _ReadCheckpointThreeState extends State<ReadCheckpointThree> {
  bool isfetching = false;
  String displayText = "Bamboo";

  @override
  void initState() {
    fetchword();
    super.initState();
  }

  Future<void> fetchword() async {
    if (isfetching) {
      CustomSnakbar.showSnack(context, "Fetching in processing");
      return;
    }

    setState(() {
      isfetching = true;
    });

    final wordresponse = await Checkpointthree.getWord(difflevl: "Easy");

    setState(() {
      displayText = wordresponse?['word'] ?? "Word";
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String textinstruction =
        "Visualize the image of the word & Keep it in mind";
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
                              Text("Comprehension", style: rCheckpointTitle),
                              Text("Level 3", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/test12345.png",
                              width: screenWidth * 0.9,
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
                                        spacing: 10,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/doglder.gif",
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
                        child: Column(
                          spacing: 9,
                          children: [
                            CustomButton(
                              text: "Procced",
                              isLoading: false,
                              onPressed: () {
                                if (isfetching) {
                                  CustomSnakbar.showSnack(
                                    context,
                                    " 🐱 Please wait until find a word",
                                  );
                                  return;
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ReadCheckpointThreeVerify(
                                          worddisplayed: displayText,
                                        ),
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              onPressed: fetchword,
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

  // // Scrollable Child Selection
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
