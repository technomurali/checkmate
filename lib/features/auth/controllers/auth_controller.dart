import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isLoading = false;

  void toggleLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    toggleLoading(true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // TODO: Add your login logic (API/Firebase)
      await Future.delayed(const Duration(seconds: 2)); // Mock delay

      debugPrint('Logged in with: $email');
    } catch (e) {
      debugPrint('Login error: $e');
    } finally {
      toggleLoading(false);
    }
  }

  Future<void> signup(BuildContext context) async {
    toggleLoading(true);
    try {
      final email = emailController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();

      // TODO: Add your signup logic
      await Future.delayed(const Duration(seconds: 2)); // Mock delay

      debugPrint('Signed up: $firstName $lastName - $email');
    } catch (e) {
      debugPrint('Signup error: $e');
    } finally {
      toggleLoading(false);
    }
  }

  Future<void> sendPasswordReset(BuildContext context) async {
    toggleLoading(true);
    try {
      final email = emailController.text.trim();

      // TODO: Add password reset logic
      await Future.delayed(const Duration(seconds: 2));

      debugPrint('Password reset sent to: $email');
    } catch (e) {
      debugPrint('Reset error: $e');
    } finally {
      toggleLoading(false);
    }
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }
}
