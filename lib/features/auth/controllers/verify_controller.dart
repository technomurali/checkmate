import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:http/http.dart' as http;

class VerifyController {
  Future<String> verifyEmailCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse(AppApi.baseUrl + AppApi.verifyEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ModalKeys().emailVerificationCode: code}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return responseBody[ModalKeys().message] ??
            'Email Verified Successfully';
      } else {
        return responseBody[ModalKeys().message] ?? 'Verification failed';
      }
    } catch (e) {
      return '${ErrorText.somethingWentWrong}$e';
    }
  }
}
