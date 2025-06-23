import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:http/http.dart' as http;

class PasswordResetController {
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse(AppApi.baseUrl + AppApi.restPassword);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ModalKeys().emailPasswordReset: email,
          ModalKeys().newPassword: newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Something went wrong',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
