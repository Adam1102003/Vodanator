import 'package:flutter/material.dart';
import 'dart:async';
import 'package:voda/Login.dart'; // Import the LoginPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});
  final String title; // Title passed to the SplashScreen

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller for image and text animations
  late Animation<double> _imageAnimation; // Animation for the image
  late Animation<double> _textAnimation; // Animation for the text

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 1 second
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation in reverse

    // Define the animation for the image, moving it horizontally back and forth
    _imageAnimation = Tween<double>(begin: -30, end: 30).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth animation curve
      ),
    );

    // Define the animation for the text, also moving it horizontally back and forth
    _textAnimation = Tween<double>(begin: -25, end: 25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth animation curve
      ),
    );

    // Navigate to the LoginPage after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload images to avoid delays during animation
    precacheImage(const AssetImage("images/Vodafone-Symbol.png"), context);
    precacheImage(const AssetImage("images/a-sleek-and-modern-splash-screen-for-the-vodanator-nXVDQv_SQaWMPwYqsDbRhw-bHlsgM83RpCweCb6t6M9Lg.jpeg"), context);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width, // Full width of the screen
          height: MediaQuery.of(context).size.height, // Full height of the screen
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover, // Background image covers the entire screen
              image: AssetImage(
                  "images/a-sleek-and-modern-splash-screen-for-the-vodanator-nXVDQv_SQaWMPwYqsDbRhw-bHlsgM83RpCweCb6t6M9Lg.jpeg"),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              // Animated image
              AnimatedBuilder(
                animation: _imageAnimation, // Animation for the image
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_imageAnimation.value, 0), // Move image horizontally
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset("images/Vodafone-Symbol.png"), // Vodafone logo
                ),
              ),
              const SizedBox(height: 20), // Spacing between the image and text
              // Animated text
              AnimatedBuilder(
                animation: _textAnimation, // Animation for the text
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_textAnimation.value, 0), // Move text horizontally
                    child: child,
                  );
                },
                child: const Text(
                  'Vodanator', // Splash screen title
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
