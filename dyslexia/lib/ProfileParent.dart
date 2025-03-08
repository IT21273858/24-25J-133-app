import 'dart:convert';

import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileParent extends StatefulWidget {
  @override
  State<ProfileParent> createState() => _ProfileParentState();
}

class _ProfileParentState extends State<ProfileParent> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String userImage = "assets/images/user.png"; // Default user image
  String userPhone = "Loading...";
  String userAddress = "Loading...";
  List<Map<String, dynamic>> childrenList = []; // Store children details

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load parent data when the page is created
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await ApiService.fetchAndStoreParentDetails(); // Fetch latest details

    setState(() {
      userName = prefs.getString('parent_name') ?? "Unknown User";
      userEmail = prefs.getString('parent_email') ?? "No Email";
      userImage = prefs.getString('parent_image') ?? "assets/images/user.png";
      userPhone = prefs.getString('parent_phone') ?? "No Phone";
      userAddress = prefs.getString('parent_address') ?? "No Address";

      // Load stored children data and cast it properly
      List<String>? storedChildren = prefs.getStringList('children_list');
      if (storedChildren != null) {
        childrenList =
            storedChildren
                .map((child) => jsonDecode(child) as Map<String, dynamic>)
                .toList();
      }
    });

    // Print fetched user details for debugging
    print("=========== Parent Details from Storage ===========");
    print("Name: $userName");
    print("Email: $userEmail");
    print("Image: $userImage");
    print("Phone: $userPhone");
    print("Address: $userAddress");
    print("====================================");

    // Print children details for debugging
    print("=========== Children Details ===========");
    for (var child in childrenList) {
      print("Child Name: ${child['name']}");
      print("Child Email: ${child['email']}");
      print("Child Level: ${child['level']}");
      print("Child Image: ${child['profile_img']}");
      print("Child Address: ${child['address']}");
      print("------------------------------------");
    }
  }

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
                          backgroundImage:
                              userImage.startsWith('http')
                                  ? NetworkImage(userImage)
                                  : AssetImage(userImage) as ImageProvider,
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
                              userName,
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
                                  userEmail,
                                  style: TextStyle(color: HeadingColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

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
                            'Monitor Performance',
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
                        dropdownValue: "Child 1",
                        dropdownItems: ["Child 1", "Child 2", "Child 3"],
                        onDropdownChanged: (value) {},
                        legendData: {"Previous Scores": 7213, "Now": 5662},
                      ),
                      SizedBox(height: 20),

                      // Child Section
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Your Children",
                      //       style: TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //     SizedBox(height: 10),

                      //     // Children Cards List (Slider)
                      //     ChildCardSlider(
                      //       childData: [
                      //         {
                      //           "name": "Child 1",
                      //           "level": "Level 02",
                      //           "lastLogged": "12 Feb 2024 - 12:30pm",
                      //           "image": "assets/images/child.png",
                      //         },
                      //         {
                      //           "name": "Child 2",
                      //           "level": "Level 03",
                      //           "lastLogged": "10 Feb 2024 - 11:45am",
                      //           "image": "assets/images/child.png",
                      //         },
                      //         {
                      //           "name": "Child 3",
                      //           "level": "Level 01",
                      //           "lastLogged": "08 Feb 2024 - 02:15pm",
                      //           "image": "assets/images/child.png",
                      //         },
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Children",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Children Cards List (Slider)
                          ChildCardSlider(
                            childData:
                                childrenList.isNotEmpty
                                    ? childrenList.map((child) {
                                      return {
                                        "name":
                                            child["name"]?.toString() ??
                                            "Unknown Child",
                                        "level":
                                            child["level"]?.toString() ??
                                            "No Level",
                                        "lastLogged": "Not Available",
                                        "image":
                                            child["profile_img"]!
                                                    .toString()
                                                    .startsWith('http')
                                                ? child["profile_img"]
                                                    .toString() // Use NetworkImage
                                                : "assets/images/child.png", // Use local default image
                                      };
                                    }).toList()
                                    : [
                                      {
                                        "name": "No Children Found",
                                        "level": "",
                                        "lastLogged": "",
                                        "image": "assets/images/child.png",
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
