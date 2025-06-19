import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:http/http.dart' as http;

class SignupController {
  Future<Map<String, dynamic>> signupUser(SignUpModel user) async {
    try {
      final response = await http.post(
        Uri.parse(AppApi.baseUrl + AppApi.signup),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final error = jsonDecode(response.body);
        return error;
      }
    } catch (e) {
      return {'error': e};
    }
  }
}
