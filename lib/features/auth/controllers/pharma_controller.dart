import 'dart:convert';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/features/auth/model/pharma_modal.dart';
import 'package:http/http.dart' as http;

class PharmaController {
  Future<PharmaModel> fetchPharmaCompanies() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://172.32.32.69:7133/api/Accounts/accounts/pharmaCompanies-active",
        ), //?pharmaTerm=$query
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PharmaModel.fromJson(jsonData);
      } else {
        throw Exception(
          '${ErrorText.failedToLoadPharmaCompanies} ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('${ErrorText.failedToLoadPharmaCompanies} $e');
    }
  }
}
