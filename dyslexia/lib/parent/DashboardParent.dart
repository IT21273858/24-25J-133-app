import 'package:dyslexia/signup/RegisterChooseForChild.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // Sample Data
  final List<String> children = ["Child 1", "Child 2", "Child 3", "Child 4"];
  String userName = "Loading...";
  String userImage = "assets/images/user.png"; // Default image
  String userId = "Unknown"; // Store User ID as well

  /// Fetch stored user details from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "Unknown User";
      userImage = prefs.getString('user_image') ?? "assets/images/user.png";
      userId = prefs.getString('user_id') ?? "Unknown ID"; // Fetch user_id
    });

    // Print details in the terminal
    print("=========== User Details from Storage ===========");
    print("User Name: $userName");
    print("User Image: $userImage");
    print("User ID: $userId");
    print("====================================");
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch and print user details
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
              spacing: 20,
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

  // Header Section
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
                radius: 25,
                backgroundImage:
                    userImage.startsWith('http')
                        ? NetworkImage(userImage)
                        : AssetImage(userImage) as ImageProvider,
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

  // Scrollable Child Selection
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
                children[index],
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }

  // Performance Section with Line Chart
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
              spacing: 5,
              children: [
                Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          'Game Name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
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
                Padding(padding: EdgeInsets.only(top: 10)),
                LineChartWidget(chartData: performanceData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Manage Children Section
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 24,
                  color: Colors.black,
                ),
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
            childData: [
              {
                "name": "Child 1",
                "level": "Level 02",
                "lastLogged": "12 Feb 2024 - 12:30pm",
                "image": "assets/images/child.png",
              },
              {
                "name": "Child 2",
                "level": "Level 03",
                "lastLogged": "10 Feb 2024 - 11:45am",
                "image": "assets/images/child.png",
              },
              {
                "name": "Child 3",
                "level": "Level 01",
                "lastLogged": "08 Feb 2024 - 02:15pm",
                "image": "assets/images/child.png",
              },
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
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
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
