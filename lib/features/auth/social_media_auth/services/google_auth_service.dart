import 'dart:io';

import 'package:checkmate/features/auth/social_media_auth/auth/auth_payload.dart';
import 'package:checkmate/features/auth/social_media_auth/secrets.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuthService {
  final _google = GoogleSignIn.instance;

  Future<AuthPayload?> signIn() async {
    Platform.isAndroid
        ? _google.initialize(
            clientId: Secrets.googleServerClientIdAndroid,
            serverClientId: Secrets.googleServerClientId,
          )
        : _google.initialize(clientId: Secrets.googleServerClientIdIOS,serverClientId: Secrets.googleServerClientId,);
    final account = await _google.authenticate(
      scopeHint: ['openid', 'email', 'profile'],
    );
    // if (account == null) return null;
    final auth = await account.authentication;
    print("Auth Token : ${auth.idToken}");
    return AuthPayload(
      idToken: auth.idToken!,
      authCode: auth.idToken,
      email: account.email,
      name: account.displayName,
      avatar: account.photoUrl,
    );
  }

  Future<void> signOut() => _google.disconnect();
}
