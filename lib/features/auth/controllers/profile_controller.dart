import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  Future<String> getCompanyName(String id) async {
    try {
      //https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/Accounts/88dfb0a4-a1fd-ee11-a1fe-000d3a30eadf
      final uri = "${AppApi.baseUrl1}/Accounts/$id";
      final responce = await http.get(Uri.parse(uri));
      if (responce.statusCode == AppApiStatusCodes.success) {
        final jsonBody = json.decode(responce.body);
        return jsonBody["accountName"];
      } else {
        return "Error Fetching Company Name";
      }
    } catch (e) {
      debugPrint("Error fetching Company: $e");
      return "";
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      var uri = Uri.parse("${AppApi.baseUrl1}${AppApi.updateProfile}");
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == AppApiStatusCodes.success) {
        return Future.value({
          "success": true,
          "message": "Profile Updated Successfully",
        });
      } else {
        return Future.value({
          "success": false,
          "message":
              "Error Updating Profile: ${jsonDecode(response.body)['message']}",
        });
      }
    } catch (e) {
      return Future.value({"success": false, "message": e.toString()});
    }
  }
}
