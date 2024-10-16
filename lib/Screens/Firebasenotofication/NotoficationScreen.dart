import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotoficationScreen extends StatelessWidget {
  static const String routeName = '/notificationScreen';

  const NotoficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed RemoteMessage from the arguments
    final RemoteMessage? message = ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(title: Text('Notification Details')),
      body: message != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${message.notification?.title ?? 'No title'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Body: ${message.notification?.body ?? 'No body'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text('Data:'),
            Text(message.data.toString()),
          ],
        ),
      )
          : Center(child: Text('No notification data')),
    );
  }
}