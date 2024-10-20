import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobscout/Helpers/Hivehelper.dart';
import 'package:jobscout/Screens/HomeScreen/Maincubit/main_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notofication extends StatelessWidget {
  const Notofication({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainCubit>();
    final notifications = Hivehelper.messages;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(child: Text('There\'s no Notifications'))
          : ListView.builder(
        shrinkWrap: true,
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final message = notifications[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: NotificationCard(message: message),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final RemoteMessage message;

  const NotificationCard({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.notification?.title ?? 'No title',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            message.notification?.body ?? 'No body',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
