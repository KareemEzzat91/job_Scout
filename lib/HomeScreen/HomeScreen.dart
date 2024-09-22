import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/kconstnt/constants.dart';
import 'package:jobscout/onboardingScreen/onboardingScreen.dart';

class Homescreen extends StatelessWidget {
//  final User user ;
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text("Welcome To JobScout"),
      ),
      body:Center(child: TextButton(style :ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.white) ) ,onPressed: (){
        GoogleSignIn().disconnect();
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=> onboardingScreen()),
        );

      }, child: Text("Sign Out",style: GoogleFonts.agbalumo(color: Colors.red,fontSize: 60),)),)
    );
  }
}
