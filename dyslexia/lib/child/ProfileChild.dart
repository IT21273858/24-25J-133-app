import 'dart:convert';
import 'package:dyslexia/ScoresPage.dart';
import 'package:dyslexia/child/LearningSelectionPage.dart';
import 'package:dyslexia/parent/ParentAllGameScoresPage.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingGameSelect.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:dyslexia/services/api_service.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileChild extends StatefulWidget {
  @override
  _ProfileChildState createState() => _ProfileChildState();
}

class _ProfileChildState extends State<ProfileChild> {
  String childName = "Loading...";
  String childEmail = "Loading...";
  String childImage = "assets/images/user.png";
  String childLevel = "Loading...";
  String childAddress = "Loading...";
  List<Map<String, String>> gameScores = [];

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  /// **Load stored child data & fetch updated details from API**
  Future<void> _loadChildData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      childName = prefs.getString('child_name') ?? "Unknown";
      childEmail = prefs.getString('child_email') ?? "No Email";
      childImage = prefs.getString('child_image') ?? "assets/images/user.png";
      childLevel = prefs.getString('child_level') ?? "N/A";
      childAddress = prefs.getString('child_address') ?? "No Address";

      // Load stored game scores safely
      List<String>? storedScores = prefs.getStringList('game_scores');
      if (storedScores != null && storedScores.isNotEmpty) {
        gameScores =
            storedScores.map((score) {
              Map<String, dynamic> decoded = jsonDecode(score);

              return {
                "name": decoded["name"]?.toString() ?? "Unknown Game",
                "score": decoded["score"]?.toString() ?? "0",
                "updatedAt": decoded["updatedAt"]?.toString() ?? "N/A",
                "image": "assets/images/games_background.jpg",
                // "level": decoded["game"]["level"].toString(),
              };
            }).toList();
      } else {
        gameScores = []; // Avoid null reference error
      }
    });

    // Fetch updated data from API
    await ApiService.fetchAndStoreChildDetails();

    // Reload stored data after API call
    setState(() {
      childName = prefs.getString('child_name') ?? childName;
      childEmail = prefs.getString('child_email') ?? childEmail;
      childImage = prefs.getString('child_image') ?? childImage;
      childLevel = prefs.getString('child_level') ?? childLevel;
      childAddress = prefs.getString('child_address') ?? childAddress;

      List<String>? updatedScores = prefs.getStringList('game_scores');
      if (updatedScores != null && updatedScores.isNotEmpty) {
        gameScores =
            updatedScores.map((score) {
              Map<String, dynamic> decoded = jsonDecode(score);

              return {
                "name": decoded["name"].toString(),
                "score": decoded["score"].toString(),
                "updatedAt": decoded["updatedAt"]?.toString() ?? "N/A",
                "image": "assets/images/games_background.jpg",
                // "level": decoded["game"]["level"].toString(),
              };
            }).toList();
      } else {
        gameScores = []; // Avoid null reference error
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            // User Info Section
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            childImage.startsWith('http')
                                ? NetworkImage(childImage)
                                : AssetImage('assets/images/user.png')
                                    as ImageProvider,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // User Details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              childName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(FeatherIcons.mail, size: 20),
                                SizedBox(width: 5),
                                Text(childEmail),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(FeatherIcons.user, size: 20),
                                SizedBox(width: 5),
                                Text("Reading"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Performance Chart
            BarChartWidget(
              barGroups:
                  gameScores.map((game) {
                    return BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: double.parse(game["score"]!),
                          color: Colors.blue,
                          width: 10,
                        ),
                      ],
                    );
                  }).toList(),
              title: "Performance",
              revenue: "+12,875%",
              dropdownValue: "Game 1",
              dropdownItems: ["Game 1", "Game 2", "Game 3"],
              onDropdownChanged: (value) {},
              legendData: {"Previous Scores": 7213, "Now": 5662},
            ),
            SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScoresPage()),
                        );
                      },
                      icon: Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text("View Past Scores"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          237,
                          134,
                          230,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisualprocessingGameselect(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.gas_meter,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text("Play Games"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          237,
                          134,
                          230,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Learningselectionpage(),
                          ),
                        );
                      },
                      icon: Icon(
                        FeatherIcons.bookOpen,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text("Learn Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          237,
                          134,
                          230,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            // Child Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Games Played",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisualprocessingGameselect(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.gamepad_sharp,
                            size: 14,
                            color: appButtonColor,
                          ),
                          SizedBox(
                            width: 2,
                          ), // Add spacing between icon and text
                          Text(
                            "Play",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Game History Section
                GameCardSlider(gameData: gameScores),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
