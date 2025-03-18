import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:dyslexia/variables.dart';
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
  List<Map<String, String>> pattern = []; // Stores shapes from API
  String? nextShape; // Stores the correct next shape

  Future<void> _loadShapeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      level = prefs.getString('level') ?? "hard";
      uId = prefs.getString('user_id') ?? '';
    });

    print("Level is $level");

    final response = await GameService.generateShape(level);

    if (response != null && response["status"] == true) {
      setState(() {
        nextShape =
            response["patternPrediction"]["next_shape"]
                as String; // Explicit cast to String
        pattern =
            (response["patternPrediction"]["pattern"] as List<dynamic>)
                .map<Map<String, String>>(
                  (shape) => {
                    "shape": shape.toString(), // Convert dynamic to String
                    "shapeurl": getShapeImage(
                      shape.toString(),
                    ), // Ensure shape is a String
                  },
                )
                .toList();
      });

      print("Next Shape: $nextShape");
      print("Pattern: $pattern");
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
  String getShapeImage(String shapeName) {
    switch (shapeName.toLowerCase()) {
      case "circle":
        return 'assets/images/circ.png';
      case "triangle":
        return 'assets/images/tri.png';
      case "square":
        return 'assets/images/sqr.png';
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

    if (selectedShape == nextShape) {
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
                    spacing: 20,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Predict Pattern", style: rCheckpointTitle),
                        ],
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/patternprediction.png",
                              width: screenWidth * 0.9,
                            ),
                            // Container(
                            //   width: screenWidth * 0.8,
                            //   height: screenHeight * 0.25,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(
                            //       Radius.circular(17),
                            //     ),
                            //     color: Color.fromRGBO(166, 159, 204, 0.31),
                            //   ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text(
                            //         displayText,
                            //         style: rCheckpointtxtDisplay,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          spacing: 10,
                          children: [
                            // Display the pattern
                            Wrap(
                              spacing: 10,
                              children:
                                  pattern
                                      .map(
                                        (shape) => Image.asset(
                                          shape['shapeurl']!,
                                          width: 60,
                                          height: 60,
                                        ),
                                      )
                                      .toList(),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Choose the next shape",
                              style: rCheckpointInst2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                shapeButton(
                                  0,
                                  "square",
                                  "assets/images/sqr.png",
                                ),
                                shapeButton(
                                  1,
                                  "triangle",
                                  "assets/images/tri.png",
                                ),
                                shapeButton(
                                  2,
                                  "circle",
                                  "assets/images/circ.png",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: "Confirm",
                        isLoading: false,
                        onPressed: handleConfirm,
                      ),
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
