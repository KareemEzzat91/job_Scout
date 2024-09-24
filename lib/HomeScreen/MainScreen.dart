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
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue[400]),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(
            'Job Finder',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,color: Colors.blue),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://th.bing.com/th/id/OIP.1cqb9FuTBVMfBMvyhRTvPwHaL1?w=124&h=199&c=7&r=0&o=5&pid=1.7"),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff2CAEE2),
                ),
                accountName: Text("Ahmed Ashraf"),
                accountEmail: Text("ahmedashraf417@gmail.com")),
            ListTile(
              leading: Icon(Icons.person_3_outlined),
              title: Text("Profile"),
              onTap: () {},
            ),
            ListTile(
                leading: Icon(Icons.notifications_active_outlined),
                title: Text("Notifications"),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.translate),
                title: Text("Language"),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.help_center_outlined),
                title: Text("About"),
                onTap: () {}),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    "logout",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {}),
            )
          ],
        ),
      ),
      body: Screens[Selectedindex], // Display the selected screen
      bottomNavigationBar: CurvedNavigationBar(
        index: Selectedindex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.save, size: 30),
        ],
        color: Colors.blue.withOpacity(.85),
        buttonBackgroundColor: Colors.blue[400],
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


