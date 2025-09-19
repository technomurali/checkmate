import 'package:checkmate/features/auth/controllers/reset_password_controller.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/utils/validators.dart';

class ForgotPasswordScreenLogic extends ChangeNotifier {
  final PasswordResetController _resetController = PasswordResetController();
  bool sentCode = false;
  bool isVerificationCodeEntered = false;
  bool emailEnteredAndValid = false;
  bool wrongCodeEntered = false;
  bool isLoading = false;
  // Proper listeners
  late final VoidCallback _emailListener;
  late final VoidCallback _codeListener;

  ForgotPasswordScreenLogic() {
    _emailListener = () {
      final isValid = Validators().isValidEmail(TextControllers.email.text);
      emailEnteredAndValid = isValid && TextControllers.email.text.isNotEmpty;
      notifyListeners();
    };

    _codeListener = () {
      isVerificationCodeEntered =
          TextControllers.verificationCode.text.isNotEmpty;
      notifyListeners();
    };
    TextControllers.email.clear();
    TextControllers.verificationCode.clear();
    _initListeners();
  }

  void _initListeners() {
    TextControllers.email.addListener(_emailListener);
    TextControllers.verificationCode.addListener(_codeListener);
  }

  void sendVerificationCode() {
    isLoading = true;
    notifyListeners();
    _resetController
        .sendVerificationCode(email: TextControllers.email.text)
        .then((value) {
          isLoading = false;
          sentCode = true;
          notifyListeners();
        });
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final result = await _resetController.verifyCode(
      code: TextControllers.verificationCode.text,
      email: TextControllers.email.text,
    );

    if (result.statusCode == AppApiStatusCodes.success) {
      var email = TextControllers.email.text;
      resetForm();
      isLoading = false;
      notifyListeners();

      Navigator.pushReplacementNamed(
        context,
        RouteName.resetPassword,
        arguments: email,
      );
    } else {
      wrongCodeEntered = true;
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    sentCode = false;
    isVerificationCodeEntered = false;
    emailEnteredAndValid = false;
    wrongCodeEntered = false;
    TextControllers.email.clear();
    TextControllers.verificationCode.clear();
    notifyListeners();
  }

  void disposeControllers() {
    TextControllers.email.removeListener(_emailListener);
    TextControllers.verificationCode.removeListener(_codeListener);
  }
}
