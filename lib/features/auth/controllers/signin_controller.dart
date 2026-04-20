import 'dart:convert';
import 'dart:io';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SigninController {
  SigninController();

  Future<Map<String, dynamic>> signin({
    required String email,
    required String password,
  }) async {
    debugPrint(
      "sigin /////// ${jsonEncode({SigninModalKeys.signinEmail: email, SigninModalKeys.signinPassword: password})}",
    );
    final url = Uri.parse(AppApi.baseUrl1 + AppApi.signin);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // BasicCodesFromCrm().getEventStatus();
      // BasicCodesFromCrm().getEventApprovals();
      var data = {
        SigninModalKeys.signinEmail: email,
        SigninModalKeys.signinPassword: password,
        SigninModalKeys.fcmToken: prefs.getString('fcmToken') ?? 'No token',
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("signin data /////// $data");
        // Parse user using your UserModal
        final user = UserModal(
          id: data['result']['id'].toString(),
          email:
              data['result'][ModalKeys().userEmail] ?? data['result']["email"],
          password: data['result']["password"],
          firstName: data['result']["firstName"],
          lastName: data['result']["lastName"],
          city: data['result']['city'],
          pharmaCompany: data['result']["companyId"],
          role:
              data['result'][ModalKeys().userRole]?.toString() ??
              data['result']["userRoleId"]?.toString(),
          kiosk: data['result']["kiosk"].toString(),
          token: data["accessToken"] ?? '',
          npiNumber: data['result'][ModalKeys().userNpiNumber],
        );
        prefs.setString('user', jsonEncode(user.toJson()));
        return {
          SigninModalKeys.signinSuccess: true,
          SigninModalKeys.signinMessage: data[SigninModalKeys.signinMessage],
          SigninModalKeys.signinUser: user,
        };
      } else {
        final parsedMessage = _extractErrorMessage(response);
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: parsedMessage,
        };
      }
    } on SocketException {
      return {
        SigninModalKeys.signinSuccess: false,
        SigninModalKeys.signinMessage: 'No Internet connection',
      };
    } on http.ClientException catch (e) {
      final isWebXhrError =
          kIsWeb && e.message.toLowerCase().contains('xmlhttprequest error');
      return {
        SigninModalKeys.signinSuccess: false,
        SigninModalKeys.signinMessage:
            isWebXhrError
                ? 'Unable to reach login service from browser. Please try mobile app or contact backend team for CORS fix.'
                : 'Unable to connect to server. Please try again.',
      };
    } catch (e) {
      debugPrint('Signin error: $e');
      if (e.toString().contains('SocketException')) {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: 'No Internet connection',
        };
      } else {
        return {
          SigninModalKeys.signinSuccess: false,
          SigninModalKeys.signinMessage: 'An error occurred. Please try again.',
        };
      }
    }
  }

  String _extractErrorMessage(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.trim();

    if (body.isEmpty) {
      return _defaultStatusMessage(statusCode);
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded[SigninModalKeys.signinMessage];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }

        final title = decoded['title'];
        if (title is String && title.trim().isNotEmpty) {
          final errors = decoded['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstEntry = errors.entries.first.value;
            if (firstEntry is List && firstEntry.isNotEmpty) {
              return '$title: ${firstEntry.first}';
            }
          }
          return title.trim();
        }
      }
    } catch (_) {
      // Body is not json; use fallback path.
    }

    if (body.length <= 180) {
      return body;
    }
    return _defaultStatusMessage(statusCode);
  }

  String _defaultStatusMessage(int statusCode) {
    if (statusCode == 400) return 'Invalid login request.';
    if (statusCode == 401) return 'Invalid email or password.';
    if (statusCode == 403) return 'Access denied. Please contact support.';
    if (statusCode >= 500) return 'Server error. Please try again later.';
    return 'Login failed. Please try again.';
  }
}
