import 'dart:async';
import 'dart:io';

import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/main.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:provider/provider.dart';

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (response is Response) {
    }
    return response;
  }
}

class Interceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers['Content-Type'] = 'application/json';
    request.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${userModal.token}';

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    // You can handle specific response codes here if needed
    if (response.statusCode == 401) {
      final navProvider = Provider.of<TopNavProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );
      // Handle unauthorized access, e.g., redirect to login
      // Navigator.pushReplacementNamed(context, RouteName.signIn);

      // navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteName.signIn,(route) => false,);
      userModal = UserModal.empty();
      navProvider.reset();
      Navigator.of(navigatorKey.currentContext!).pushReplacement(
        MaterialPageRoute(builder: (_) => const SigninScreen()),
      );
      // Navigator.pushNamedAndRemoveUntil(
      //   navigatorKey.currentContext!,
      //   RouteName.signIn,
      //   (route) => true,
      // ).then(
      //   (v){
      //     return response;
      //   }
      // );
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
