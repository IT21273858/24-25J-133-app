import 'dart:convert';
import 'dart:math';

import 'package:dyslexia/services/ReadServices/checkPointThree.dart';
import 'package:dyslexia/signup/RegisterChooseForChild.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';

class ReadCheckpointThreeVerify extends StatefulWidget {
  final String worddisplayed;

  const ReadCheckpointThreeVerify({super.key, required this.worddisplayed});

  @override
  State<ReadCheckpointThreeVerify> createState() =>
      _ReadCheckpointThreeVerifyState();
}

class _ReadCheckpointThreeVerifyState extends State<ReadCheckpointThreeVerify> {
  bool isfetching = false;
  List<dynamic> options = [];
  dynamic selection;

  @override
  void initState() {
    setState(() {
      isfetching = false;
      selection = null;
    });
    fetchImages();
    super.initState();
  }

  Future<void> fetchImages() async {
    if (isfetching) {
      return;
    }

    setState(() {
      isfetching = true;
    });

    final imaglist = await Checkpointthree.getImages(
      prompt: widget.worddisplayed,
    );

    if (imaglist != null) {
      final imgs = imaglist['Images'];
      final correct = imgs[0];
      imgs!.shuffle(Random());
      setState(() {
        options = imgs;
        selection = correct;
      });
    }

    setState(() {
      isfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String textinstruction =
        isfetching
            ? "Please wait till the image loads"
            : "Choose the image related to the word displayed";
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
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 40,
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Column(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: cardBackgroundcolor,
                                        ),
                                        width: 161,
                                        height: 188,
                                        child:
                                            isfetching || options.isEmpty
                                                ? Image.asset(
                                                  "assets/images/gogflat.gif",
                                                )
                                                : Image.memory(
                                                  base64Decode(
                                                    options[0]?['dataimg'],
                                                  ),
                                                ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: cardBackgroundcolor,
                                        ),
                                        width: 161,
                                        height: 188,
                                        child:
                                            isfetching || options.isEmpty
                                                ? Image.asset(
                                                  "assets/images/gogflat.gif",
                                                )
                                                : Image.memory(
                                                  base64Decode(
                                                    options[1]?['dataimg'],
                                                  ),
                                                ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: cardBackgroundcolor,
                                        ),
                                        width: 161,
                                        height: 188,
                                        child:
                                            isfetching || options.isEmpty
                                                ? Image.asset(
                                                  "assets/images/gogflat.gif",
                                                )
                                                : Image.memory(
                                                  base64Decode(
                                                    options[2]?['dataimg'],
                                                  ),
                                                ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: cardBackgroundcolor,
                                        ),
                                        width: 161,
                                        height: 188,
                                        child:
                                            isfetching || options.isEmpty
                                                ? Image.asset(
                                                  "assets/images/gogflat.gif",
                                                )
                                                : Image.memory(
                                                  base64Decode(
                                                    options[3]?['dataimg'],
                                                  ),
                                                ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text:
                                  isfetching
                                      ? "Creating Wonders,wait..."
                                      : "Confirm",
                              isLoading: false,
                              onPressed: fetchImages,
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
