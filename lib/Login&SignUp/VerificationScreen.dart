import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobscout/HomeScreen/HomeScreen.dart';

class VerificationScreen extends StatefulWidget {
  final User user;
  const VerificationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}


class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = widget.user.emailVerified;

    // تحقق من حالة البريد الإلكتروني كل 5 ثواني
    timer = Timer.periodic(const Duration(seconds: 5), (_) => checkEmailVerification());

    Future.delayed(const Duration(seconds: 6)).then((_) {
      if (!isEmailVerified) {  // إذا لم يتم التحقق، انتقل بعد 6 ثوانٍ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
        timer?.cancel();  // تأكد من إلغاء المؤقت عند الخروج من الشاشة
        super.dispose();
      }
    });
  }

  Future<void> checkEmailVerification() async {
    await widget.user.reload();  // تحديث بيانات المستخدم من Firebase
    setState(() {
      isEmailVerified = widget.user.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();  // إلغاء المؤقت إذا تم التحقق
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();  // تأكد من إلغاء المؤقت عند الخروج من الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isEmailVerified
            ? const Text('Redirecting...')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: Colors.red),
            const Text("Please check your email for verification."
                "This Page will disappear after 5 seconds "),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isChecking
                  ? null
                  : () async {
                setState(() {
                  isChecking = true;
                });
                await checkEmailVerification();
                setState(() {
                  isChecking = false;
                });
              },
              child: isChecking
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text("I've verified my email"),
            ),
          ],
        ),
      ),
    );
  }
}
