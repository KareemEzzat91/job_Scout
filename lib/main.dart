import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobscout/Login&SignUp/cubit/sign_cubit.dart';
import 'package:jobscout/onboardingScreen/onboardingScreen.dart';
import 'HomeScreen/HomeScreen.dart';
import 'firebase_options.dart';
import 'kconstnt/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
      if (user == null) {
        print('User is currently signed out!');
        print ( ":::::::::::::::::${user?.email.toString()}");
        setState(() {
          isUserSignedIn = false;
        });
      } else {
        print('User is signed in!');
        print ( ":::::::::::::::::${user?.email.toString()}");
        setState(() {
          isUserSignedIn = true;
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
        BlocProvider(create: (context) => SignCubit()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Real Estate',
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kBgColor,
          canvasColor: kBgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white)
              .copyWith(
            bodyLarge: const TextStyle(color: kBodyTextColor),
            bodyMedium: const TextStyle(color: kBodyTextColor),
          ),
        ),
        home: isUserSignedIn! ? Homescreen() :  onboardingScreen(),
      ),
    );
  }
}
