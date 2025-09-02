import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // iOS requires an APNs token before requesting an FCM token.
      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          // On simulator or if APNs hasn't provided a token yet, don't call getToken().
          // Instead, listen for token availability; Firebase will emit once registration completes.
          FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
            print('FCM token (onTokenRefresh): $token');
            // TODO: send token to backend if needed
          });
        } else {
          final fcmToken = await _firebaseMessaging.getToken();
          print('FCM token: $fcmToken');
          // TODO: send token to backend if needed
        }
      } else {
        // Android or other platforms: safe to request token directly.
        final fcmToken = await _firebaseMessaging.getToken();
        print('FCM token: $fcmToken');
        // TODO: send token to backend if needed
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received a message while in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
