import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/HomeScreen/Maincubit/main_cubit.dart';
import 'package:jobscout/kconstnt/constants.dart';


class Savedscreen extends StatelessWidget {
  const Savedscreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: kPrimaryColor,
    body: Center(child: Text("Saved Screen"),),

  );
  }
}
