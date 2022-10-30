// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  late AndroidNotificationChannel channel;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotification() async {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notifications',
        importance: Importance.high);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void onMessagingListener() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('Nova Notificação : $message');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    icon: 'launch_background')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Nova Notificação : $message');
    });
  }

  Future<String?> getNotificationToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  //  Authorization - YOUR Server key of Cloud Messaging
  Future<void> sendNotification(
      String to, Map<String, dynamic> data, String title, String body) async {
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAEx4FuFA:APA91bH4ZRAxd3ZQJDXFqxB-9O0GVBh-kuINGpWFUiEVgt6rA4nRElJ10Ed586UH2MhN9PZXQdDMJZWX0KlpJCA1YVr330bIRfcfCf0cbvJSXRpx-wt4y7WNQG3U57u0yPLMgxu3SJ_I'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  Future<void> sendNotificationMultiple(List<String> toList,
      Map<String, dynamic> data, String title, String body) async {
    Uri uri = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAEx4FuFA:APA91bH4ZRAxd3ZQJDXFqxB-9O0GVBh-kuINGpWFUiEVgt6rA4nRElJ10Ed586UH2MhN9PZXQdDMJZWX0KlpJCA1YVr330bIRfcfCf0cbvJSXRpx-wt4y7WNQG3U57u0yPLMgxu3SJ_I'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'registration_ids': toList
        }));
  }
}

final pushNotification = PushNotification();
