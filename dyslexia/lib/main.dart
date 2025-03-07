import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dyslexia/LoginPage.dart';
import 'package:dyslexia/variables.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: VideoSplashScreen(), // Show splash screen first
    );
  }
}

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _controller =
        VideoPlayerController.asset("assets/videos/splash.mp4")
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          })
          ..setLooping(false); // Ensure video plays only once

    // Listen when the video ends
    _controller.addListener(() {
      if (_controller.value.position >=
          (_controller.value.duration - Duration(milliseconds: 500))) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ensure background remains black
      body: Stack(
        fit: StackFit.expand, // Fullscreen video
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover, // Scale video to cover entire screen
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
            ), // Show loading while initializing
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
