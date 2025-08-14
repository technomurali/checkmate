import 'dart:convert';

import 'package:http/http.dart' as http;

class AppApi {
  // static const String baseUrl = "http://10.0.2.2:3000/api/";

  static const String baseUrl = "https://172.32.32.100:7103/api/";
  static const String baseUrl1 = "https://172.32.32.69:7133/api/";
  // static const String baseUrl1 =
  //     "https://checkmateapi20250807-fgece5emaccbh2av.canadacentral-01.azurewebsites.net/api/";

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
  static const String getEventTypes = "getEventTypes";
  static const String getEventStatus = 'Events/getEventStatus';
  static const String getEventApprovals = 'Events/getEventApprovals';
}

class AppApiStatusCodes {
  static const int success = 200;
  static const int postSuccess = 201;
  static const int error = 400;
  static const int notFound = 404;
}

class BasicCodesFromCrm {
  //Event Status
  static String upcoming = '2';
  static String completed = '3';
  static String terminated = '4';
  // Event Approvals
  static String approval = '1';
  static String rejected = '2';
  static String pending = '3';

  void getEventStatus() async {
    try {
      var responce = await http.get(
        Uri.parse('${AppApi.baseUrl1}${AppApi.getEventStatus}'),
      );
      var res = jsonDecode(responce.body);
      upcoming = res['upcoming'].toString();
      completed = res['completed'].toString();
      terminated = res["terminated"].toString();
      // ignore: empty_catches
    } catch (e) {}
  }

  void getEventApprovals() async {
    var responce = await http.get(
      Uri.parse('${AppApi.baseUrl1}${AppApi.getEventApprovals}'),
    );
    var res = jsonDecode(responce.body);
    approval = res['approval'].toString();
    rejected = res['rejected'].toString();
    pending = res["pending"].toString();
  }
}
