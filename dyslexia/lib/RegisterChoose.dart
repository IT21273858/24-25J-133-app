import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/RegisterChooseParent.dart';
import 'package:dyslexia/RegisterChooseChild.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';

class RegisterChoose extends StatefulWidget {
  @override
  _RegisterChooseState createState() => _RegisterChooseState();
}

class _RegisterChooseState extends State<RegisterChoose> {
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
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(top: 60, left: 0, right: 0, bottom: 0),
              // ),
              // Image at the top
              Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/Hello-amico.png',
                  height: 311,
                  width: 311,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
              ),
              // Heading Section
              Text('Unlock a Brighter Future', style: registerheadingStyle),
              const SizedBox(height: 10),
              SizedBox(
                width: 230,
                child: Text(
                  'Create an Account Watch Progress Unfold!',
                  style: registerbodyStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
              ),
              Text("Continue As", style: registerbodyStyle),
              Padding(
                padding: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
              ),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                constraints: const BoxConstraints(
                  minHeight: 51.0,
                  minWidth: 133.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                selectedBorderColor: Colors.white,
                selectedColor: Colors.black,
                fillColor: Colors.white,
                color: appTogglebuttonColor,
                children: types,
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              // Sign In Button
              CustomButton(
                text: "Register",
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
              Padding(padding: EdgeInsets.only(top: 30)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account? ", style: bodyStyle),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: bodyStyle.copyWith(
                        color: appPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
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
