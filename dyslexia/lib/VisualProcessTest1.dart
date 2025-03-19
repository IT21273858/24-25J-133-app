import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';

class VisualProcessText1 extends StatefulWidget {
  @override
  State<VisualProcessText1> createState() => _VisualProcessText1State();
}

class _VisualProcessText1State extends State<VisualProcessText1> {
  int selection = -1;

  final List<Map<String, double>> sizeConfig = [
    {'count': 3, 'height': 148, 'width': 127},
    {'count': 4, 'height': 117, 'width': 100},
    {'count': 5, 'height': 92, 'width': 79},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String displayText = "Bamboo";
    String textinstruction = "choose next shape";

    List<Map<String, String>> pattern = [
      {'shape': "circle", 'shapeurl': 'assets/images/circ.png'},
      {'shape': "triangle", 'shapeurl': 'assets/images/tri.png'},
      {'shape': "circle", 'shapeurl': 'assets/images/circ.png'},
      {'shape': "triangle", 'shapeurl': 'assets/images/tri.png'},
      {'shape': "circle", 'shapeurl': 'assets/images/circ.png'},
    ];

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
                              Text("Predict Pattern", style: rCheckpointTitle),
                              // Text("Level 3", style: rCheckpointLv),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.53,
                          child: ListView.builder(
                            itemCount: pattern.length,
                            itemBuilder: (context, index) {
                              final dimentions = sizeConfig.firstWhere(
                                (element) => element['count'] == pattern.length,
                              );

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                // margin: EdgeInsets.only(bottom: 5),
                                width: dimentions['width'],
                                height: dimentions['height'],
                                child: Image.asset(pattern[index]['shapeurl']!),
                              );
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.8,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  RawMaterialButton(
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        selection = 0;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color:
                                            selection == 0
                                                ? Colors.deepPurple[100]
                                                : null,
                                      ),
                                      width: 69,
                                      height: 81,
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          selection == 0 ? 8.0 : 0,
                                        ),
                                        child: Image.asset(
                                          "assets/images/circ.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    splashColor: Colors.transparent,
                                    onPressed:
                                        () => setState(() {
                                          selection = 1;
                                        }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color:
                                            selection == 1
                                                ? Colors.deepPurple[100]
                                                : null,
                                      ),
                                      width: 69,
                                      height: 81,
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          selection == 1 ? 8.0 : 0,
                                        ),
                                        child: Image.asset(
                                          "assets/images/tri.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  RawMaterialButton(
                                    splashColor: Colors.transparent,
                                    onPressed:
                                        () => setState(() {
                                          selection = 2;
                                        }),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color:
                                            selection == 2
                                                ? Colors.deepPurple[100]
                                                : null,
                                      ),
                                      width: 69,
                                      height: 81,
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          selection == 2 ? 8.0 : 0,
                                        ),
                                        child: Image.asset(
                                          "assets/images/circ.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                        text: "Confirm",
                        isLoading: false,
                        onPressed: () {},
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
