import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            // Icon(Icons.cancel, size: 48, color: AppColors.primary),
            AppLogo(),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            Text(AppStrings.enterEmailInstruction),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: AppStrings.email,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Button(text: AppStrings.sendVerificationCode, onPressed: () {}),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.backToLogin),
            ),
          ],
        ),
      ),
    );
  }
}
