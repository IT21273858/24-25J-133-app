import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/RegisterChooseParent.dart';
import 'package:dyslexia/RegisterChooseChild.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class LevelUnlocker extends StatefulWidget {
  @override
  _RegisterChooseState createState() => _RegisterChooseState();
}

class _RegisterChooseState extends State<LevelUnlocker> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  List<bool> isSelected = [true, false]; // Initial selection state

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

      // Navigate based on selection
      if (isSelected[0]) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterChooseParent()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterChooseChild()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> types = <Widget>[Text('Parent'), Text('Child')];
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            spacing: 50,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(FeatherIcons.xCircle, size: 24)],
              ),
              Column(
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'New Level Unlocked',
                          style: registerNewLevelComp,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/keybro.png',
                      height: 311,
                      width: 311,
                    ),
                  ),

                  SizedBox(
                    width: 230,
                    child: Text(
                      'Congratulation... You have unlocked your next level!',
                      style: unlockPagebodyStyle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: const Text("Login"),
      ),
    );
  }
}
