import 'package:dyslexia/serviceprovider/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/parent/DashboardParent.dart';
import 'package:dyslexia/child/DashboardChild.dart';
import 'package:dyslexia/variables.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => TimerService(), child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _startScreen;

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    print("Checking user login status...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('user_role');

    print("User role: $role");

    if (role == "parent") {
      _startScreen = VideoSplashScreen(nextScreen: DashboardParent());
    } else if (role == "child") {
      _startScreen = VideoSplashScreen(nextScreen: DashboardChild());
    } else {
      _startScreen = LoginPage();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primaryColor: appPrimaryColor,
        scaffoldBackgroundColor: appBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: _startScreen,
    );
  }
}

/// Video Splash Screen Component
class VideoSplashScreen extends StatefulWidget {
  final Widget nextScreen;

  VideoSplashScreen({required this.nextScreen});

  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _controller = VideoPlayerController.asset("assets/videos/splash.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Start video playback
      });

    // Listen for when the video ends
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => widget.nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Center(
              child: CircularProgressIndicator(),
            ), // Show loading indicator
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
