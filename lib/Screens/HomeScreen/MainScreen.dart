import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Helpers/Hivehelper.dart';
import '../../Helpers/responsive/responsive.dart';
import '../../Helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import '../DrawerScreens/About/AboutScreen.dart';
import '../DrawerScreens/Notofication/Notofication.dart';
import '../DrawerScreens/Profile/ProfileScreen.dart';
import '../onboardingScreen/IntroScreen/IntroScreen.dart';
import 'Home/HomeScreen.dart';
import 'SavedScreen/SavedScreen.dart';
import 'SearchScreen/SearchScreen.dart';

class Mainscreen extends StatefulWidget {
  static const String routename = "Mainscreen";

  const Mainscreen({
    super.key,
  });

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  var Selectedindex = 0;
  List<Widget> Screens = [
    HomeScreen(), //AhmedAshraf
    const JobSearchScreen(), //Farah
    const  SavedScreen(), //AhmedAshraf
  ];

  @override
  Widget build(BuildContext context) {
    final iSDarkMode = Theme.of(context).brightness ==Brightness.dark;
    final bloc = context.read<ThemesCubit>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blue[400]),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(50.0),
          child:    Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi ${FirebaseAuth.instance.currentUser?.displayName ?? "Guest"}",
                    textAlign: TextAlign.start,
                    style:  TextStyle(
                        color: const Color(0xff3c6EAE),
                        fontStyle: FontStyle.italic,
                        fontSize: Responsive.TextSize(context,isExtraSmallSize:11,isMobileSize: 13,isMobileLarge:16,isIpadSize: 28,isTabletSize: 30,isLargeTabletSize: 30,defaultSize: 20  ),
                        fontWeight: FontWeight.w900),
                  ),
                   Text(
                    'Find Your Dream Job',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: const Color(0xff3c6EAE),
                        fontSize:Responsive.TextSize(context,isExtraSmallSize:7,isMobileSize: 8,isMobileLarge:10,isIpadSize: 15,isTabletSize:18,isLargeTabletSize: 20,defaultSize: 20  ),
                        fontWeight: FontWeight.w900),
                  ),
                ],
              )),
        ),
        actions: [
            GestureDetector(
              onTap: () {
                bloc.toggleTheme(!iSDarkMode);
              },
              child: Icon(iSDarkMode?
                Icons.nightlight_round_sharp:Icons.sunny,
                color: iSDarkMode?Colors.blue:Colors.orange,
                size: Responsive.TextSize(context,isExtraSmallSize:20,isMobileSize: 24,isMobileLarge:26,isIpadSize: 50,isTabletSize: 60,isLargeTabletSize: 70,defaultSize: 20  ),
              )),
          const SizedBox(
            width: 18,
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: iSDarkMode?Colors.black:Colors.white,
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? "Guest@gmail.com",
                style: const TextStyle(fontSize: 15),
              ),
              decoration: BoxDecoration(
                image:  DecorationImage(image:AssetImage( iSDarkMode?'assets/images/moonandstars.jpg':"assets/images/sunBackgrond.jpg"),opacity: 0.3,fit: BoxFit.fill),
                gradient: const LinearGradient(
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
                titleColor: iSDarkMode ?Colors.white:Colors.black

            ),
            _buildDrawerItem(
              icon: Icons.notifications_active_outlined,
              title: "Notifications",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> Notofication ()));
              },
                titleColor: iSDarkMode ?Colors.white:Colors.black

            ),
            _buildDrawerItem(//
              icon: Icons.help_center_outlined,
              title: "About",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> AboutScreen ()));
                },
                titleColor: iSDarkMode ?Colors.white:Colors.black

            ),
            const Spacer(),
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
                      builder: (context) => const IntroScreen(),
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
        color: iSDarkMode? Colors.blue.shade900.withOpacity(.40):Colors.blue.shade700.withOpacity(.95),
        height: 57,
        buttonBackgroundColor:iSDarkMode? Colors.blue[800]:Colors.blue[600],

        backgroundColor:iSDarkMode? Colors.black:Colors.white,
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
