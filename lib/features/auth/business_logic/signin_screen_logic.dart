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
  String? emailError;
  String? passwordError;
  SigninScreenLogic([SigninController? controller])
    : _signinController = controller ?? SigninController() {
    SigninTextControllers.email.addListener(updateButtonState);
    SigninTextControllers.password.addListener(updateButtonState);
    SigninTextControllers.email.clear();
    SigninTextControllers.password.clear();
  }

  bool isButtonEnabled = false;
  bool validateEmail() {
    final email = SigninTextControllers.email.text.trim();
    if (SigninTextControllers.email.text.trim() != "") {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        emailError = "Enter a valid email";
        notifyListeners();
        return false;
      } else {
        emailError = null;
        notifyListeners();
        return true;
      }
    } else {
      emailError = "Email can't be empty";
      notifyListeners();
      return false;
    }
    // updateButtonState();.co
    // notifyListeners();
  }

  bool validatePassword() {
    final password = SigninTextControllers.password.text.trim();
    if (!isValidPassword(password)) {
      passwordError = "Must be 6+ chars, include upper, lower, digit, special";
      notifyListeners();
      return false;
    } else {
      passwordError = null;
      notifyListeners();
      return true;
    }
    // updateButtonState();
  }

  void updateButtonState() {
    final enabled =
        SigninTextControllers.email.text.trim().isNotEmpty &&
        SigninTextControllers.password.text.trim().isNotEmpty;
    if (enabled != isButtonEnabled) {
      isButtonEnabled = enabled;
      showError = false;
      notifyListeners();
    }
  }

  bool isValidPassword(String password) {
    // if (password != "") {
    //   if (password.length < 6) return false;
    //   if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    //   if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    //   if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    //   if (!RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(password)) return false;
    // }
    return true;
  }

  Future<UserModal?> signinUser(BuildContext context) async {
    if (!validateEmail() | !validatePassword()) {
      return null;
    }
    try {
      isLoading = true;
      notifyListeners();
      final response = await _signinController.signin(
        email: SigninTextControllers.email.text.trim(),
        password: SigninTextControllers.password.text.trim(),
      );

      if (response[SigninModalKeys.signinSuccess] == true) {
        final user = response[SigninModalKeys.signinUser] as UserModal;
        userModal = user;
        isButtonEnabled = false;
        isLoading = false;
        notifyListeners();
        SigninTextControllers.email.clear();
        SigninTextControllers.password.clear();
        return user;
      } else {
        isLoading = false;
        showError = true;
        errorMessage =
            response[SigninModalKeys.signinMessage] ?? 'Login failed';
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
    SigninTextControllers.email.removeListener(updateButtonState);
    SigninTextControllers.password.removeListener(updateButtonState);
    super.dispose();
  }
}
