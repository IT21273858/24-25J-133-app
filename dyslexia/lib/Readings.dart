import 'package:dyslexia/ReadingAssesment1.dart';
import 'package:dyslexia/ReadingAssesment2.dart';
import 'package:dyslexia/ReadingAssesment3.dart';
import 'package:dyslexia/ReadingAssesment5F.dart';
import 'package:dyslexia/ReadingAssesment6P.dart';
import 'package:dyslexia/ReadingAssesment7P.dart';
import 'package:dyslexia/ReadingCheckpoint1.dart';
import 'package:dyslexia/ReadingCheckpoint2.dart';
import 'package:dyslexia/ReadingCheckpoint3.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/services/game_service.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/CustomDrawer.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ReadingPage extends StatefulWidget {
  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  List<Map<String, dynamic>> _gameScores = []; // Store fetched scores
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    print("Income to Scores page");
    super.initState();
  }

  List ReadingComps = [
    {
      "title": "Write Sound",
      "descr": "WriteSound - Phe",
      "img": "assets/images/cath.png",
      "Nav": WriteSound(),
    },
    {
      "title": "Spell The Word",
      "descr": "Checkpoint 1",
      "img": "assets/images/rabi3.png",
      "Nav": ReadCheckpointOne(),
    },
    {
      "title": "Read Passage - FLuency",
      "descr": "Checkpoint 2",
      "img": "assets/images/beec.png",
      "Nav": ReadCheckpointTwo(),
    },
    {
      "title": "Comprehention - Image",
      "descr": "Checkpoint 3",
      "img": "assets/images/teddy.png",
      "Nav": ReadCheckpointThree(),
    },
    {
      "title": "Read Pronounce Word",
      "descr": "Read Pronounce Word",
      "img": "assets/images/rabi3.png",
      "Nav": ReadPronounceWord(),
    },
    // {
    //   "title": "Understand Sound",
    //   "descr": "UnderstandSound",
    //   "img": "assets/images/beare.png",
    //   "Nav": UnderstandSound(),
    // },
    {
      "title": "Scramble Word",
      "descr": "Scramble Word",
      "img": "assets/images/beec.png",
      "Nav": ScrambleWord(),
    },
    // {
    //   "title": "Rapid Words",
    //   "descr": "RapidWords - F",
    //   "img": "assets/images/teddy.png",
    //   "Nav": RapidWords(),
    // },
    {
      "title": "Rhyme Match",
      "descr": "Rhyme Match - p",
      "img": "assets/images/rabi3.png",
      "Nav": RhymeMatch(),
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
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Icon(FeatherIcons.watch, size: 24),
                    Text(
                      'Reading Games',
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: SingleChildScrollView(
          child: Column(
            children:
                ReadingComps.map(
                  (game) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => game['Nav']),
                      );
                    },
                    child: ReadingCards(
                      image: game["img"],
                      name: game["title"],
                      description: game["descr"],
                      points: 0,
                      progress: screenHeight * 0.15,
                    ),
                  ),
                ).toList(),
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
