import 'package:dyslexia/textToSpeech/TextToSpeechHelper.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:dyslexia/CustomDrawer.dart';

class Visualprocessingshapelearing extends StatefulWidget {
  @override
  State<Visualprocessingshapelearing> createState() =>
      _VisualprocessingshapelearingState();
}

class _VisualprocessingshapelearingState
    extends State<Visualprocessingshapelearing> {
  final List<Map<String, String>> shapes = [
    {"name": "Circle", "image": "assets/images/circle_practice.jpg"},
    {"name": "Square", "image": "assets/images/square_practice.jpg"},
    {"name": "Triangle", "image": "assets/images/triangle_practice.jpg"},
  ];
  final TextToSpeechHelper ttsHelper = TextToSpeechHelper(); // TTS instance
  final SwiperController swiperController =
      SwiperController(); // Swiper controller
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF0EFF4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
          ),
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Learn Shapes!", style: rCheckpointTitle),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      print(swiperController.index);
                      ttsHelper.speak(shapes[currentIndex]["name"]!);
                    },
                    child: Image.asset(
                      'assets/images/speak_word.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                  Expanded(
                    child: Swiper(
                      onIndexChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      itemCount: shapes.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  shapes[index]["image"]!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              shapes[index]["name"]!,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        );
                      },
                      autoplay: false,
                      autoplayDelay: 3000,
                      pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.grey,
                          activeColor: Colors.deepPurple,
                        ),
                      ),
                      control:
                          SwiperControl(), // Left & right navigation buttons
                      onTap: (index) {
                        ttsHelper.speak(
                          shapes[index]["name"]!,
                        ); // Speak shape name

                        print("Tapped on: ${shapes[index]['name']}");
                      },
                    ),
                  ),
                ],
              ),
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
