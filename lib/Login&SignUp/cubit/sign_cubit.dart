import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jobscout/HomeScreen/HomeScreen.dart';
import 'package:meta/meta.dart';

import '../VerificationScreen.dart';

part 'sign_state.dart';

class SignCubit extends Cubit<SignState> {
  FirebaseAuth instance = FirebaseAuth.instance;
  SignCubit() : super(SignInitial());
  void Login(BuildContext context,
      GlobalKey<FormState> key,
      TextEditingController emailController,
      TextEditingController passwordController,
      ) async {
    emit(SignLoadingState());

    try {
      // التحقق من صحة النموذج
      if (key.currentState!.validate()) {
        // محاولة تسجيل الدخول باستخدام FirebaseAuth
        final UserCredential response = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = response.user;

        if (user != null) {
          if (user.emailVerified)
            {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homescreen()),
          );
            }
          else {
              user.sendEmailVerification();
              emit (SignFaliureState("please verfiy your account check mail"));

          }

          emit(SignSuccesState());
        } else {
          emit(SignFaliureState("Login failed"));
        }
      } else {
        // إذا فشلت عملية التحقق من صحة النموذج
        emit(SignFaliureState("Validation error"));
      }
    } catch (e) {
      // إذا حدث خطأ في عملية تسجيل الدخول
      emit(SignFaliureState(e.toString()));
    }
  }
  void SignUp(
      BuildContext context,
      GlobalKey<FormState> key,
      TextEditingController EmailController,
      TextEditingController nameController,
      TextEditingController passwordController,
      TextEditingController MobileController,
      ) async {
    emit(SignLoadingState());

    try {
      if (key.currentState!.validate()) {
        final UserCredential response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: EmailController.text,
          password: passwordController.text,
        );

        User? user = response.user;

        if (user != null) {
          user.sendEmailVerification();
          emit (SignFaliureState("your account done please verfiy your account check mail"));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(user: FirebaseAuth.instance.currentUser!),
            ),
          );
          emit(SignSuccesState());
        } else {
          emit(SignFaliureState("User creation failed"));
        }
      } else {
        emit(SignFaliureState("Validation error"));
      }
    } catch (e) {
      // إرسال حالة الفشل مع رسالة الخطأ
      emit(SignFaliureState(e.toString()));
    }
  }
  void googelSignin()async{
    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }
  void FacbookLogin(){

  }

}
