import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jobscout/FireStoreHelper/FireStoreHelper.dart';
import 'package:jobscout/Login&SignUp/cubit/sign_cubit.dart';
import 'package:jobscout/theme/theme.dart';
 import 'APIHelper/Apihelper.dart';
import 'Firebasenotofication/Notofication.dart';
import 'Firebasenotofication/NotoficationScreen.dart';
import 'Hivehelper.dart';
 import 'HomeScreen/MainScreen.dart';
import 'HomeScreen/Maincubit/main_cubit.dart';
import 'firebase_options.dart';
import 'kconstnt/constants.dart';
import 'onboardingScreen/IntroScreen/IntroScreen.dart';


void main() async {
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    ApiHelper.init();
  await FireStoreHelper().getumofapplytimes ();
  var Box = await Hive.openBox(Hivehelper.Boxname);
  await FireStoreHelper(). getProfileSettings();
  await  NotificationService().initNotification();
  runApp(const MyApp());
  runApp(MyApp());
}
final GlobalKey<NavigatorState>navigatorkey=GlobalKey<NavigatorState>();
final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(lightTheme);


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
        });
      } else {
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
        home: isUserSignedIn! ? const Mainscreen() :  const IntroScreen(),
      ),
    );
  }
}
