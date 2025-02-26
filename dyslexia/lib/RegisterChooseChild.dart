import 'package:dyslexia/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';

class RegisterChooseChild extends StatefulWidget {
  @override
  _RegisterChooseChildState createState() => _RegisterChooseChildState();
}

class _RegisterChooseChildState extends State<RegisterChooseChild> {
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
              Padding(
                padding: EdgeInsets.only(top: 60, left: 0, right: 0, bottom: 0),
              ),
              // Image at the top
              Container(
                // padding: EdgeInsets.all(2),
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
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
              ),
              // Heading Section
              Text('Create new account child', style: registerheadingStyle),
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
              CustomTextField(
                hintText: "Enter Username",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              CustomTextField(
                hintText: "Enter Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
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
