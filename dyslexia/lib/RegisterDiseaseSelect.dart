import 'package:dyslexia/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';

class RegisterDiseaseSelect extends StatefulWidget {
  @override
  _RegisterDiseaseSelectState createState() => _RegisterDiseaseSelectState();
}

class _RegisterDiseaseSelectState extends State<RegisterDiseaseSelect> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String selectedDisease = "";

  void _handleRegister() {
    setState(() {
      isLoading = true;
    });
    // Simulate a network request
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      print("Registering with ${emailController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Fix overflow issue
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              // Image at the top
              Container(
                height: 350, // Reduce height to fit
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/curiositychild-pana.png',
                  height: 280,
                  width: 280,
                ),
              ),
              const SizedBox(height: 20),

              // Heading
              Column(
                spacing: 40,
                children: [
                  Text('Continue', style: registerheadingStyle),

                  // Disease Selection Cards
                  SelectableCardSlider(
                    cardData: [
                      {
                        "title": "Visual",
                        "description": "Visual Description",
                        "image": "assets/images/visual.png",
                      },
                      {
                        "title": "Reading",
                        "description": "Reading Description",
                        "image": "assets/images/reading.png",
                      },
                      {
                        "title": "Memory",
                        "description": "Memory Description",
                        "image": "assets/images/memory.png",
                      },
                    ],
                    onSelected: (selected) {
                      setState(() {
                        selectedDisease = selected;
                      });
                    },
                    initialSelected: "Reading",
                  ),

                  // Register Button
                  CustomButton(
                    text: "Continue as Child",
                    isLoading: isLoading,
                    onPressed: _handleRegister,
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
