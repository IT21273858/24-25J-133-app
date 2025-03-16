import 'package:dyslexia/DashboardChild.dart';
import 'package:dyslexia/DashboardParent.dart';
import 'package:dyslexia/GameScorePage.dart';
import 'package:dyslexia/LevelUnlocker.dart';
import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/ProfileChild.dart';
import 'package:dyslexia/ReadingAssesment5F.dart';
import 'package:dyslexia/ReadingAssesment6P.dart';
import 'package:dyslexia/ReadingAssesment7P.dart';
import 'package:dyslexia/ReadingCheckpoint2.dart';
import 'package:dyslexia/ReadingCheckpoint3.dart';
import 'package:dyslexia/ScoresPage.dart';
import 'package:dyslexia/VisualProcessTest1.dart';
import 'package:dyslexia/VisualProcessingTest2.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0; // Active Menu Item

  final List<Map<String, dynamic>> menuItems = [
    {"icon": FeatherIcons.home, "label": "Home", "page": DashboardParent()},
    {
      "icon": FeatherIcons.gift,
      "label": "Lessons / Games",
      "page": DashboardChild(),
    },
    {"icon": FeatherIcons.award, "label": "Profile", "page": ProfileChild()},
    {"icon": FeatherIcons.barChart2, "label": "Insights", "page": ScoresPage()},
    {
      "icon": FeatherIcons.barChart2,
      "label": "LevelUnlock",
      "page": LevelUnlocker(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Game Score",
      "page": Gamescorepage(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Assesment7",
      "page": WriteSound(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "CheckpointTwo",
      "page": ReadCheckpointTwo(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Checkpointhree",
      "page": ReadCheckpointThree(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict Shape",
      "page": VisualProcessText2(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict pattern",
      "page": VisualProcessText1(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF0EFF4), // Background Color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close Icon & Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Applogo", style: menuAppLogoStyle),
                IconButton(
                  icon: Icon(Icons.close, color: appPrimaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Profile Section
          Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 40)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 5), // Left padding
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/images/menu_user.png",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Name & Role (Aligned Right)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Navaratnam Sanjeevan",
                              style: menuAppHeadingStyle,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "child user",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Menu Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: menuColor,
              ),
            ),
          ),

          SizedBox(height: 10),

          // Menu Items
          Column(
            children: List.generate(menuItems.length, (index) {
              bool isSelected = index == selectedIndex;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });

                    // Navigate using MaterialPageRoute
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => menuItems[index]["page"],
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          isSelected
                              ? Colors.purple.withOpacity(0.2)
                              : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(menuItems[index]["icon"], color: menuColor),
                        SizedBox(width: 10),
                        Text(
                          menuItems[index]["label"],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          Spacer(), // Push Logout to Bottom
          // Logout Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to login page using MaterialPageRoute
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(color: menuColor, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
