import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    print('Received a message: ${message.messageId}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  Future initPushNotifications() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $token");

    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        handleMessage(message);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
            print('FCM token (onTokenRefresh): $token');
          });
        } else {
          final fcmToken = await _firebaseMessaging.getToken();
          print('FCM token: $fcmToken');
        }
      } else {
        final fcmToken = await _firebaseMessaging.getToken();
        print('FCM token: $fcmToken');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received a message while in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
