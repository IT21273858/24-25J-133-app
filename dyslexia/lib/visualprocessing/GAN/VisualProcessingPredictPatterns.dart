import 'package:flutter/material.dart';
import 'package:dyslexia/services/game_service.dart';

class VisualProcessingPredictPatterns extends StatefulWidget {
  final String gameId;
  VisualProcessingPredictPatterns({required this.gameId});

  @override
  State<VisualProcessingPredictPatterns> createState() =>
      _VisualProcessingPredictPatternsState();
}

class _VisualProcessingPredictPatternsState
    extends State<VisualProcessingPredictPatterns> {
  String? nextShape;
  List<String> pattern = [];
  bool isLoading = false;

  Future<void> getPatternPrediction(String level) async {
    setState(() {
      isLoading = true;
      pattern = [];
      nextShape = null;
    });

    final response = await GameService.generateShape(level);

    if (response != null && response['patternPrediction'] != null) {
      setState(() {
        pattern = List<String>.from(response['patternPrediction']['pattern']);
        nextShape = response['patternPrediction']['next_shape'];
        isLoading = false;
      });
    } else {
      setState(() {
        nextShape = "Error fetching pattern";
        isLoading = false;
      });
    }
  }

  Widget buildShapeIcon(String shape) {
    String assetPath;
    switch (shape.toLowerCase()) {
      case 'circle':
        assetPath = 'assets/images/circ.png';
        break;
      case 'square':
        assetPath = 'assets/images/sqr.png';
        break;
      case 'triangle':
        assetPath = 'assets/images/tri.png';
        break;
      default:
        assetPath = 'assets/images/unknown.png';
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(assetPath, width: 50, height: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Predict Patterns")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) CircularProgressIndicator(),
              if (!isLoading && pattern.isNotEmpty)
                Column(
                  children: [
                    Text("Generated Pattern:", style: TextStyle(fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pattern.map((s) => buildShapeIcon(s)).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Predicted Next Shape: ${nextShape ?? ''}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30),
              Text("Select Difficulty:", style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => getPatternPrediction("easy"),
                    child: Text("Easy"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => getPatternPrediction("medium"),
                    child: Text("Medium"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => getPatternPrediction("hard"),
                    child: Text("Hard"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
