import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/controllers/reset_password_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';

class PasswordResetScreenLogic extends ChangeNotifier {
  String? passwordError;
  String? confirmPasswordError;
  bool isSubmitting = false;

  bool validatePasswords() {
    passwordError = null;
    confirmPasswordError = null;

    final newPassword = TextControllers.password.text.trim();
    final confirmPassword = TextControllers.confirmPassword.text.trim();

    if (newPassword.isEmpty) {
      passwordError = ErrorText.passwordCanNotBeEmpty;
    } else if (newPassword.length < 6) {
      passwordError = ErrorText.passMinError;
    }

    if (confirmPassword != newPassword) {
      confirmPasswordError = ErrorText.passMisMatch;
    }

    notifyListeners();

    return passwordError == null && confirmPasswordError == null;
  }

  // Call your reset password service here
  Future<void> submit(BuildContext context, String email) async {
    if (!validatePasswords()) return;

    isSubmitting = true;
    notifyListeners();

    final controller = PasswordResetController();
    final result = await controller.resetPassword(
      email: email,
      newPassword: TextControllers.password.text.trim(),
    );
    isSubmitting = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result[ModalKeys().resetMessage])));
      if (result[ModalKeys().resetSuccess]) {
        TextControllers.password.clear();
        TextControllers.confirmPassword.clear();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SigninScreen()),
        // );
        Navigator.pushReplacementNamed(context, RouteName.signIn);
      }
    }
  }
}
