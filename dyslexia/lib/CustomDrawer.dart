import 'package:dyslexia/child/DashboardChild.dart';
import 'package:dyslexia/parent/DashboardParent.dart';
import 'package:dyslexia/GameScorePage.dart';
import 'package:dyslexia/LevelUnlocker.dart';
import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/child/ProfileChild.dart';
import 'package:dyslexia/parent/ProfileParent.dart';
import 'package:dyslexia/ReadingAssesment4F.dart';
import 'package:dyslexia/ReadingAssesment5F.dart';
import 'package:dyslexia/ReadingAssesment7P.dart';
import 'package:dyslexia/ReadingAssesment8C.dart';
import 'package:dyslexia/ReadingAssesment8C2.dart';
import 'package:dyslexia/ReadingCheckpoint2.dart';
import 'package:dyslexia/ReadingCheckpoint3.dart';
import 'package:dyslexia/ScoresPage.dart';
import 'package:dyslexia/VisualProcessTest1.dart';
import 'package:dyslexia/VisualProcessingTest2.dart';
import 'package:dyslexia/parent/ParentAllGameScoresPage.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingGameSelect.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingPredictPattern.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingPredictShape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0; // Active Menu Item

  String userName = "Loading...";
  String userImage = "assets/images/user.png"; // Default image
  String userRole = "child";

  final List<Map<String, dynamic>> menuItems = [
    {"icon": FeatherIcons.home, "label": "Home", "page": DashboardParent()},
    {
      "icon": FeatherIcons.gift,
      "label": "Lessons / Games",
      "page": DashboardChild(),
    },
    {"icon": FeatherIcons.award, "label": "Profile", "page": ProfileChild()},
    {
      "icon": FeatherIcons.award,
      "label": "Profile Parent",
      "page": ProfileParent(),
    },
    {"icon": FeatherIcons.barChart2, "label": "Insights", "page": ScoresPage()},
    {
      "icon": FeatherIcons.barChart2,
      "label": "Insights_Parent",
      "page": ParentAllScoresPage(),
    },
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
    {"icon": FeatherIcons.barChart2, "label": "Assesment7", "page": Quiz()},
    {
      "icon": FeatherIcons.barChart2,
      "label": "CheckpointTwo",
      "page": ReadwithGuidance(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Checkpointhree",
      "page": ReadCheckpointThree(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Rapid words",
      "page": RapidWords(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict Shape",
      "page": VisualProcessText2(),
    },
    {
      "icon": FeatherIcons.activity,
      "label": "Select Game",
      "page": VisualprocessingGameselect(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict Shape Time",
      "page": Visualprocessingpredictshape(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict pattern Time",
      "page": Visualprocessingpredictpattern(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Predict pattern",
      "page": VisualProcessText1(),
    },
  ];

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "Unknown User";
      userImage = prefs.getString('user_image') ?? "assets/images/user.png";
      userRole = prefs.getString('user_role') ?? "Unknown Role";
    });

    // Print details in the terminal
    print("# User Details from Storage #");
    print("User Name: $userName");
    print("User Image: $userImage");
    print("#");
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clears all stored data

      print("@ User Logged Out @");
      print("Storage Cleared Successfully");
      print("@");

      // Navigate to the Login Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Removes all previous routes
      );
    } catch (e) {
      print("Error while logging out: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch and print user details
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF0EFF4), // Background Color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close Icon & Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
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
                    SizedBox(width: 16), // Left padding
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          userImage.startsWith('http')
                              ? Image.network(
                                userImage,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                userImage,
                                width: 120,
                                height: 120,
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
                              userName,
                              style: menuAppHeadingStyle,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "$userRole user",
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  isSelected
                                      ? Colors.purple.withOpacity(0.2)
                                      : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  menuItems[index]["icon"],
                                  color: menuColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  menuItems[index]["label"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
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
                  logoutUser(context);
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
