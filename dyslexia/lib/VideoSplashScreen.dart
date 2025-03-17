import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dyslexia/Digitspan1.dart';
import 'package:dyslexia/Digitspan2.dart';
import 'package:dyslexia/Digitspan3.dart';
import 'package:dyslexia/Digitspan4.dart';
import 'package:dyslexia/Recallshape1.dart';
import 'package:dyslexia/Recallshape2.dart';
import 'package:dyslexia/Recallshape3.dart';

class VideoSplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const VideoSplashScreen({super.key, required this.nextScreen});

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
        _navigateToRecallshape3();
        //_navigateToNextScreen();
      }
    });
  }

  void _navigateToRecallshape3() {
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(
          MaterialPageRoute(builder: (context) => RecallShape3Screen()));
    }
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
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover, // Ensures the video fills the screen
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
