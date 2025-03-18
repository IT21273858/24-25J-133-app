import 'package:dyslexia/services/memory_service.dart';
import 'package:dyslexia/shorttermmemory/recall/Recallshape3.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class RecallShapeScreen2 extends StatefulWidget {
  @override
  _RecallShapeScreen2State createState() => _RecallShapeScreen2State();
}

class _RecallShapeScreen2State extends State<RecallShapeScreen2> {
  int _remainingSeconds = 3;
  Timer? _timer;
  String? _predictedShape;
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _fetchShapeFromAPI();
  }

  Future<void> _fetchShapeFromAPI() async {
    var response = await MemoryService.identifyShape();
    if (response != null && response['status'] == true) {
      setState(() {
        _predictedShape = response['identifiedShape']['predicted_shape'];
        _imageData = base64Decode(response['identifiedShape']['image_base64']);
        _remainingSeconds = response['identifiedShape']['hide_after'];
      });

      _startCountdown();
    }
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _navigateToNextScreen();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => RecallShape3Screen(shapeToFind: _predictedShape ?? ""),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFAF4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Recall Shape',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontFamily: 'Risque',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bunny1.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Display fetched image
                if (_imageData != null)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.memory(_imageData!, fit: BoxFit.contain),
                  )
                else
                  CircularProgressIndicator(),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '00 : ${_remainingSeconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(Icons.menu, () {}),
          CircleAvatar(
            radius: screenWidth * 0.07,
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
