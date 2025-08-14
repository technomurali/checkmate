import 'dart:convert';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:http/http.dart' as http;

class SignupController {
  Future<Map<String, dynamic>> signupUser(SignUpModel user) async {
    try {
      final response = await http.post(
        // Uri.parse(AppApi.baseUrl + AppApi.signup),
        // Uri.parse('https://172.32.32.69:7133/api/ApplicationUser'),
        Uri.parse(
          'https://prod-109.westus.logic.azure.com/workflows/34346261ce254ea0bc094d889670a74e/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Icge9uNo78USl6jZgzUudofs6cDk277D9TCMdHSNzcs',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Password": user.password,
          "CompanyId": user.companyId,
          "firstname": user.firstName,
          "lastname": user.lastName,
          "emailaddress1": user.email,
          "crddb_contacttype": 546170001,
          "address": {"city": user.city},
        }),
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
