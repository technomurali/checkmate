import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/business_logic/password_reset_screen_logic.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatelessWidget {
  final String message;
  final String email;
  const PasswordResetScreen({
    super.key,
    this.message = '',
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordResetScreenLogic(),
      child: _PasswordResetScreenView(message: message, email: email),
    );
  }
}

class _PasswordResetScreenView extends StatelessWidget {
  final String message;
  final String email;
  const _PasswordResetScreenView({required this.message, required this.email});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PasswordResetScreenLogic>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 64),
            const AppLogo(),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  message,
                  style: const TextStyle(color: AppColors.accentSuccess),
                ),
              ),
            CustomTextField(
              isRequired: true,
              controller: TextControllers.password,
              label: AppStrings.newPassword,
              obscureText: true,
              validator: (val) {
                if (val.length < 6) return ErrorText.passMinError;
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              isRequired: true,
              controller: TextControllers.confirmPassword,
              label: AppStrings.confirmPassword,
              obscureText: true,
              validator: (val) {
                if (val.length < 6) return ErrorText.passMinError;
                if (val != TextControllers.password.text) {
                  return ErrorText.passMisMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            model.isSubmitting
                ? const CircularProgressIndicator()
                : Button(
                    text: AppStrings.resetPassword,
                    onPressed: () {
                      model.submit(context, email);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
