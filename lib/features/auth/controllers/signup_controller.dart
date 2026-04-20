import 'dart:convert';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SignupController {
  bool _isTruthy(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  bool _isFalsy(dynamic value) {
    if (value is bool) return value == false;
    if (value is num) return value == 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'false' || normalized == '0' || normalized == 'no';
    }
    return false;
  }

  bool _hasTruthySuccess(Map<String, dynamic> parsed) {
    final dynamic success = parsed['success'] ?? parsed['isSuccess'];
    return _isTruthy(success);
  }

  bool _hasExplicitFailure(Map<String, dynamic> parsed) {
    final dynamic success = parsed['success'] ?? parsed['isSuccess'];
    if (_isFalsy(success)) return true;

    final dynamic error =
        parsed['error'] ?? parsed['detail'] ?? parsed['errors'] ?? parsed['errorMessage'];

    if (error == null) return false;
    final String text = error.toString().trim();
    return text.isNotEmpty;
  }

  bool _messageLooksSuccessful(String? message) {
    if (message == null) return false;
    final normalized = message.trim().toLowerCase();
    if (normalized.isEmpty) return false;

    const successHints = <String>[
      'success',
      'created',
      'registered',
      'signup successful',
      'user created',
    ];
    const failureHints = <String>[
      'fail',
      'failed',
      'error',
      'invalid',
      'already exists',
      'duplicate',
    ];

    final hasFailureHint = failureHints.any(normalized.contains);
    if (hasFailureHint) return false;
    return successHints.any(normalized.contains);
  }

  bool _hasCreatedIdentity(Map<String, dynamic> parsed) {
    final Map<String, dynamic> result =
        parsed['result'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(parsed['result'])
        : <String, dynamic>{};

    final dynamic id = parsed['id'] ?? result['id'] ?? result['userId'];
    final dynamic email =
        parsed['emailaddress1'] ??
        parsed['email'] ??
        result['emailaddress1'] ??
        result['email'];

    final bool hasId = id != null && id.toString().trim().isNotEmpty && id.toString() != '0';
    final bool hasEmail = email != null && email.toString().trim().isNotEmpty;
    final bool createdFlag = parsed['created'] == true || result['created'] == true;
    return createdFlag || hasId || hasEmail;
  }

  Future<Map<String, dynamic>> signupUser(SignUpModel user) async {
    try {
      final url = Uri.parse(AppApi.baseUrl1 + AppApi.signup);
      final payload = user.toJson();
      final payloadForLog = Map<String, dynamic>.from(payload);
      payloadForLog['password'] = '***';
      debugPrint('SIGNUP request url: $url');
      debugPrint('SIGNUP request payload: ${jsonEncode(payloadForLog)}');
      // ignore: avoid_print
      print('SIGNUP request payload: ${jsonEncode(payloadForLog)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final body = response.body.trim();
      debugPrint('SIGNUP response status: ${response.statusCode}');
      debugPrint('SIGNUP response body: $body');
      Map<String, dynamic> parsed = {};
      if (body.isNotEmpty) {
        try {
          parsed = Map<String, dynamic>.from(jsonDecode(body));
        } catch (_) {
          parsed = {'message': body};
        }
      }

      final bool httpOk = response.statusCode >= 200 && response.statusCode < 300;
      final bool explicitSuccess = _hasTruthySuccess(parsed);
      final bool hasCreatedIdentity = _hasCreatedIdentity(parsed);
      final bool explicitFailure = _hasExplicitFailure(parsed);
      final String? rawMessage =
          parsed['message']?.toString() ??
          parsed['title']?.toString() ??
          parsed['statusMessage']?.toString();
      final bool messageLooksSuccessful = _messageLooksSuccessful(rawMessage);

      final bool ok =
          httpOk &&
          !explicitFailure &&
          (explicitSuccess || hasCreatedIdentity || messageLooksSuccessful || parsed.isEmpty);

      final String message;
      if (ok) {
        message = (rawMessage == null || rawMessage.trim().isEmpty)
            ? 'Signup successful.'
            : rawMessage;
      } else {
        final String? explicitError =
            parsed['error']?.toString() ??
            parsed['detail']?.toString() ??
            parsed['errors']?.toString();
        message = (explicitError == null || explicitError.trim().isEmpty)
            ? 'Signup failed: server did not confirm user creation.'
            : explicitError;
      }

      return {
        'success': ok,
        'message': message,
        'statusCode': response.statusCode,
        'data': parsed,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Signup request failed. Please try again.',
        'error': e.toString(),
      };
    }
  }
}
