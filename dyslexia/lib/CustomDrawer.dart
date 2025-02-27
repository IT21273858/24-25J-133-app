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
    {"icon": FeatherIcons.home, "label": "Home"},
    {"icon": FeatherIcons.gift, "label": "Lessons / Games"},
    {"icon": FeatherIcons.award, "label": "Profile"},
    {"icon": FeatherIcons.barChart2, "label": "Insights"},
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
                    SizedBox(width: 10), // Left padding
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

                    SizedBox(width: 12), // Spacing between image and text
                    // Name & Role (Aligned Right)
                    Expanded(
                      child: Align(
                        alignment:
                            Alignment.centerRight, // Aligns text to the right
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end, // Align text to right
                          children: [
                            Text(
                              "Navaratnam Sanjeevan",
                              style: menuAppHeadingStyle,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.right, // Align text right
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "child user",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right, // Align text right
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  // Handle logout action
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
