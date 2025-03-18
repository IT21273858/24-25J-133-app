import 'package:dyslexia/signup/RegisterChooseForChild.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';

class ReadCheckpointThreeVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String displayText = "Bamboo";
    String textinstruction = "Choose the image related to the word displayed";
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
                                        child: Image.asset(
                                          "assets/images/test123.png",
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
                                        child: Image.asset(
                                          "assets/images/test12345.png",
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
                                        child: Image.asset(
                                          "assets/images/test12345.png",
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
                                        child: Image.asset(
                                          "assets/images/test123.png",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Confirm",
                              isLoading: false,
                              onPressed: () {},
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
  // Widget _buildChildSelection() {
  //   return Container(
  //     height: 30,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: children.length,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 8.0),
  //           child: ElevatedButton(
  //             onPressed: () {},
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white,
  //               elevation: 0,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //             child: Text(
  //               children[index],
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // // Performance Section with Line Chart
  // Widget _buildPerformanceSection() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(18),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.2),
  //                 spreadRadius: 1,
  //                 blurRadius: 5,
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             spacing: 5,
  //             children: [
  //               Padding(padding: EdgeInsets.only(left: 10, right: 10)),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Statistics',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.normal,
  //                         ),
  //                       ),
  //                       Text(
  //                         'Game Name',
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       Text(
  //                         '1,027',
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         '+12.75%',
  //                         style: TextStyle(color: Colors.green, fontSize: 14),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               Padding(padding: EdgeInsets.only(top: 10)),
  //               LineChartWidget(chartData: performanceData),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // // Manage Children Section
  // Widget _buildManageChildrenSection(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Manage Children",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             IconButton(
  //               icon: Icon(
  //                 Icons.add_circle_outline,
  //                 size: 24,
  //                 color: Colors.black,
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => RegisterChooseForChild(),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 10),
  //         ChildCardSliderDashboard(
  //           childData: [
  //             {
  //               "name": "Child 1",
  //               "level": "Level 02",
  //               "lastLogged": "12 Feb 2024 - 12:30pm",
  //               "image": "assets/images/child.png",
  //             },
  //             {
  //               "name": "Child 2",
  //               "level": "Level 03",
  //               "lastLogged": "10 Feb 2024 - 11:45am",
  //               "image": "assets/images/child.png",
  //             },
  //             {
  //               "name": "Child 3",
  //               "level": "Level 01",
  //               "lastLogged": "08 Feb 2024 - 02:15pm",
  //               "image": "assets/images/child.png",
  //             },
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
