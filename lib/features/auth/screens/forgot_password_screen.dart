import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/controllers/verify_controller.dart';
import 'package:checkmate/features/auth/screens/trail.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final VerifyController verify = VerifyController();
  bool sentCode = false;
  handleEmailVerification() async {
    verify
        .verifyEmailCode(TextControllers.verificationCode.text)
        .then(
          (v) => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => VerficationTrailScreen(message: v),
              ),
            ),
          },
        );
  }

  sendEmailVerificationCode() {
    setState(() {
      sentCode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
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
            if (!sentCode) ...{
              TextField(
                decoration: InputDecoration(
                  labelText: AppStrings.email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            } else ...{
              CustomTextField(
                controller: TextControllers.verificationCode,
                label: AppStrings.enterVerificationCode,
              ),
            },
            const SizedBox(height: 16),
            Button(
              text: !sentCode
                  ? AppStrings.sendVerificationCode
                  : AppStrings.verifyCode,
              onPressed: () {
                if (sentCode) {
                  handleEmailVerification();
                } else {
                  sendEmailVerificationCode();
                }
              },
            ),
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
