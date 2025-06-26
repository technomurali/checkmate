import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/modal_keys.dart';

class SigninScreenLogic extends ChangeNotifier {
  final SigninController _signinController = SigninController();

  bool isButtonEnabled = false;

  SigninScreenLogic() {
    TextControllers.email.addListener(updateButtonState);
    TextControllers.password.addListener(updateButtonState);
  }

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

    if (response[ModalKeys().signinSuccess]) {
      userModal = response[ModalKeys().signinUser];
      return response[ModalKeys().signinUser];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[ModalKeys().message] ?? 'Login failed'),
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
