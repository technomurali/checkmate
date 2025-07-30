import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:http/http.dart' as http;

class NewEventController {
  Future<Map<String, dynamic>> getHCO() async {
    try {
      final uri = Uri.parse(
        "https://172.32.32.69:7133/api/Accounts/accounts/hco-active",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {'success': true, 'data': data};
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

  //physicians-active
  Future<Map<String, dynamic>> getHCP({String? hcoId}) async {
    try {
      final uri = Uri.parse(
        "https://172.32.32.69:7133/api/Contact/physicians-active",
      );
      final response = await http.get(uri);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'data': []};
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getHCPbyHCO(String hcoId) async {
    try {
      final uri = Uri.parse(
        'https://172.32.32.69:7133/api/Contact/getHCPs/$hcoId',
      );
      final response = await http.get(uri);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'data': []};
      }
    } catch (e) {
      return {'success': false, 'data': null, 'message': 'Error: $e'};
    }
  }

  //physicians-active
  createEvent(Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse("https://172.32.32.69:7133/api/Events");
      var jsonWalaBody = json.encode(data);
      dynamic g = json.decode(jsonWalaBody);
      final response = await http.post(
        uri,
        body: jsonWalaBody,
        headers: {'Content-Type': 'application/json'},
      );
      print("Response: ${response.body}");
    } catch (e) {
      print("Error: $e");
      return {'success': false, 'data': null, 'message': 'Error: $e'};
    }
  }
}
