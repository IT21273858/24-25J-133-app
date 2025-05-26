import 'dart:convert';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:dyslexia/variables.dart'; // For colors and text styles

class GANShapeScreen extends StatefulWidget {
  @override
  _GANShapeScreenState createState() => _GANShapeScreenState();
}

class _GANShapeScreenState extends State<GANShapeScreen> {
  final TextToSpeechHelper ttsHelper = TextToSpeechHelper(); // TTS instance

  String? _imageBase64;
  String _selectedLabel = 'circle'; // Default label
  bool isLoading = false;

  Future<void> _generateShape() async {
    setState(() {
      isLoading = true;
    });

    final response = await GameService.generateGANShape(_selectedLabel);
    if (response != null) {
      setState(() {
        _imageBase64 = response;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Learn Shapes", style: rCheckpointTitle),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBackgroundcolor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.3,
                      child:
                          isLoading
                              ? Center(
                                child: Image.asset(
                                  './assets/images/shape_gif1.gif',
                                ),
                              )
                              : _imageBase64 != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  base64Decode(_imageBase64!),
                                  fit: BoxFit.contain,
                                ),
                              )
                              : Center(
                                child: Text(
                                  "No shape generated yet.",
                                  style: rCheckpointInst,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Select a shape to learn:",
                          style: rCheckpointInst,
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: cardBackgroundcolor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<String>(
                            value: _selectedLabel,
                            isExpanded: true,
                            underline: Container(),
                            items:
                                [
                                      'circle',
                                      'square',
                                      'triangle',
                                      'star',
                                      'airplane',
                                    ]
                                    .map(
                                      (label) => DropdownMenuItem(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: rCheckpointInst,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLabel = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            ttsHelper.speak(_selectedLabel!);
                          },
                          child: Image.asset(
                            'assets/images/speak_word.png',
                            height: 120,
                            width: 120,
                          ),
                        ),
                        isLoading
                            ? CustomButton(
                              text: "Generating...",
                              isLoading: false,
                              onPressed: _generateShape,
                            )
                            : CustomButton(
                              text: "Generate Shape",
                              isLoading: false,
                              onPressed: _generateShape,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
