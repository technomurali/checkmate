import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/controllers/interceptor.dart';
import 'package:checkmate/features/auth/model/openpayments_modal.dart';
import 'package:http_interceptor/http_interceptor.dart';

class OpenPayemtsController {
  String? _error;
  String? get error => _error;
  Client http = InterceptedClient.build(interceptors: [Interceptor()]);

Future<List<OpenPaymentsModal>> getOpenPaymentsList(String npiNumber) async {
  try {
    final response = await http.get(
      Uri.parse("${AppApi.baseUrl1}${AppApi.openPayemtsWithNpiNumber}$npiNumber"),
    );

    if (response.statusCode == AppApiStatusCodes.success) {
      final body = jsonDecode(response.body);

      // Directly parse the list
      return (body as List)
          .map<OpenPaymentsModal>((item) => OpenPaymentsModal.fromJson(item))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}
}
