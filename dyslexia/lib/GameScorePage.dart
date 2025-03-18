import 'package:dyslexia/child/DashboardChild.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Gamescorepage extends StatefulWidget {
  @override
  _GameScorePage createState() => _GameScorePage();
}

class _GameScorePage extends State<Gamescorepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Fix overflow issue
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(FeatherIcons.xCircle, size: 24),
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardChild(),
                          ),
                        ),
                  ),
                ],
              ),
              Container(
                height: 350, // Reduce height to fit
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/stand.png',
                  height: 280,
                  width: 280,
                ),
              ),
              const SizedBox(height: 20),

              // Heading
              Column(
                spacing: 40,
                children: [
                  Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Congratulations', style: gamescoreHeadingStyle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              'Congratulation... You have unlocked your next level!',
                              style: gamescoresubHeadingStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Disease Selection Cards
                  Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GameScoreCardChild(
                        cardData: [
                          {"title": "Time Taken", "description": "1 Min"},
                          {"title": "Time Taken", "description": "1 Min"},
                          {"title": "Points Earned", "description": "40"},
                        ],
                        icons: [
                          FeatherIcons.clock,
                          FeatherIcons.clock,
                          FeatherIcons.bookmark,
                        ],
                      ),

                      // Register Button
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: LinearProgressIndicator(
                          value: 0.4,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.purple,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(8),
                        ).animate().flip(delay: 900.ms),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
