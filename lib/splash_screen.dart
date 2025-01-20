// splash_screen.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _needsUserInteraction = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/splash_video.mp4');

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });

        if (kIsWeb) {
          // On web, we need user interaction
          setState(() {
            _needsUserInteraction = true;
          });
        } else {
          // On mobile, play directly
          _playAndNavigate();
        }
      }
    } catch (e) {
      developer.log('Error initializing video: $e');
      _navigateToLogin();
    }
  }

  void _playAndNavigate() async {
    try {
      await _controller.play();
      // Wait for video duration or 4 seconds, whichever is shorter
      await Future.delayed(Duration(
          milliseconds:
              math.min(_controller.value.duration.inMilliseconds, 4000)));
      if (mounted) {
        _navigateToLogin();
      }
    } catch (e) {
      developer.log('Error playing video: $e');
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _handleTap() {
    if (_needsUserInteraction && _isVideoInitialized) {
      setState(() {
        _needsUserInteraction = false;
      });
      _playAndNavigate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _handleTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isVideoInitialized) ...[
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ],
            if (_needsUserInteraction) ...[
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Text(
                    'Tap anywhere to continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else if (!_isVideoInitialized) ...[
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
