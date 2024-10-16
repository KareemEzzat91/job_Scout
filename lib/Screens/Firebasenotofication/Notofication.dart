import 'package:firebase_messaging/firebase_messaging.dart';
import '../../main.dart';
import '../HomeScreen/Maincubit/main_cubit.dart';
import 'NotoficationScreen.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  MainCubit bloc = MainCubit();

  Future<void> initNotification() async {
    // Requesting notification permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Getting the token for FCM
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");
    } else {
      print("User declined or has not accepted permission");
    }

    // Set up foreground message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      HandleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked! : ${message.data}");
      HandleMessage(message); // Handle the message when the app is opened from a notification
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void HandleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Check for the notification part
    if (message.notification != null) {
      bloc.showNotification(message);  // Dispatch to the cubit
      print("Notification Title: ${message.notification?.title}");
      print("Notification Body: ${message.notification?.body}");
      navigatorkey.currentState!.pushNamed(NotoficationScreen.routeName , arguments: message);
    }

    // Check for data part
    if (message.data.isNotEmpty) {
      print("Message data: ${message.data}");
    }
  }

  // Background message handler
   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    FirebaseMessaging.instance.getInitialMessage().then(HandleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(HandleMessage);


   }
}
