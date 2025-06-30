import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:http/http.dart' as http;

class NewEventController {
  Future<Map<String, dynamic>> getHCO({String? hcoId}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.hcoLists}",
      ).replace(queryParameters: hcoId != null ? {'hcoId': hcoId} : null);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['hco'],
          'message': data['message'],
        };
      } else {
        final data = json.decode(response.body);
        return {
          'success': false,
          'data': [],
          'message': data['message'] ?? 'Something went wrong',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getHCP({String? hcoId}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.hcpLists}",
      ).replace(queryParameters: hcoId != null ? {'hcoId': hcoId} : null);
      final response = await http.get(uri);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['hcp'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'data': [],
          'message': data['message'] ?? 'Failed to fetch HCP',
        };
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Error: $e'};
    }
  }
}
