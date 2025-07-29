import 'dart:convert';
import 'package:checkmate/features/auth/social_media_auth/services/apple_auth_service.dart';
import 'package:checkmate/features/auth/social_media_auth/services/google_auth_service.dart';
import 'package:checkmate/features/auth/social_media_auth/services/linkedin_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../secrets.dart';
import 'auth_payload.dart';


enum SocialProvider { google, apple, linkedin }

class AuthRepository {
  final _google = GoogleAuthService();
  final _apple = AppleAuthService();
  final _linkedin = LinkedInAuthService();

  String? _appJwt;   // replace with your own persistence

  Future<String?> signIn(SocialProvider p, {required BuildContext ctx}) async {
    AuthPayload? payload;
    switch (p) {
      case SocialProvider.google:   payload = await _google.signIn();            break;
      case SocialProvider.apple:    payload = await _apple.signIn();             break;
      case SocialProvider.linkedin: payload = await _linkedin.signIn(ctx);       break;
    }
    if (payload == null) return null;

    // send to backend -> receive your own JWT
    final res = await http.post(
      Uri.parse('${Secrets.backendBase}/auth/${p.name}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload.toJson()),
    );
    _appJwt = jsonDecode(res.body)['accessToken'] as String?;
    return _appJwt;
  }

  Future<void> signOut() async {
    await _google.signOut();            // Apple/LinkedIn expose no sign-out API
    _appJwt = null;
  }

  String? get token => _appJwt;         // expose however you manage state
}