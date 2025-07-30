import 'dart:convert';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
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

  String? _appJwt; // replace with your own persistence

  Future<bool> signIn(SocialProvider p, {required BuildContext ctx}) async {
    AuthPayload? payload;
    switch (p) {
      case SocialProvider.google:
        payload = await _google.signIn();
        break;
      case SocialProvider.apple:
        payload = await _apple.signIn();
        break;
      case SocialProvider.linkedin:
        payload = await _linkedin.signIn(ctx);
        break;
    }
    if (payload == null) return false;
    print("Payload : ${payload.toJson()}");
    // send to backend -> receive your own JWT
    final response = await SigninController().signin(
      email: 'rep@abc.com',
      password: 'abcabc',
    );
    if (response[SigninModalKeys.signinSuccess] == true) {
      print("Responce on login ${response['user']}");
      final user = response[SigninModalKeys.signinUser] as UserModal;
      userModal = user;
      userModal = UserModal(
        id: user.id,
        email: payload.email,
        password: user.password,
        firstName: payload.name,
        lastName: payload.name,
        city: user.city,
        pharmaCompany: user.pharmaCompany,
        role: user.role,
        hco: user.hco,
        profileUrl: payload.avatar,
        modeOfAuthentication: user.modeOfAuthentication,
      );
      return true;
    } else {
      return false;
    }
    // _appJwt = jsonDecode(payload.idToken)['accessToken'] as String?;
  }

  Future<void> signOut() async {
    await _google.signOut(); // Apple/LinkedIn expose no sign-out API
    _appJwt = null;
  }

  String? get token => _appJwt; // expose however you manage state
}
