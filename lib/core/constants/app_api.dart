class AppApi {
  // static const String baseUrl = "http://10.0.2.2:3000/api/";

  static const String baseUrl = "https://10.0.2.2:7103/api/";

  static const String pharmaLists = "pharma-companies";
  static const String signup = "Auth/signup";
  static const String signin = 'Auth/signin';
  static const String verifyEmail = 'Auth/validateEmailVerificationCode';
  static const String restPassword = 'Auth/reset-password';
  static const String events = 'events';
  static const String event = 'event';
  static const String newEvent = 'new-event';
  static const String hcoLists = 'hco-lists';
  static const String hcpLists = 'hcp-lists';
}

class AppApiStatusCodes {
  static const int success = 200;
  static const int error = 400;
  static const int notFound = 404;
}
