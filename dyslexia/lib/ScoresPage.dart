import 'package:dyslexia/components.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ScoresPage extends StatelessWidget {
  final List<Map<String, dynamic>> gameScores = [
    {
      "image": "assets/images/games_background.jpg",
      "name": "Game Name 1",
      "description": "Minimal descriptionaassd assddasa",
      "points": 130,
      "progress": 0.3, // 30%
    },
    {
      "image": "assets/images/games_background.jpg",
      "name": "Game Name 2",
      "description": "Minimal descriptionaassd assddasa",
      "points": 150,
      "progress": 0.5,
    },
    {
      "image": "assets/images/games_background.jpg",
      "name": "Game Name 3",
      "description": "Minimal descriptionaassd assddasa",
      "points": 170,
      "progress": 0.7,
    },
    {
      "image": "assets/images/games_background.jpg",
      "name": "Game Name 4",
      "description": "Minimal descriptionaassd assddasa",
      "points": 100,
      "progress": 0.1,
    },
    {
      "image": "assets/images/games_background.jpg",
      "name": "Game Name 5",
      "description": "Minimal descriptionaassd assddasa",
      "points": 120,
      "progress": 0.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Icon(FeatherIcons.watch, size: 24),
                    Text(
                      'Past Scores',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
              ],
            ),
            SizedBox(child: _buildPastScoresSection(context)),
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
      child: Row(
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
    );
  }

  // Past Scores Section
  Widget _buildPastScoresSection(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: SingleChildScrollView(
          child: Column(
            children:
                gameScores
                    .map(
                      (game) => GameScoreCard(
                        image: game["image"],
                        name: game["name"],
                        description: game["description"],
                        points: game["points"],
                        progress: game["progress"],
                      ),
                    )
                    .toList(),
          ),
        ),
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
