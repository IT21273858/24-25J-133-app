import 'package:flutter/material.dart';

class WordRecallTaskScreen extends StatefulWidget {
  final String? wordToShow;
  final int level; // Track level number

  const WordRecallTaskScreen({
    super.key,
    required this.wordToShow,
    required this.level,
  });

  @override
  _WordRecallTaskScreenState createState() => _WordRecallTaskScreenState();
}

class _WordRecallTaskScreenState extends State<WordRecallTaskScreen> {
  List<String> _selectedWords = [];
  List<String> _wordOptions = [];

  @override
  void initState() {
    super.initState();
    _initializeWordOptions();
  }

  // Initialize words based on level
  void _initializeWordOptions() {
    switch (widget.level) {
      case 1:
        _wordOptions = [
          'AN',
          'AT',
          'BY',
          'DO',
          'GO',
          'HE',
          'IF',
          'IN',
          'IS',
          'IT',
        ];
        break;
      case 2:
        _wordOptions = [
          'CAT',
          'DOG',
          'SUN',
          'HAT',
          'PEN',
          'CAR',
          'BAT',
          'TOP',
          'RED',
          'BOX',
        ];
        break;
      case 3:
        _wordOptions = [
          'LION',
          'FISH',
          'TREE',
          'STAR',
          'MOON',
          'BIRD',
          'WIND',
          'ROCK',
          'COLD',
        ];
        break;
      case 4:
        _wordOptions = [
          'PLANT',
          'CHAIR',
          'TABLE',
          'HORSE',
          'WATER',
          'HOUSE',
          'APPLE',
        ];
        break;
      default:
        _wordOptions = ['SCHOOL', 'GARDEN', 'MOUNTAIN', 'FLOWERS'];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: screenWidth * 0.07,
              backgroundImage: const AssetImage('assets/images/user.png'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Word Recall Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Risque',
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset('assets/images/panda.png', height: screenHeight * 0.2),
            SizedBox(height: screenHeight * 0.02),

            // Box displaying selected words
            Container(
              height: screenHeight * 0.15,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _selectedWords.isEmpty ? "---" : _selectedWords.join(', '),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _wordOptions.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedWords.add(_wordOptions[index]);
                      });
                    },
                    child: Text(
                      _wordOptions[index],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                _checkSuccess(context);
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  // Function to check if user selected the correct word
  void _checkSuccess(BuildContext context) {
    if (_selectedWords.contains(widget.wordToShow)) {
      // Move to next level
      int nextLevel = widget.level + 1;

      if (nextLevel <= 4) {
        // Ensure the next level is not beyond level 4
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => WordRecallTaskScreen(
                  wordToShow: getNextWord(nextLevel),
                  level: nextLevel,
                ),
          ),
        );
      } else {
        // Handle if all levels are completed (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Congratulations, you've completed all levels!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect! Try Again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Get next word based on level
  String getNextWord(int level) {
    List<String> words = [];
    switch (level) {
      case 1:
        words = ['AN', 'AT', 'BY', 'DO'];
        break;
      case 2:
        words = ['CAT', 'DOG', 'SUN', 'HAT'];
        break;
      case 3:
        words = ['LION', 'FISH', 'TREE', 'STAR'];
        break;
      case 4:
        words = ['PLANT', 'CHAIR', 'TABLE', 'HORSE'];
        break;
      default:
        words = ['SCHOOL', 'GARDEN', 'MOUNTAIN', 'FLOWERS'];
        break;
    }
    return words[0]; // Select first word (you can randomize this)
  }
}
