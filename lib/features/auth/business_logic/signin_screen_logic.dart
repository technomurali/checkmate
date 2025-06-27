import 'dart:convert';

import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/modal_keys.dart';

class SigninScreenLogic extends ChangeNotifier {
  final SigninController _signinController;
  SigninScreenLogic([SigninController? controller])
    : _signinController = controller ?? SigninController() {
    TextControllers.email.addListener(updateButtonState);
    TextControllers.password.addListener(updateButtonState);
  }

  bool isButtonEnabled = false;

  void updateButtonState() {
    final enabled =
        TextControllers.email.text.trim().isNotEmpty &&
        TextControllers.password.text.trim().isNotEmpty;

    if (enabled != isButtonEnabled) {
      isButtonEnabled = enabled;
      notifyListeners();
    }
  }

  Future<UserModal?> signinUser(BuildContext context) async {
    final response = await _signinController.signin(
      email: TextControllers.email.text.trim(),
      password: TextControllers.password.text.trim(),
    );

    if (response[SigninModalKeys.signinSuccess] == true) {
      final user = response[SigninModalKeys.signinUser] as UserModal;
      userModal = user;
      isButtonEnabled = false;
      notifyListeners();
      return user;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response[SigninModalKeys.signinMessage] ?? 'Login failed',
          ),
        ),
      );
      return null;
    }
  }

  @override
  void dispose() {
    TextControllers.email.removeListener(updateButtonState);
    TextControllers.password.removeListener(updateButtonState);
    super.dispose();
  }
}
