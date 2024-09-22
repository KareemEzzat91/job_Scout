import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/HomeScreen/HomeScreen.dart';
import 'package:jobscout/kconstnt/constants.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../Hivehelper.dart';
import '../onboardingScreen/onboardingScreen.dart';
import 'SavedScreen/SavedScreen.dart';
import 'SearchScreen/SearchScreen.dart';



class Mainscreen extends StatefulWidget {
  static final String routename = "Mainscreen";

  const Mainscreen({super.key,});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  var Selectedindex = 0;
  List<Widget> Screens = [
    // Populate this with your screen widgets
    /* Center(child: Text('Home Screen'))*/
    Homescreen(),//AhmedAshraf
    Searchscreen(),//Farah
    Savedscreen(),//AhmedAshraf
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kDarkColor,
          title: const Text("Welcome To JobScout"),
          actions: [
            IconButton(onPressed: (){
              GoogleSignIn().disconnect();
              Hivehelper.logout();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=> onboardingScreen()),);

            }, icon: const Icon(Icons.logout))
          ]
      ),
      body: Screens[Selectedindex], // Display the selected screen
      bottomNavigationBar: CurvedNavigationBar(
        index: Selectedindex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.save, size: 30),
        ],
        color: kPrimaryColor,
        buttonBackgroundColor: kPrimaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            Selectedindex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}


