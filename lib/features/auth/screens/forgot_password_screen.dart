import 'package:checkmate/features/auth/business_logic/forgot_password_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordScreenLogic vm;

  @override
  void initState() {
    super.initState();
    vm = ForgotPasswordScreenLogic();
  }

  @override
  void dispose() {
    vm.disposeControllers();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordScreenLogic>.value(
      value: vm,
      child: Consumer<ForgotPasswordScreenLogic>(
        builder: (context, vm, _) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(AppStrings.enterEmailInstruction),
                  const SizedBox(height: 16),
                  if (!vm.sentCode)
                    CustomTextField(
                      controller: TextControllers.email,
                      label: AppStrings.email,
                    )
                  else ...[
                    if (vm.wrongCodeEntered)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          ErrorText.wrongCode,
                          style: const TextStyle(color: AppColors.accentError),
                        ),
                      ),
                    CustomTextField(
                      controller: TextControllers.verificationCode,
                      label: AppStrings.enterVerificationCode,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Button(
                    isDisabled: vm.sentCode
                        ? !vm.isVerificationCodeEntered
                        : !vm.emailEnteredAndValid,
                    text: vm.sentCode
                        ? AppStrings.verifyCode
                        : AppStrings.sendVerificationCode,
                    onPressed: () {
                      if (vm.sentCode) {
                        vm.verifyCode(context);
                      } else {
                        vm.sendVerificationCode();
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(AppStrings.backToSignin),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
