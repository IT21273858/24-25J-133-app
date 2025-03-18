import 'package:dyslexia/GameScorePage.dart';
import 'package:dyslexia/LevelUnlocker.dart';
import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/ReadingAssesment1.dart';
import 'package:dyslexia/ScoresPage.dart';
import 'package:dyslexia/VisualProcessTest1.dart';
import 'package:dyslexia/VisualProcessingTest2.dart';
import 'package:dyslexia/shorttermmemory/digitspan/Digitspan1.dart';
import 'package:dyslexia/shorttermmemory/recall/Recallshape1.dart';
import 'package:dyslexia/shorttermmemory/wordrecall/Wordrecall1.dart';
import 'package:dyslexia/child/DashboardChild.dart';
import 'package:dyslexia/child/ProfileChild.dart';
import 'package:dyslexia/parent/DashboardParent.dart';
import 'package:dyslexia/parent/ParentAllGameScoresPage.dart';
import 'package:dyslexia/parent/ProfileParent.dart';
import 'package:dyslexia/shorttermmemory/wordsrecall/WordRecallScreen1.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingGameSelect.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingPredictPattern.dart';
import 'package:dyslexia/visualprocessing/VisualProcessingDrawShape.dart';
import 'package:dyslexia/visualprocessing/exam/VisualProcessingDrawShapes.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingDrawShapeLearning.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingShapeLearing.dart';
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
  String userRole = "child"; // Default role

  final List<Map<String, dynamic>> parentMenuItems = [
    {"icon": FeatherIcons.home, "label": "Home", "page": DashboardParent()},
    {"icon": FeatherIcons.award, "label": "Profile", "page": ProfileParent()},
    {
      "icon": FeatherIcons.barChart2,
      "label": "Insights",
      "page": ParentAllScoresPage(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Game Score",
      "page": Gamescorepage(),
    },
    {
      "icon": FeatherIcons.barChart2,
      "label": "Level Unlock",
      "page": LevelUnlocker(),
    },
  ];

  final List<Map<String, dynamic>> childMenuItems = [
    {"icon": FeatherIcons.home, "label": "Home", "page": DashboardChild()},
    {
      "icon": FeatherIcons.gift,
      "label": "Lessons / Games",
      "page": DashboardChild(),
    },
    {"icon": FeatherIcons.award, "label": "Profile", "page": ProfileChild()},
    {"icon": FeatherIcons.barChart2, "label": "Insights", "page": ScoresPage()},
    {
      "icon": FeatherIcons.barChart2,
      "label": "Checkpoint",
      "page": ReadPronounceWord(),
    },
    {
      "icon": FeatherIcons.bookOpen,
      "label": "Learn Shape",
      "page": Visualprocessingshapelearing(),
    },
    {
      "icon": FeatherIcons.bookOpen,
      "label": "Learn to Draw Shape",
      "page": VisualprocessingDrawshapeLearning(),
    },
    {
      "icon": FeatherIcons.activity,
      "label": "Select Game",
      "page": VisualprocessingGameselect(),
    },
    {
      "icon": FeatherIcons.disc,
      "label": "Word Recall",
      "page": WordRecallTaskScreen(),
    },
    {
      "icon": FeatherIcons.disc,
      "label": "Digits Recall",
      "page": DigitSpanTaskScreen(),
    },
    {
      "icon": FeatherIcons.disc,
      "label": "Shape Recall",
      "page": RecallShape1Screen(),
    },
  ];

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "Unknown User";
      userImage = prefs.getString('user_image') ?? "assets/images/user.png";
      userRole = prefs.getString('user_role') ?? "unknown"; // Ensure lower case
    });

    print("# User Details #");
    print("User Name: $userName");
    print("User Image: $userImage");
    print("User Role: $userRole");
    print("#");
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clears all stored data

      print("@ User Logged Out @");
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
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // **Filter menu based on userRole**
    List<Map<String, dynamic>> menuItems =
        userRole == "parent" ? parentMenuItems : childMenuItems;

    return Drawer(
      backgroundColor: Color(0xFFF0EFF4), // Background Color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // **Header Section**
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("App Logo", style: menuAppLogoStyle),
                IconButton(
                  icon: Icon(Icons.close, color: appPrimaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // **Profile Section**
          Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 40)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 16), // Left padding
                    // **Profile Image**
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
                    // **Name & Role**
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
                              userRole == "parent"
                                  ? "Parent User"
                                  : "Child User",
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

          // **Menu Title**
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

          // **Menu Items**
          Container(
            height: screenHeight * 0.5,
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

                            // Navigate to the selected page
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

          Spacer(),

          // **Logout Button**
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: ElevatedButton(
              onPressed: () => logoutUser(context),
              child: Text("Logout", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
