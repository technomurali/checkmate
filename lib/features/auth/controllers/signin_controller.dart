import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // BasicCodesFromCrm().getEventStatus();
      // BasicCodesFromCrm().getEventApprovals();
      var data = {
        SigninModalKeys.signinEmail: email,
        SigninModalKeys.signinPassword: password,
        SigninModalKeys.fcmToken: prefs.getString('fcmToken') ?? 'No token',
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
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
          token: data["accessToken"] ?? '',
          npiNumber: data['result'][ModalKeys().userNpiNumber],
        );
        prefs.setString('user', jsonEncode(user.toJson()));
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
      if (e.toString().contains('SocketException')) {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: 'No Internet connection',
        };
      } else {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: 'An error occurred. Please try again.',
        };
      }
    }
  }
}
