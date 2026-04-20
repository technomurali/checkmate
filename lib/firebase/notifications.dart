import 'package:checkmate/features/auth/controllers/interceptor.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class NotificationsController {
  Client http = InterceptedClient.build(interceptors: [Interceptor()]);

  Future<Response> sendApprovalNotification(String kioskId, eventId) async {
    debugPrint("Notifications disabled. Skipping notification API call.");
    return Response("Notifications disabled", 200);
  }
}
