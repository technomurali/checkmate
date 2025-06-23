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
      "sigin /////// ${jsonEncode({ModalKeys().signinEmail: email, ModalKeys().password: password})}",
    );
    final url = Uri.parse(AppApi.baseUrl + AppApi.signin);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ModalKeys().signinEmail: email,
          ModalKeys().password: password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse user using your UserModal
        final user = UserModal.fromJson(data[ModalKeys().signinUser]);
        return {
          ModalKeys().signinSuccess: true,
          ModalKeys().signinMessage: data[ModalKeys().signinMessage],
          ModalKeys().signinUser: user,
        };
      } else {
        return {
          ModalKeys().signinSuccess: false,
          ModalKeys().signinMessage: data[ModalKeys().signinMessage],
        };
      }
    } catch (e) {
      return {
        ModalKeys().signinSuccess: false,
        ModalKeys().signinMessage: e.toString(),
      };
    }
  }
}
