import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/utils/validators.dart';
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
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final VerifyController verify = VerifyController();
  bool sentCode = false;
  bool isVerificationCodeEntered = false;
  bool emailEnteredAndValid = false;
  bool wrongCodeEntered = false;

  validateEmailVerificationCode() async {
    verify
        .verifyEmailCode(TextControllers.verificationCode.text)
        .then(
          (v) => {
            debugPrint('$v'),
            setState(() {
              wrongCodeEntered = false;
            }),
            if (v[ModalKeys().statusCode] == AppApiStatusCodes.success)
              {
                setState(() {
                  sentCode = false;
                  isVerificationCodeEntered = false;
                  emailEnteredAndValid = false;
                  wrongCodeEntered = false;
                  TextControllers.email.clear();
                  TextControllers.verificationCode.clear();
                }),
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        VerficationTrailScreen(message: v[ModalKeys().message]),
                  ),
                ),
              }
            else
              {
                setState(() {
                  wrongCodeEntered = true;
                }),
              },
          },
        );
  }

  sendEmailVerificationCode() {
    setState(() {
      sentCode = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    TextControllers.email.addListener(() {
      bool isValidEmail = Validators().isValidEmail(TextControllers.email.text);
      setState(() {
        emailEnteredAndValid =
            isValidEmail && TextControllers.email.text.isNotEmpty;
      });
      debugPrint(
        "email :: ${isValidEmail && TextControllers.email.text.isNotEmpty} && $isValidEmail && ${TextControllers.email.text.isNotEmpty} && email ${TextControllers.email.text.isNotEmpty} &&isValidEmail $emailEnteredAndValid ",
      );
    });
    TextControllers.verificationCode.addListener(() {
      setState(() {
        isVerificationCodeEntered =
            TextControllers.verificationCode.text.isNotEmpty;
      });
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
              CustomTextField(
                controller: TextControllers.email,
                label: AppStrings.email,
              ),
            } else ...{
              if (wrongCodeEntered) ...{
                Text(
                  ErrorText.wrongCode,
                  style: TextStyle(color: AppColors.accentError),
                ),
                SizedBox(height: 10),
              },
              CustomTextField(
                controller: TextControllers.verificationCode,
                label: AppStrings.enterVerificationCode,
              ),
            },
            const SizedBox(height: 16),
            Button(
              isDisabled: sentCode
                  ? !isVerificationCodeEntered
                  : !emailEnteredAndValid,
              text: !sentCode
                  ? AppStrings.sendVerificationCode
                  : AppStrings.verifyCode,
              onPressed: () {
                if (sentCode) {
                  validateEmailVerificationCode();
                } else {
                  sendEmailVerificationCode();
                }
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.backToSignin),
            ),
          ],
        ),
      ),
    );
  }
}
