import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardChild extends StatefulWidget {
  @override
  _DashboardChildState createState() => _DashboardChildState();
}

class _DashboardChildState extends State<DashboardChild> {
  final List<Map<String, String>> emotions = [
    {"emoji": "😀", "label": "Happy"},
    {"emoji": "😊", "label": "Calm"},
    {"emoji": "😡", "label": "Angry"},
    {"emoji": "😢", "label": "Sad"},
    {"emoji": "😴", "label": "Tired"},
    {"emoji": "😰", "label": "Stressed"},
  ];

  String selectedEmotion = "Happy"; // Default selected emotion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            _buildHeader(context),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'How You feel about',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  maxLines: 2,
                ),
              ],
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'your',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  maxLines: 2,
                ),
              ],
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'Current emotion',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Column(
              spacing: 40,
              children: [
                _buildEmotionSelection(),
                Column(
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Text(
                          'Your Performance this week',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    _buildPerformanceSection(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Emoji Selection Widget
  Widget _buildEmotionSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Choose how you feel",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                bool isSelected = selectedEmotion == emotion["label"];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedEmotion = emotion["label"]!;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.purple.withOpacity(0.2)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            isSelected ? Colors.purple : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(emotion["emoji"]!, style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
                radius: 20,
                backgroundImage: AssetImage('assets/images/user.png'),
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
                  'Star Shangeeth',
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Game Name', style: TextStyle(color: Colors.grey)),
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
                LineChartWidget(
                  chartData: [
                    FlSpot(0, 2),
                    FlSpot(1, 3),
                    FlSpot(2, 5),
                    FlSpot(3, 4),
                    FlSpot(4, 6),
                    FlSpot(5, 4),
                  ],
                ),
              ],
            ),
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
