import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyController {
  Future<Map<String, dynamic>> verifyEmailCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse(AppApi.baseUrl + AppApi.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ModalKeys().emailVerificationCode: code}),
      );

      final responseBody = jsonDecode(response.body);
      debugPrint(responseBody.toString());
      if (response.statusCode == 201) {
        return {
          ModalKeys().statusCode: response.statusCode,
          ModalKeys().message: responseBody[ModalKeys().message],
        };
      } else {
        return {
          ModalKeys().statusCode: response.statusCode,
          ModalKeys().message: responseBody[ModalKeys().message],
        };
      }
    } catch (e) {
      return {ModalKeys().emailVerificationCode: e.toString()};
    }
  }
}
