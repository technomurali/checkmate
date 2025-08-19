import 'package:checkmate/features/auth/social_media_auth/auth/auth_payload.dart';
import 'package:checkmate/features/auth/social_media_auth/secrets.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

class LinkedInAuthService {
  Future<AuthPayload?> signIn(BuildContext ctx) async {
    final res = await Navigator.push<AuthPayload?>(
      ctx,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => LinkedInAuthCodeWidget(
          redirectUrl: 'https://example.com/oauth/linkedin',
          clientId: Secrets.linkedinClientId,
          onGetAuthCode: (s) {
            return Navigator.pop(
              ctx,
              AuthPayload(
                authCode: s.codeResponse.code,
                idToken: s.codeResponse.accessToken.toString(),
              ),
            );
          },
          onError: (_) => Navigator.pop(ctx, null),
        ),
      ),
    );
    return res;
  }
}
