import 'package:dyslexia/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProfileChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            // User Info Section with Shadow & Rounded Corners
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hamburger Menu with Shadow
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomDrawer(),
                              ),
                            );
                          },
                        ),
                      ),

                      // User Icon with Shadow
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vijayathas Shangeeth',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  FeatherIcons.mail,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'star@gmail.com',
                                  style: TextStyle(color: HeadingColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  FeatherIcons.book,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Reading',
                                  style: TextStyle(color: HeadingColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  // Edit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardBackgroundcolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          minimumSize: Size(0, 20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FeatherIcons.edit,
                              size: 18,
                              color: editbuttonColor,
                            ),
                            SizedBox(width: 6),
                            Text("Edit", style: editButtontextStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Scrollable Section for "Monitor Performance" and "Your Children"
            SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  0.7, // 70% of screen height
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Performance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.speed, size: 24, color: Colors.black),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Reusable Bar Chart
                      BarChartWidget(
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: 7,
                                color: Colors.purple,
                                width: 10,
                              ),
                              BarChartRodData(
                                toY: 5,
                                color: Colors.blue,
                                width: 10,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: 6,
                                color: Colors.purple,
                                width: 10,
                              ),
                              BarChartRodData(
                                toY: 5,
                                color: Colors.blue,
                                width: 10,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: 5,
                                color: Colors.purple,
                                width: 10,
                              ),
                              BarChartRodData(
                                toY: 6,
                                color: Colors.blue,
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                        title: "Performance",
                        revenue: "+12,875%",
                        dropdownValue: "Game 1",
                        dropdownItems: ["Game 1", "Game 2", "Game 3"],
                        onDropdownChanged: (value) {},
                        legendData: {"Previous Scores": 7213, "Now": 5662},
                      ),
                      SizedBox(height: 20),

                      // Child Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Games Played",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Children Cards List (Slider)
                          GameCardSlider(
                            gameData: [
                              {
                                "name": "Game 1",
                                "level": "Level 02",
                                "points": "50",
                                "image": "assets/images/games_background.jpg",
                              },
                              {
                                "name": "Game 2",
                                "level": "Level 02",
                                "points": "120",
                                "image": "assets/images/games_background.jpg",
                              },
                              {
                                "name": "Game 3",
                                "level": "Level 03",
                                "points": "150",
                                "image": "assets/images/games_background.jpg",
                              },
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
