import 'package:flutter/material.dart';
import 'package:voda/splash_screen.dart';

void main() {
  runApp(const MyApp()); // The entry point of the Flutter application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // The root widget of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vodanator', // The title of the application, used in some devices as the app name
      theme: ThemeData(
        // The theme of the application, defining the overall look and feel
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Base color scheme for the app's theme
        useMaterial3: true, // Opting in to use Material Design 3 features
      ),
      home: const SplashScreen(title: 'Vodanator Home Page'), // Setting the SplashScreen as the home page of the app
      debugShowCheckedModeBanner: false, // Disables the debug banner in the top right corner of the app
    );
  }
}
