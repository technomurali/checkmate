import 'package:checkmate/features/auth/social_media_auth/auth/auth_payload.dart';
import 'package:checkmate/features/auth/social_media_auth/secrets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';



class AppleAuthService {
  Future<AuthPayload?> signIn() async {
    final cred = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: Secrets.appleServiceId,
        redirectUri: Uri.parse(Secrets.appleRedirectUri),
      ),
    );
    return AuthPayload(
      idToken: cred.identityToken!,
      authCode: cred.authorizationCode,
      email: cred.email,
      name: '${cred.givenName ?? ''} ${cred.familyName ?? ''}'.trim(),
    );
  }
}