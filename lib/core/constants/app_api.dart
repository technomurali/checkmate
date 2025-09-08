import 'dart:convert';

import 'package:http/http.dart' as http;

class AppApi {
  // static const String baseUrl = "http://10.0.2.2:3000/api/";

  static const String baseUrl = "https://172.32.32.100:7103/api/";
  // static const String baseUrl1 = "https://172.32.32.69:7133/api/";
  static const String baseUrl1 =
      "https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/";

  static const String pharmaLists = "Accounts/accounts/pharmaCompanies-active";
  static const String signup = "Auth/signup";
  static const String updateProfile = "Auth/updateProfile";
  static const String signin = 'ApplicationUser/login';
  static const String verifyEmail = 'ApplicationUser/verify-code';
  static const String forgotPassword = 'ApplicationUser/forgot-password';
  static const String restPassword = 'ApplicationUser/reset-password';
  static const String events = 'events';
  static const String event = 'event';
  static const String newEvent = 'new-event';
  static const String hcoLists = 'Accounts/accounts/hco-active';
  static const String hcpLists = 'Contact/physicians-active';
  static const String disputes = 'disputes';
  static const String getEventTypes = "getEventTypes";
  static const String getEventStatus = 'Events/getEventStatus';
  static const String getEventApprovals = 'Events/getEventApprovals';
  static const String getHcpsWithHcoId = 'Contact/getHCPs/';
  static String buildAttachmentsUrl(String eventId) {
    return '${AppApi.baseUrl1}EventAttachments/$eventId/attachments';
  }
}

class AppApiStatusCodes {
  static const int success = 200;
  static const int postSuccess = 201;
  static const int error = 400;
  static const int notFound = 404;
  static const int deleteSuccess = 204;
}

class BasicCodesFromCrm {
  //Event Status
  static String upcoming = '2';
  static String completed = '3';
  static String terminated = '4';
  static String disputed = '1';
  // Event Approvals
  static String approval = '10';
  static String rejected = '21';
  static String pending = '22';

  void getEventStatus() async {
    try {
      var responce = await http.get(
        Uri.parse('${AppApi.baseUrl1}${AppApi.getEventStatus}'),
      );
      var res = jsonDecode(responce.body);
      upcoming = res['upcoming'].toString();
      completed = res['completed'].toString();
      terminated = res["terminated"].toString();
      disputed = res['disputed'].toString();
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
