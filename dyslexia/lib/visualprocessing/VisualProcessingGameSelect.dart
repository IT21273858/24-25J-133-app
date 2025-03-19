import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/visualprocessing/exam/VisualProcessingDrawShapes.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingPredictPattern.dart';
import 'package:dyslexia/visualprocessing/exam/VisualProcessingPredictPatterns.dart';
import 'package:dyslexia/visualprocessing/exam/VisualProcessingPredictShapes.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisualprocessingGameselect extends StatefulWidget {
  @override
  State<VisualprocessingGameselect> createState() =>
      _VisualprocessingGameselectState();
}

class _VisualprocessingGameselectState
    extends State<VisualprocessingGameselect> {
  int selection = -1; // Index of selected shape
  String level = "medium"; // Default level
  String uId = '';
  List<Map<String, dynamic>> games = []; // Change String to dynamic
  String? nextShape; // Stores the correct next shape

  Future<void> _loadShapeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      level = prefs.getString('level') ?? "hard";
      uId = prefs.getString('user_id') ?? '';
    });

    print("Level is $level");

    final response = await GameService.getAllGames();

    if (response != null && response["status"] == true) {
      setState(() {
        games =
            (response["games"] as List<dynamic>)
                .map<Map<String, dynamic>>(
                  (game) => {
                    "gameid": game['id'], // Keep as int (no .toString())
                    "level": game['level'] ?? "Unknown Level",
                    "name": game['name'] ?? "Unknown Game",
                    "model_type": game['model_type'] ?? "Unknown Type",
                    "shapeurl": getGameImage(game['model_type'].toString()),
                  },
                )
                .toList();
      });

      print("Pattern: $games");
    }
  }

  void _navigateToGame(BuildContext context, String modelType, String gameId) {
    if (modelType == "shape") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisualProcessingPredictShapes(gameId: gameId),
        ),
      );
    } else if (modelType == "pattern") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Visualprocessingpredictpatterns(gameId: gameId),
        ),
      );
    } else {
      print("❌ Unknown game model type: $modelType");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = Provider.of<TimerService>(context, listen: false);
      timer.resetTimer();
      timer.startTimer();
    });
    _loadShapeData();
  }

  // Function to get shape image path
  String getGameImage(String gameName) {
    switch (gameName.toLowerCase()) {
      case "shape":
        return 'assets/images/shape_gif1.gif';
      case "pattern":
        return 'assets/images/pattern_gif.gif';
      default:
        return 'assets/images/unknown.png';
    }
  }

  Future<void> handleConfirm() async {
    final timer = Provider.of<TimerService>(context, listen: false);
    timer.stopTimer();
    int totalSeconds = timer.getFormattedTimeInSeconds();

    print("Time taken: $totalSeconds seconds");

    // Validation logic
    if (selection == -1) {
      print("No shape selected");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a shape")));
      return;
    }

    String selectedShape =
        selection == 0
            ? "square"
            : selection == 1
            ? "triangle"
            : "circle";

    if (selectedShape == "shape") {
      print("✅ Correct! User selected: $selectedShape");
      final data = {
        "childId": uId,
        "gameId": null,
        "shape": selectedShape,
        "gameStatus": "won",
        "completionTime": totalSeconds,
      };
      print(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Correct! You selected $selectedShape")),
      );
    } else {
      print("❌ Wrong! Expected: $nextShape, but user selected: $selectedShape");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Wrong! Expected $nextShape")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerService>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Play Your Game", style: rCheckpointTitle),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/Shapes_gif.gif",
                              width: screenWidth * 0.5,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width:
                                double
                                    .infinity, // Makes the card take full width
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            VisualprocessingDrawshapes(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        12.0,
                                      ), // Add some padding
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.asset(
                                              'assets/images/square-loader.gif',
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Draw And Predict Shape',
                                            style: cardheadingStyle,
                                            textAlign:
                                                TextAlign
                                                    .center, // Centered text
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: Column(
                          spacing: 10,
                          children: [
                            // Display the pattern
                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents scrolling inside ListView
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 cards per row
                                    crossAxisSpacing:
                                        5, // Space between columns
                                    mainAxisSpacing: 5, // Space between rows
                                    childAspectRatio:
                                        0.9, // Controls card height
                                  ),
                              itemCount: games.length,
                              itemBuilder: (context, index) {
                                final game = games[index];
                                return GestureDetector(
                                  onTap: () {
                                    _navigateToGame(
                                      context,
                                      game['model_type'],
                                      game['gameid'],
                                    );
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: wordhighlight,
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            game['name'] ?? "Unknown Game",
                                            style: gamescardHeading,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            game['level'] ?? "Unknown Level",
                                            style: gamescardHeading,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          Image.asset(
                                            game['shapeurl'] ??
                                                "assets/images/placeholder.png",
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Shape Selection Button
  Widget shapeButton(int index, String shape, String imagePath) {
    return RawMaterialButton(
      splashColor: Colors.transparent,
      onPressed: () {
        setState(() {
          selection = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: selection == index ? Colors.deepPurple[100] : null,
        ),
        width: 69,
        height: 81,
        child: Padding(
          padding: EdgeInsets.all(selection == index ? 8.0 : 0),
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
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

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: onPressed,
    );
  }
}
