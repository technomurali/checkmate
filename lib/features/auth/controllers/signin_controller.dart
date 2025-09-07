import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SigninController {
  SigninController();

  Future<Map<String, dynamic>> signin({
    required String email,
    required String password,
  }) async {
    debugPrint(
      "sigin /////// ${jsonEncode({SigninModalKeys.signinEmail: email, SigninModalKeys.signinPassword: password})}",
    );
    final url = Uri.parse(AppApi.baseUrl1 + AppApi.signin);

    try {
      // BasicCodesFromCrm().getEventStatus();
      // BasicCodesFromCrm().getEventApprovals();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          SigninModalKeys.signinEmail: email,
          SigninModalKeys.signinPassword: password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("signin data /////// $data");
        // Parse user using your UserModal
        final user = UserModal(
          id: data['result']['id'].toString(),
          email: data['result']["email"],
          password: data['result']["password"],
          firstName: data['result']["firstName"],
          lastName: data['result']["lastName"],
          city: data['result']['city'],
          pharmaCompany: data['result']["companyId"],
          role: data['result']["userRoleId"],
          kiosk: data['result']["kiosk"].toString(),
          token: data["token"] ?? '',
        );
        return {
          SigninModalKeys.signinSuccess: true,
          SigninModalKeys.signinMessage: data[SigninModalKeys.signinMessage],
          SigninModalKeys.signinUser: user,
        };
      } else {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: response.body,
        };
      }
    } catch (e) {
      return {
        SigninModalKeys.signinSuccess: false,
        SigninModalKeys.signinMessage: e.toString(),
      };
    }
  }
}
