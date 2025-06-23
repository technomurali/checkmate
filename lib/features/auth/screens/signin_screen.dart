import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/business_logic/forgot_password_screen_logic.dart';
import 'package:checkmate/features/auth/business_logic/signup_screen_logic.dart';
import 'package:checkmate/features/auth/business_logic/signin_screen_logic.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/screens/home_screens.dart';
import 'package:checkmate/features/auth/screens/forgot_password_screen.dart';
import 'package:checkmate/features/auth/screens/signup_screen.dart';
import 'package:checkmate/features/auth/widgets/social_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SiginScreen extends StatelessWidget {
  const SiginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<SigninScreenLogic>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            CustomTextField(
              label: AppStrings.email,
              controller: TextControllers.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: AppStrings.password,
              obscureText: true,
              controller: TextControllers.password,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => ForgotPasswordScreenLogic(),
                        child: const ForgotPasswordScreen(),
                      ),
                    ),
                  );
                },
                child: Text(
                  AppStrings.forgotPassword,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            Button(
              isDisabled: !logic.isButtonEnabled,
              text: AppStrings.signin,
              onPressed: () async {
                final user = await logic.signinUser(context);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.noAccount),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => SignupScreenLogic(),
                          child: const SignupScreen(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.signup,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(AppStrings.signInWith),
            const SizedBox(height: 8),
            const SocialButtonsRow(),
          ],
        ),
      ),
    );
  }
}
