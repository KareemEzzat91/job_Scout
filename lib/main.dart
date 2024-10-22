import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'Helpers/APIHelper/Apihelper.dart';
import 'Helpers/FireStoreHelper/FireStoreHelper.dart';
import 'Helpers/theme/DarkTheme/ThemeCubit/themes_cubit.dart';
import 'Helpers/Hivehelper.dart';

import 'Screens/Firebasenotofication/Notofication.dart';
import 'Screens/Firebasenotofication/NotoficationScreen.dart';
import 'Screens/HomeScreen/MainScreen.dart';
import 'Screens/HomeScreen/Maincubit/main_cubit.dart';
import 'Screens/Login&SignUp/cubit/sign_cubit.dart';
import 'Screens/onboardingScreen/IntroScreen/IntroScreen.dart';
import 'Helpers/firebase_options.dart';


void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    ApiHelper.init();
  await FireStoreHelper().getumofapplytimes ();
  await Hive.openBox(Hivehelper.Boxname);
  await Hive.openBox(Hivehelper.NotoficationBoxname);
  await FireStoreHelper(). getProfileSettings();
  await NotificationService().initNotification();
  runApp(MyApp());
}
final GlobalKey<NavigatorState>navigatorkey=GlobalKey<NavigatorState>();


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final User user ;
  bool? isUserSignedIn;

  @override
  void initState() {
    super.initState();
    checkUserSignedIn();
  }

  void checkUserSignedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && Hivehelper.checkfirst() ) {
        setState(() {
          isUserSignedIn = false;
          print("user sign out");
        });
      } else {
        setState(() {
          isUserSignedIn = true;
          print("user sign in");

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isUserSignedIn == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemesCubit()..setinitalTheme()), // إضافة BlocProvider للثيم

        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => SignCubit()),
      ],
      child: BlocBuilder<ThemesCubit,ThemState>(
        builder: (context,state) {
          return GetMaterialApp(
            routes:{
              NotoficationScreen.routeName : (context)=> const NotoficationScreen(),

            },
            navigatorKey: navigatorkey,
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            title: 'JobScout',
            home: isUserSignedIn! ? const Mainscreen() :  const IntroScreen(),
          );
        }
      ),
    );
  }
}
