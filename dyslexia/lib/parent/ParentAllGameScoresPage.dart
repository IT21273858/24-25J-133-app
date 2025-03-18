import 'package:dyslexia/components.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ParentAllScoresPage extends StatefulWidget {
  @override
  State<ParentAllScoresPage> createState() => _ParentAllScoresPageState();
}

class _ParentAllScoresPageState extends State<ParentAllScoresPage> {
  Map<String, List<Map<String, dynamic>>> _childScores =
      {}; // Store scores grouped by child
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    print("Navigated to Scores Page");
    super.initState();
    _fetchGameScores();
  }

  Future<void> _fetchGameScores() async {
    final response = await GameService.getScoresDetails();

    if (response != null && response['status'] == true) {
      List<dynamic>? gamesData = response['games'];

      if (gamesData != null) {
        setState(() {
          _childScores.clear();

          for (var game in gamesData) {
            String childName = game["children"]["name"] ?? "Unknown Child";
            int playedTime = int.tryParse(game["played_time"] ?? "0") ?? 0;
            int gamePlayTime =
                int.tryParse(game["game"]?["play_time"] ?? "0") ??
                1; // Avoid divide by zero

            // Calculate progress (clamped between 0.0 to 1.0)
            double progress = (gamePlayTime / playedTime).clamp(0.0, 1.0);
            Map<String, dynamic> gameData = {
              "image": "assets/images/games_background.jpg",
              "name": game["name"] ?? "Unknown Game",
              "description": game["game"]?["description"] ?? "No description",
              "points": game["score"] ?? 0,
              "played_time": "$playedTime min",
              "progress": progress,
            };

            // Group scores under each child
            if (_childScores.containsKey(childName)) {
              _childScores[childName]!.add(gameData);
            } else {
              _childScores[childName] = [gameData];
            }
          }

          _isLoading = false;
        });
      } else {
        print("Error: 'games' key is missing or null.");
        setState(() {
          _isLoading = false;
          _childScores = {};
        });
      }
    } else {
      print("Error: API response is null or status is false.");
      setState(() {
        _isLoading = false;
        _childScores = {};
      });
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
            _buildHeader(context),
            SizedBox(height: 20),
            Column(
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
            _buildPastScoresSection(context),
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

  // Past Scores Section grouped by child
  Widget _buildPastScoresSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loader while fetching
                : _childScores.isEmpty
                ? Center(
                  child: Text(
                    "No past scores found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : SingleChildScrollView(
                  child: Column(
                    children:
                        _childScores.keys.map((childName) {
                          return ExpansionTile(
                            title: Text(
                              childName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children:
                                _childScores[childName]!.map((game) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: GameScoreCard(
                                      image: game["image"],
                                      name: game["name"],
                                      description: game["description"],
                                      points: game["points"],
                                      progress: game["progress"],
                                    ),
                                  );
                                }).toList(),
                          );
                        }).toList(),
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
