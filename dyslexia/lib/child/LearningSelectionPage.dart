import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/VisualProcessTest1.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingPredictPattern.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingDrawShapeLearning.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingPredictShapesLearning.dart';
import 'package:dyslexia/visualprocessing/practice/VisualProcessingShapeLearing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Learningselectionpage extends StatelessWidget {
  final List<Map<String, dynamic>> learningOptions = [
    {
      "title": "Pattern Learning",
      "image": "assets/images/pattern_gif.gif",
      "page": Visualprocessingshapelearing(),
    },
    {
      "title": "Draw And Learn",
      "image": "assets/images/Shapes_gif.gif",
      "page": VisualprocessingDrawshapeLearning(),
    },
    {
      "title": "Find Shape",
      "image": "assets/images/Shapes_gif.gif",
      "page": VisualProcessingPredictShapesLearning(),
    },
    {
      "title": "Pattern Next",
      "image": "assets/images/square-loader.gif",
      "page": Visualprocessingpredictpattern(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
          ),
          _buildHeader(context),
          SizedBox(height: 10),
          Text("Learn Shapes!", style: rCheckpointTitle),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85, // Controls card height ratio
              ),
              itemCount: learningOptions.length,
              itemBuilder: (context, index) {
                final option = learningOptions[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => option["page"]),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            option["image"],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(option["title"], style: cardheadingStyle),
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
            radius: 22,
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
