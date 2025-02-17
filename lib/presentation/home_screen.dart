import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_notification_demo/presentation/notification_details_screen.dart';
import 'package:local_notification_demo/services/local_notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    listenToStream();
  }

  void listenToStream() {
    LocalNotificationServices.notificationStreamController.stream.listen((
      notificationResponse,
    ) {
      log(
        'Notification Tapped: ${notificationResponse.id} ${notificationResponse.payload}',
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => NotificationDetailsScreen(
                notificationResponse: notificationResponse,
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Local Notifications'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///simple notification
            ListTile(
              leading: const Icon(Icons.notifications),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () async {
                  await LocalNotificationServices.cancelNotification(0);
                },
              ),
              title: const Text('Simple Notification'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () async {
                await LocalNotificationServices.showSimpleNotification();
              },
            ),
            const SizedBox(height: 16.0),

            ///repeat notification
            ListTile(
              leading: const Icon(Icons.notifications_active),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () async {
                  await LocalNotificationServices.cancelNotification(1);
                },
              ),
              title: const Text('Repeated Notification'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () async {
                await LocalNotificationServices.showRepeatedNotification();
              },
            ),
            const SizedBox(height: 16.0),

            ///scheduled notification
            ListTile(
              leading: const Icon(Icons.notifications_paused),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () async {
                  await LocalNotificationServices.cancelNotification(2);
                },
              ),
              title: const Text('Scheduled Notification'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onTap: () async {
                await LocalNotificationServices.showScheduledNotification();
              },
            ),
            const SizedBox(height: 32.0),

            ///cancel all notifications
            ElevatedButton(
              onPressed: () async {
                await LocalNotificationServices.cancelAllNotifications();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Cancel All Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
