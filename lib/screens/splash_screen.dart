import 'package:flutter/material.dart';
import 'package:krishi/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krishi/screens/sign_up_screen.dart'; // Import sign-up screen
import 'package:krishi/screens/language_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: .5, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    // Check if the user is already logged in
    Future.delayed(Duration(seconds: 2), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('logged_in') ?? false;
    final User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(Duration(seconds: 3)); // Simulate splash delay

    if (user != null && isLoggedIn) {
      // ✅ Only go to MainScreen if both Firebase & SharedPreferences confirm login
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      // ✅ Ensure user sees login/signup screen
      await prefs.setBool('logged_in', false); // Reset login state properly
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
      );
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
      backgroundColor: Colors.white, // Change to match your theme
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Image.asset('assets/krishi_logo.png'),
            );
          },
        ),
      ),
    );
  }
}
