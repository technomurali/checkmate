import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/model/dispute_modal.dart';
import 'package:http/http.dart' as http;

class DisputeController {
  Future<bool> submitDispute(DisputeModal disputeModal) async {
    print("disputeModal: ${jsonEncode(disputeModal.toJson())}");
    print("${AppApi.baseUrl}${AppApi.disputes}/save");
    final response = await http.post(
      Uri.parse("${AppApi.baseUrl}${AppApi.disputes}/save"),
      body: jsonEncode(disputeModal.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    print("response: ${response.statusCode}");
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<DisputeModal>> fetchAllDisputes() async {
    final response = await http.get(
      Uri.parse("${AppApi.baseUrl}${AppApi.disputes}/getAll"),
      headers: {"Content-Type": "application/json"},
    );
    print("response: ${response.body}");
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["dispute"] as List)
          .map((e) => DisputeModal.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<DisputeModal> fetchDisputeDetails({required disputeId}) async {
    final response = await http.get(
      Uri.parse("${AppApi.baseUrl}${AppApi.disputes}/get?disputeId=$disputeId"),
      headers: {"Content-Type": "application/json"},
    );
    print("responce: ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      return DisputeModal.fromJson(jsonDecode(response.body)['dispute']);
    } else {
      return DisputeModal().empty();
    }
  }
}
