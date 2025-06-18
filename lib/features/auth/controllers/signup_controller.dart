import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:http/http.dart' as http;

class SignupController {
  Future<Map<String, dynamic>> signupUser(SignUpModel user) async {
    try {
      final response = await http.post(
        Uri.parse(Api.baseUrl + Api.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': SignUpModel.fromJson(data['user']),
          'message': data['message'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'error': error['message'] ?? 'Unknown error'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Failed to sign up: $e'};
    }
  }
}
