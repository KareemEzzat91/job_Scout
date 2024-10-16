import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Helpers/Hivehelper.dart';
import '../DrawerScreens/Profile/ProfileScreen.dart';
import '../onboardingScreen/IntroScreen/IntroScreen.dart';
import 'Home/HomeScreen.dart';
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
    Homescreen(), //AhmedAshraf
    JobSearchScreen(), //Farah
    const  Savedscreen(), //AhmedAshraf
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue[400]),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(50.0),
          child:    Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi ${FirebaseAuth.instance.currentUser?.displayName ?? "Guest"}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Color(0xff3c6EAE),
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    'Find Your Dream Job',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color(0xff3c6EAE),
                        fontSize: 8,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              )),
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
                backgroundImage: NetworkImage(
                    "https://th.bing.com/th/id/OIP.1cqb9FuTBVMfBMvyhRTvPwHaL1?w=124&h=199&c=7&r=0&o=5&pid=1.7"),
              ),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "Guest",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? "Guest@gmail.com",
                style: TextStyle(fontSize: 15),
              ),
              decoration: const BoxDecoration(
                image:  DecorationImage(image:AssetImage( 'assets/images/moonandstars.jpg'),opacity: 0.3,fit: BoxFit.fill),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff3c8ce7),
                    Color(0xff0C4D77),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.person_3_outlined,
              title: "Profile",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (C)=>ProfileScreen()));
                },
            ),
            _buildDrawerItem(
              icon: Icons.notifications_active_outlined,
              title: "Notifications",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.translate,
              title: "Language",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.help_center_outlined,
              title: "About",
              onTap: () {},
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _buildDrawerItem(
                icon: Icons.logout,
                title: "Logout",
                titleColor: Colors.redAccent,
                onTap: () {
                  GoogleSignIn().disconnect();
                  FirebaseAuth.instance.signOut();
                  Hivehelper.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      //-------------------------------------
      body: Screens[Selectedindex], // Display the selected screen
      bottomNavigationBar: CurvedNavigationBar(
        index: Selectedindex,
        items: const <Widget>[
          Icon(Icons.home, size: 30,color: Colors.white,),
          Icon(Icons.search, size: 30,color: Colors.white),
          Icon(Icons.bookmarks_outlined, size: 30,color: Colors.white),
        ],
        color: Colors.blue.shade700.withOpacity(.95),
        height: 57,
        buttonBackgroundColor: Colors.blue[600],

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
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    void Function()? onTap,
    Color titleColor = Colors.black,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 24, color: Colors.grey[700]),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          onTap: onTap,
        ),
        Divider(color: Colors.grey[300]), // Divider for separation
      ],
    );
  }

}
