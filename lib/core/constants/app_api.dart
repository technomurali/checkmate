class AppApi {
  static const String baseUrl = "http://10.0.2.2:3000/api/";
  static const String pharmaLists = "pharma-companies";
  static const String signup = "signup";
  static const String signin = 'signin';
  static const String verifyEmail = 'validateEmailVerificationCode';
  static const String restPassword = 'reset-password';
  static const String events = 'events';
  static const String newEvent = 'new-event';
  static const String hcoLists = 'hco-lists';
  static const String hcpLists = 'hcp-lists';
}

class AppApiStatusCodes {
  static const int success = 200;
  static const int error = 400;
  static const int notFound = 404;
}
