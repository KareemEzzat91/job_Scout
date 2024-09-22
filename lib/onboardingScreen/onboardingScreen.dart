import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Login&SignUp/LoginScreen.dart';
import '../kconstnt/constants.dart';

class onboardingScreen extends StatefulWidget {
   onboardingScreen({super.key});

  @override
  State<onboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<onboardingScreen>
    with SingleTickerProviderStateMixin {
  List<String> images = [
    "assets/images/pixlr-image-generator-332b71e9-2849-41af-a6a3-b9d94264c8e6.png",
    "assets/images/preview.webp",
    "assets/images/pixlr-image-generator-6223adde-4622-45fb-9f1f-8cb8052bf609.png"
  ];
  bool isUserSignedIn = false;
  List<String> texts = [
    "Welcome to JobScout! Discover your dream job effortlessly.",
    "Explore thousands of job listings tailored to your skills and preferences.",
    "Join our community and take the first step towards your ideal career!"
  ];
  int index = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isUserSignedIn = false;
      } else {
        print('User is signed in!');
        isUserSignedIn = true;
      }
    });

    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    setState(() {
      index++;
      if (index == 3 )
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginscreen()),
          );

        }
      index = index % 3;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[index],
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),

          Center(
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                texts[index],
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black38,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Positioned(
            bottom: height * 0.20,
            left: width * 0.275,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                "assets/images/photo_2024-09-16_15-28-23-removebg-preview.png",
                fit: BoxFit.cover,
                width: width * 0.45,
              ),
            ),
          ),

          // Navigation button
          Positioned(
            top: height * 0.85,
            right: width * 0.36,
            child: Container(
              width: 120,
              height: 50,
              child: TextButton(
                onPressed: _nextPage,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.cyan),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: Text(
                  "${(index + 1).toString()}/3",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
