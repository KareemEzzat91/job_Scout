import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jobscout/Login&SignUp/cubit/sign_cubit.dart';
import 'package:jobscout/onboardingScreen/onboardingScreen.dart';
import 'APIHelper/Apihelper.dart';
import 'Firebasenotofication/Notofication.dart';
import 'Firebasenotofication/NotoficationScreen.dart';
import 'Hivehelper.dart';
import 'HomeScreen/HomeScreen.dart';
import 'HomeScreen/MainScreen.dart';
import 'HomeScreen/Maincubit/main_cubit.dart';
import 'firebase_options.dart';
import 'kconstnt/constants.dart';
import 'HomeScreen/SearchScreen/job_search_screen.dart';


void main() async {
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    ApiHelper.init();
  var Box = await Hive.openBox(Hivehelper.Boxname);
  await  NotificationService().initNotification();
  runApp(const MyApp());
  runApp(MyApp());
}
final GlobalKey<NavigatorState>navigatorkey=GlobalKey<NavigatorState>();

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
      if (user == null && Hivehelper.checkfirst() ) {
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
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => SignCubit()),
      ],
      child: GetMaterialApp(
        routes:{
          NotoficationScreen.routeName : (context)=> NotoficationScreen(),

        },
        navigatorKey: navigatorkey,
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
        home: isUserSignedIn! ? Mainscreen() :  onboardingScreen(),
      ),
    );
  }
}
/*
class MyAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Scout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobSearchScreen(),
    );
  }
}*/
