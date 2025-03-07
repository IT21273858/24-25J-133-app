import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dyslexia/LoginPage.dart';

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
    _controller = VideoPlayerController.asset("assets/videos/loading.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Listen for when the video ends
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensures full-screen coverage
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              // Makes the video fill the entire screen
              child: FittedBox(
                fit: BoxFit.cover, // Stretch to cover the entire screen
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
