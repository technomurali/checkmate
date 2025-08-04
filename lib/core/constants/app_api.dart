class AppApi {
  // static const String baseUrl = "http://10.0.2.2:3000/api/";

  static const String baseUrl = "https://172.32.32.100:7103/api/";
  static const String baseUrl1 = "https://172.32.32.69:7133/api/";
  static const String pharmaLists = "pharma-companies";
  static const String signup = "Auth/signup";
  static const String signin = 'ApplicationUser/login';
  static const String verifyEmail = 'Auth/validateEmailVerificationCode';
  static const String restPassword = 'Auth/reset-password';
  static const String events = 'events';
  static const String event = 'event';
  static const String newEvent = 'new-event';
  static const String hcoLists = 'hco-lists';
  static const String hcpLists = 'hcp-lists';
  static const String disputes = 'disputes';
}

class AppApiStatusCodes {
  static const int success = 200;
  static const int error = 400;
  static const int notFound = 404;
}
