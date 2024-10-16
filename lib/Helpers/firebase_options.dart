// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBXXl84GbE9KykvGdVNjCnlJcvg_U2VPE8',
    appId: '1:364145859843:web:065931bc5ac39510939d36',
    messagingSenderId: '364145859843',
    projectId: 'jobscouttesting',
    authDomain: 'jobscouttesting.firebaseapp.com',
    storageBucket: 'jobscouttesting.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBl7Gyjs1RQtxOBDQscigKcYNZyh5kV2qg',
    appId: '1:364145859843:android:595ff4d854059b64939d36',
    messagingSenderId: '364145859843',
    projectId: 'jobscouttesting',
    storageBucket: 'jobscouttesting.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBezQxlh5ZX9MH99aV0wU7Y0FShNP11Fi0',
    appId: '1:364145859843:ios:5b51d12bca67f9ef939d36',
    messagingSenderId: '364145859843',
    projectId: 'jobscouttesting',
    storageBucket: 'jobscouttesting.appspot.com',
    iosBundleId: 'com.example.jobscout',
  );
}