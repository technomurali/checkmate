import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:http/http.dart' as http;

class PasswordResetController {
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse(AppApi.baseUrl1 + AppApi.restPassword);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ModalKeys().emailPasswordReset: email,
          ModalKeys().newPassword: newPassword,
        }),
      );

      // final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
  //https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/ApplicationUser/forgot-password

  Future<String> sendVerificationCode({required String email}) async {
    final url = Uri.parse("${AppApi.baseUrl1}${AppApi.forgotPassword}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ModalKeys().emailPasswordReset: email}),
      );

      // final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Something went wrong';
      }
    } catch (e) {
      return 'Network error: ${e.toString()}';
    }
  }
  //https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/ApplicationUser/verify-code

  Future<http.Response> verifyCode({
    required String email,
    required String code,
  }) async {
    final url = Uri.parse("${AppApi.baseUrl1}${AppApi.verifyEmail}");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ModalKeys().emailPasswordReset: email,
          ModalKeys().verificationCode: int.tryParse(code) ?? 0,
        }),
      );

      // final data = jsonDecode(response.body);

     return response;
    } catch (e) {
      return http.Response('Network error: ${e.toString()}', 500);
    }
  }
}
