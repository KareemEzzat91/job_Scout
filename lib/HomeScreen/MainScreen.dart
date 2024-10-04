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

  const Mainscreen({
    super.key,
  });

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  var Selectedindex = 0;
  List<Widget> Screens = [
    // Populate this with your screen widgets
    /* Center(child: Text('Home Screen'))*/
    Homescreen(), //AhmedAshraf
    JobSearchScreen(), //Farah
    const  Savedscreen(), //AhmedAshraf
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
        title: const Padding(
          padding: EdgeInsets.all(50.0),
          child: Text(
            'Job Finder',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, color: Colors.blue),
          ),
        ),
        actions: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.blue,
              )),
          const SizedBox(
            width: 18,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            UserAccountsDrawerHeader(

              currentAccountPicture: const CircleAvatar(
                backgroundImage:NetworkImage(
                    "https://th.bing.com/th/id/OIP.1cqb9FuTBVMfBMvyhRTvPwHaL1?w=124&h=199&c=7&r=0&o=5&pid=1.7"),
              ),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "Guest ",
                style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? "Guset@gmail.com",
                style:const TextStyle(fontSize: 15),
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff3c8ce7),
                    Color(0xff00eaff),
                  ],
                ),
              ),
            ),
            ListTile(
              leading:const Icon(
                Icons.person_3_outlined,
              ),
              title: const Text("Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
                leading:const Icon(Icons.notifications_active_outlined),
                title: const Text("Notifications",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                onTap: () {}),
            ListTile(
                leading:const Icon(Icons.translate),
                title: const Text("Language",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                onTap: () {}),
            ListTile(
                leading:const Icon(Icons.help_center_outlined),
                title: const Text("About",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                onTap: () {}),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    "logout",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    GoogleSignIn().disconnect();
                    FirebaseAuth.instance.signOut();
                    Hivehelper.logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => onboardingScreen()));

                  }),
            )
          ],
        ),
      ),

      //-------------------------------------
      body: Screens[Selectedindex], // Display the selected screen
      bottomNavigationBar: CurvedNavigationBar(
        index: Selectedindex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.bookmarks_outlined, size: 30),
        ],
        color: Colors.blue.withOpacity(.85),
        buttonBackgroundColor: Colors.blue[400],
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration:const Duration(milliseconds: 600),
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
