import 'package:checkmate/features/auth/business_logic/password_reset_screen_logic.dart';
import 'package:checkmate/features/auth/screens/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/controllers/verify_controller.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/utils/validators.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreenLogic extends ChangeNotifier {
  final VerifyController _verifyController = VerifyController();

  bool sentCode = false;
  bool isVerificationCodeEntered = false;
  bool emailEnteredAndValid = false;
  bool wrongCodeEntered = false;

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
    sentCode = true;
    //TODO: Add API call to send verification code
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context) async {
    final result = await _verifyController.verifyEmailCode(
      TextControllers.verificationCode.text,
    );

    if (result[ModalKeys().statusCode] == AppApiStatusCodes.success) {
      var email = TextControllers.email.text;
      resetForm();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => PasswordResetScreenLogic(),
            child: PasswordResetScreen(
              message: result[ModalKeys().message],
              email: email,
            ),
          ),
        ),
      );
    } else {
      wrongCodeEntered = true;
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
