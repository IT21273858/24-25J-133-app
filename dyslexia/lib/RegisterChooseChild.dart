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
  final TextEditingController usernameController = TextEditingController();
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
                  'assets/images/Notebook-amico.png',
                  height: 280,
                  width: 280,
                ),
              ),
              const SizedBox(height: 20),

              // Back Button + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios, size: 16),
                    color: appTextColor,
                  ),
                  Text('Continue as ', style: registerbodyStyle),
                  Text('Child', style: registerbodyboldStyle),
                ],
              ),
              const SizedBox(height: 20),

              // Heading
              Text('Create new account', style: registerheadingStyle),
              const SizedBox(height: 20),

              // Input Fields (Now inside Column)
              Column(
                children: [
                  CustomTextField(
                    hintText: "Enter Username",
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: "Enter Parent Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: "Password",
                    controller: passwordController,
                    obscureText: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Register Button
              CustomButton(
                text: "Register as Child",
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 30),

              // Login Option
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
              const SizedBox(height: 30), // Extra space for better UI
            ],
          ),
        ),
      ),
    );
  }
}
