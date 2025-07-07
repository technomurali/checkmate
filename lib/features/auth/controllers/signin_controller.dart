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
    final url = Uri.parse(AppApi.baseUrl + AppApi.signin);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          SigninModalKeys.signinEmail: email,
          SigninModalKeys.signinPassword: password,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("signin data /////// $data");
      if (response.statusCode == 200) {
        // Parse user using your UserModal
        final user = UserModal.fromJson(data[SigninModalKeys.signinUser]);
        return {
          SigninModalKeys.signinSuccess: true,
          SigninModalKeys.signinMessage: data[SigninModalKeys.signinMessage],
          SigninModalKeys.signinUser: user,
        };
      } else {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: data[SigninModalKeys.signinMessage],
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
