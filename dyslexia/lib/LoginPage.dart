import 'package:dyslexia/RegisterChoose.dart';
import 'package:flutter/material.dart';
import 'package:dyslexia/variables.dart';
import 'package:dyslexia/components.dart';
import 'package:dyslexia/VideoSplashScreen.dart'; // Import the video screen

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _handleSignIn() {
    setState(() {
      isLoading = true;
    });

    // Navigate to video splash screen before RegisterChoose()
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoSplashScreen(
          nextScreen:
              RegisterChoose(), // Navigate to RegisterChoose after video
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100),
                // Heading Section
                Text('Hello Again!', style: headingStyle),
                const SizedBox(height: 10),
                SizedBox(
                  width: 230,
                  child: Text(
                    'Welcome back you’ve been missed!',
                    style: bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),

                // Email Field
                CustomTextField(
                  hintText: "Enter Username",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password Field
                CustomTextField(
                  hintText: "Password",
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Recovery Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Recovery Password", style: smallTextStyle),
                ),
                const SizedBox(height: 50),

                // Sign In Button
                CustomButton(
                  text: "Sign In",
                  isLoading: isLoading,
                  onPressed: _handleSignIn,
                ),
                const SizedBox(height: 50),

                // "Or continue with" Divider
                Row(
                  children: [
                    Expanded(child: RoundedDivider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("or continue with", style: bodyStyle),
                    ),
                    Expanded(child: RoundedDivider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialLoginButton(imagePath: "assets/images/google.png"),
                    const SizedBox(width: 15),
                    SocialLoginButton(imagePath: "assets/images/apple.png"),
                    const SizedBox(width: 15),
                    SocialLoginButton(imagePath: "assets/images/meta.png"),
                  ],
                ),
                const SizedBox(height: 30),

                // Register Now Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member? ", style: bodyStyle),
                    GestureDetector(
                      onTap: _handleSignIn,
                      child: Text(
                        "Register now",
                        style: bodyStyle.copyWith(
                          color: appPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
