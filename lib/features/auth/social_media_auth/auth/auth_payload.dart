class AuthPayload {
  final String idToken;
  final String? authCode;     // LinkedIn/Google PKCE or Apple code
  final String? email;
  final String? name;
  final String? avatar;
  const AuthPayload({
    required this.idToken,
    this.authCode,
    this.email,
    this.name,
    this.avatar,
  });
  Map<String, dynamic> toJson() => {
        'idToken': idToken,
        'authCode': authCode,
        'email': email,
        'name': name,
        'avatar': avatar,
      };
}