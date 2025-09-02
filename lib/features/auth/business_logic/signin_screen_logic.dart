import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/modal_keys.dart';

class SigninScreenLogic extends ChangeNotifier {
  final SigninController _signinController;
  bool isLoading = false;
  bool showError = false;
  String errorMessage = '';
  SigninScreenLogic([SigninController? controller])
    : _signinController = controller ?? SigninController() {
    TextControllers.email.addListener(updateButtonState);
    TextControllers.password.addListener(updateButtonState);
    TextControllers.email.clear();
    TextControllers.password.clear();
  }

  bool isButtonEnabled = false;

  void updateButtonState() {
    final enabled =
        TextControllers.email.text.trim().isNotEmpty &&
        TextControllers.password.text.trim().isNotEmpty;
    if (showError) {
      showError = false;
      errorMessage = '';
      notifyListeners();
      
    }
    if (enabled != isButtonEnabled) {
      isButtonEnabled = enabled;
      notifyListeners();
    }
  }

  Future<UserModal?> signinUser(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _signinController.signin(
        email: TextControllers.email.text.trim(),
        password: TextControllers.password.text.trim(),
      );

      if (response[SigninModalKeys.signinSuccess] == true) {
        final user = response[SigninModalKeys.signinUser] as UserModal;
        userModal = user;
        isButtonEnabled = false;
        isLoading = false;
        notifyListeners();
        TextControllers.email.clear();
        TextControllers.password.clear();
        return user;
      } else {
        isLoading = false;
        showError = true;
        errorMessage = response[SigninModalKeys.signinMessage] ?? 'Login failed';
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response[SigninModalKeys.signinMessage] ?? 'Login failed',
            ),
          ),
          
        );
        return null;
      }
    } catch (e) {
      isLoading = false;
      showError = true;
      errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please try again.')),
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
