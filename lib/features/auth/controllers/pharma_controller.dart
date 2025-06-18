import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/model/pharma_modal.dart';
import 'package:http/http.dart' as http;

class PharmaController {
  Future<PharmaModel> fetchPharmaCompanies() async {
    try {
      final response = await http.get(Uri.parse(Api.baseUrl + Api.pharmaLists));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PharmaModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load pharma companies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching pharma companies: $e');
    }
  }
}
