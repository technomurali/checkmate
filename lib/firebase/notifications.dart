// lib/firebase/firebase_notifications.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Top-level background handler (required by firebase_messaging)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG message: ${message.messageId} data=${message.data}');
  // If you really want to show a notification while background-handling,
  // you can initialize FlutterLocalNotificationsPlugin here too (advanced).
}

class FirebaseNotifications {
  FirebaseNotifications._();
  static final FirebaseNotifications instance = FirebaseNotifications._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  // Single high-importance channel for Android
  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // id (keep stable)
    'High Importance Notifications', // name (user-visible)
    description: 'Used for important notifications.',
    importance: Importance.high,
  );

  /// Call this once, e.g. in main()
  Future<void> initialize() async {
    // iOS: request permission + show notifications in foreground
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      providesAppNotificationSettings: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Android: init local notifications + create channel
    await _setupLocalNotifications();

    // Tokens
    final token = await _fcm.getToken();
    debugPrint('FCM token: $token');
    await prefs.setString('fcmToken', token ?? '');
    _fcm.onTokenRefresh.listen((t) => debugPrint('FCM token refreshed: $t'));

    // Message handlers
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedFromTray);

    // If app opened from terminated by tapping a notification
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _onOpenedFromTray(initial);
    }

    // Background handler must be top-level
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('Push permission not granted (${settings.authorizationStatus}).');
    }
  }

  Future<void> _setupLocalNotifications() async {
    // Android init: use your app icon as small icon
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _fln.initialize(initSettings);

    if (Platform.isAndroid) {
      final androidPlugin =
          _fln.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      // Create high-importance channel once
      await androidPlugin?.createNotificationChannel(_androidChannel);

      // Android 13+ runtime permission for notifications (optional but recommended)
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  // Show a local notification (used for Android foreground; optional on iOS)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notif = message.notification;
    final title = notif?.title ?? message.data['title'] ?? 'Notification';
    final body  = notif?.body  ?? message.data['body']  ?? '';

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: notif?.android?.smallIcon, // defaults to @mipmap/ic_launcher
        ticker: 'ticker',
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _fln.show(
      message.hashCode,
      title,
      body,
      details,
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }

  // Foreground messages → show local notification on Android
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FG message: ${message.messageId} data=${message.data}');
    if (Platform.isAndroid) {
      _showLocalNotification(message);
    }
    // iOS banners already handled by setForegroundNotificationPresentationOptions
  }

  // When user taps a notification (from background/terminated)
  void _onOpenedFromTray(RemoteMessage message) {
    debugPrint('Opened from tray: ${message.messageId} data=${message.data}');
    // TODO: Navigate using message.data (e.g., route, id)
    // Example:
    // final route = message.data['route'];
    // if (route != null) Navigator.of(context).pushNamed(route);
  }
}