import 'dart:convert';

import 'package:dyslexia/signup/RegisterChooseForChild.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyslexia/services/api_service.dart';

class DashboardParent extends StatefulWidget {
  @override
  State<DashboardParent> createState() => _DashboardParentState();
}

class _DashboardParentState extends State<DashboardParent> {
  final List<FlSpot> performanceData = [
    FlSpot(0, 2),
    FlSpot(1, 3),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 6),
    FlSpot(5, 4),
  ];

  // Store fetched data
  String userName = "Loading...";
  String userImage = "assets/images/user.png";
  String userId = "Unknown";
  List<Map<String, dynamic>> children = [];

  /// Fetch Parent and Child Data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('parent_name') ?? "Unknown User";
      userImage = prefs.getString('parent_image') ?? "assets/images/user.png";
      userId = prefs.getString('user_id') ?? "Unknown ID";
    });

    // Fetch Parent & Child Details from API
    final parentData = await ApiService.fetchParentById();
    if (parentData != null) {
      List<String>? storedChildren = prefs.getStringList('children_list');

      if (storedChildren != null) {
        setState(() {
          children =
              storedChildren.map((child) {
                return Map<String, dynamic>.from(jsonDecode(child));
              }).toList();
        });

        print("((((((Child details))))))");
        print(children);
      }
    }

    print("✅ User & Children Data Loaded");
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            Column(
              spacing: 5,
              children: [
                _buildHeader(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Your Child Performance this week',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                  ],
                ),
                _buildChildSelection(),
                _buildPerformanceSection(),
                _buildManageChildrenSection(context),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // **Header Section**
  Widget _buildHeader(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.all(10),
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
                radius: 25,
                backgroundImage:
                    userImage.startsWith('http')
                        ? NetworkImage(userImage)
                        : AssetImage('assets/images/user.png'),
                onBackgroundImageError: (_, __) {
                  setState(() {
                    userImage = "assets/images/user.png";
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // **Scrollable Child Selection**
  Widget _buildChildSelection() {
    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                children[index]["name"] ?? "Child ${index + 1}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }

  // **Performance Section with Line Chart**
  Widget _buildPerformanceSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statistics', style: TextStyle(fontSize: 18)),
                        Text(
                          'Game Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '1,027',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+12.75%',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                LineChartWidget(chartData: performanceData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // **Manage Children Section**
  Widget _buildManageChildrenSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Manage Children",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterChooseForChild(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          ChildCardSliderDashboard(
            childData:
                children.map((child) {
                  return {
                    "name": child["name"]?.toString() ?? "Unknown",
                    "level": child["level"]?.toString() ?? "N/A",
                    "lastLogged": child["updatedAt"]?.toString() ?? "No Data",
                    "image":
                        child["profile_img"] != null &&
                                child["profile_img"].toString().startsWith(
                                  "http",
                                )
                            ? child["profile_img"].toString()
                            : "assets/images/user.png",
                  };
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
