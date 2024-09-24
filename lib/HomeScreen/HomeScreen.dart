import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/HomeScreen/Maincubit/main_cubit.dart';
import 'package:jobscout/kconstnt/constants.dart';

import '../Firebasenotofication/NotoficationScreen.dart';
import '../main.dart';
import '../onboardingScreen/onboardingScreen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});
  String truncateHtml(String html, {int length = 200}) {
    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = html.replaceAll(exp, '');

    // Truncate if necessary
    return (plainText.length > length) ? plainText.substring(0, length) + '...' : plainText;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();
    return BlocListener<MainCubit,MainState>(

      listener: (BuildContext context, MainState state) {

        if (state is FailedState)
        {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );

        }
        if (state is SuccessNotoficationState) {
          Get.snackbar(
            state.msg,              // Title of the snackbar
            state.details,           // Description/details of the snackbar
            backgroundColor: Colors.cyan,
            colorText: Colors.white,
            onTap: (snack) {
              navigatorkey.currentState!.pushNamed(
                NotoficationScreen.routeName,
                arguments: state.message,
              );
            },
            duration: Duration(seconds: 5), // How long the snackbar will be visible
            snackPosition: SnackPosition.BOTTOM, // Snackbar position
          );
        }

        if (state is SuccessState)
          {
            Get.snackbar(
              "Hello",
              "Welcome MR ${FirebaseAuth.instance.currentUser?.email}",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );

          }
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(child: Text("HELLLLLLO"),),
      ),
    );
  }
}
