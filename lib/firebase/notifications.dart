// lib/firebase/firebase_notifications.dart
import 'dart:io';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/features/auth/controllers/interceptor.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:checkmate/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  // Single high-importance channel for Android
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel', // id (keep stable)
        'High Importance Notifications', // name (user-visible)
        description: 'Used for important notifications.',
        importance: Importance.high,
      );

  void _navigateToEvent(String eventId) async {
    debugPrint('[NAV] _navigateToEvent called with eventId=$eventId');
    // wait for navigator context if app is still booting
    if (navigatorKey.currentContext == null) {
      debugPrint('[NAV] waiting for context (pass 1)');
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    if (navigatorKey.currentContext == null) {
      debugPrint('[NAV] waiting for context (pass 2)');
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('[NAV] context still null, aborting');
      return;
    }

    final navProvider = Provider.of<TopNavProvider>(ctx, listen: false);
    debugPrint('[NAV] obtained TopNavProvider');

    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    if (userJson == null) {
      debugPrint('[NAV] no user in prefs, aborting');
      return;
    }

    final user = UserModal.fromJson(jsonDecode(userJson));
    userModal = user;
    debugPrint('[NAV] user loaded: ${user.id}');

    // Normalize stack -> dashboard -> eventDetails
    navProvider.reset(); // your provider's reset to app root/dashboard
    if (user.id != "0") {
      debugPrint('[NAV] navigating to dashboard');
      // navProvider.navigateTo(TopNavScreen.dashboard, argument: userModal);
      navProvider.history = TopNavScreen.dashboard;
      navProvider.currentScreen = TopNavScreen.eventDetails;
      navProvider.argument = eventId;
      Navigator.of(
        navigatorKey.currentContext!,
      ).pushReplacement(MaterialPageRoute(builder: (_) => TopNav()));
      // Defer pushing event details to the next frame so UI rebuild completes
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   debugPrint('[NAV] navigating to eventDetails with eventId=$eventId');
      //   // Use a Map argument for consistency/safety across code paths
      //   navProvider.navigateTo(
      //     TopNavScreen.eventDetails,
      //     argument: {'eventId': eventId},
      //   );
      // });
    } else {
      debugPrint('[NAV] user.id == "0", aborting');
    }
  }

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

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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
      debugPrint(
        'Push permission not granted (${settings.authorizationStatus}).',
      );
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

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _fln.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) async {
        debugPrint(
          '[TAP] onDidReceiveNotificationResponse payload=${resp.payload}',
        );
        final payload = resp.payload;
        if (payload == null || payload.isEmpty) return;

        String? eventId;

        // Try JSON first
        try {
          final data = Map<String, dynamic>.from(jsonDecode(payload));
          eventId = data['eventId']?.toString();
        } catch (_) {
          // Fallback 1: legacy Map.toString() format "{eventId: xxx}"
          final match = RegExp(r'eventId:\s*([^\}\s]+)').firstMatch(payload);
          if (match != null) {
            eventId = match.group(1);
          } else {
            // Fallback 2: treat entire payload as raw eventId
            eventId = payload;
          }
        }

        if (eventId != null && eventId.isNotEmpty) {
          _navigateToEvent(eventId);
        }
      },
    );

    if (Platform.isAndroid) {
      final androidPlugin = _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

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
    final body = notif?.body ?? message.data['body'] ?? '';
    if (message.data.containsKey("eventId")) {
      final eventId = message.data["eventId"];
      // 👈 Access hidden eventId
    }
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
      payload: message.data.isEmpty ? null : jsonEncode(message.data),
    );
  }

  Future<void> _showInAppPrompt(
    String title,
    String body,
    String eventId,
  ) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    // Avoid stacking multiple prompts
    if (ModalRoute.of(ctx)?.isCurrent != true) return;
    showModalBottomSheet(
      context: ctx,
      isDismissible: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(body),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Dismiss'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _navigateToEvent(eventId);
                      },
                      child: const Text('Open'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Foreground messages → show local notification on Android
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('FG message: ${message.messageId} data=${message.data}');
    if (Platform.isAndroid) {
      _showLocalNotification(message);
      final evt = message.data['eventId']?.toString();
      if (evt != null && evt.isNotEmpty) {
        // Helpful log to confirm foreground path
        debugPrint('[FG] Showing in-app prompt for eventId=$evt');
        _showInAppPrompt(
          message.notification?.title ??
              message.data['title'] ??
              'Notification',
          message.notification?.body ?? message.data['body'] ?? '',
          evt,
        );
      }
    }
    // iOS banners already handled by setForegroundNotificationPresentationOptions
  }

  // When user taps a notification (from background/terminated)
  void _onOpenedFromTray(RemoteMessage message) {
    debugPrint('Opened from tray: ${message.messageId} data=${message.data}');
    final eventId = message.data['eventId']?.toString();
    if (eventId == null || eventId.isEmpty) return;
    _navigateToEvent(eventId);
  }
}

class NotificationsController {
  Client http = InterceptedClient.build(interceptors: [Interceptor()]);
  Future<Response> sendApprovalNotification(String kioskId, eventId) async {
    debugPrint("Notification Sent");
    /*
{
  "kiosk": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "title": "string",
  "body": "string"
}
 */
    final message = {
      "kiosk": kioskId,
      "title": "Event Approval Request",
      "body": "A new event has been submitted for your approval.",
      "eventId": eventId,
    };
    final uri = Uri.parse("${AppApi.baseUrl1}${AppApi.sendNotification}");
    var responce = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(message),
        )
        .then((response) {
          if (response.statusCode == AppApiStatusCodes.success) {
            debugPrint("Notification API Response : ${response.body}");
            return response;
          } else {
            debugPrint("Notification API Error : ${response.body}");
            return response;
          }
        })
        .catchError((error) {
          debugPrint("Notification API Exception : $error");
          return Response("$error", 400);
        });
    return responce;
  }
}
