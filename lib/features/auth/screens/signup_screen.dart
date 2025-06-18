import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/widgets/social_buttons_row.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isSignUpDisabled = true;
  bool isOptedForEmail = true;
  bool isOptedForSocialSignUp = false;
  String selectedValue = 'Select the Pharmacitical';

  final List<String> items = [
    'Select the Pharmacitical',
    'Banana',
    'Mango',
    'Orange',
  ];
  Map<String, bool> isvalid = {
    "email": false,
    "password": false,
    "confirmPassword": false,
    "firstName": false,
    "lastname": false,
    "city": false,
    "pharma": false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Text(AppStrings.signupTerms),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: isOptedForSocialSignUp,
            //       onChanged: (value) {
            //         setState(() {
            //           isOptedForSocialSignUp = value!;
            //         });
            //       },
            //     ),
            //     const Text(AppStrings.socialMediaSignUp),
            //     Checkbox(
            //       value: isOptedForEmail,
            //       onChanged: (value) {
            //         setState(() {
            //           isOptedForEmail = value!;
            //         });
            //       },
            //     ),
            //     const Text(AppStrings.emailSignUp),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(AppStrings.emailSignUp),

                const Text(AppStrings.socialMediaSignUp),
              ],
            ),
            const SizedBox(height: 16),
            if (isOptedForSocialSignUp) ...{
              const SocialButtonsRow(),
            } else ...{
              CustomTextField(
                controller: TextControllers.email,
                label: AppStrings.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.password,
                obscureText: true,
                controller: TextControllers.password,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: AppStrings.confirmPassword,
                obscureText: true,
                controller: TextControllers.confirmPassword,
              ),
            },

            const SizedBox(height: 16),
            CustomTextField(
              controller: TextControllers.firstName,
              label: AppStrings.firstName,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextControllers.lastName,
              label: AppStrings.lastName,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextControllers.city,
              label: AppStrings.city,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: AppColors.border, offset: Offset(4, 4)),
                ],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                icon: const Icon(Icons.arrow_drop_down),

                // elevation: 16,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Button(
              text: AppStrings.signup,
              onPressed: () {
                debugPrint("Sign UP");
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.alreadyAccount),
            ),
          ],
        ),
      ),
    );
  }
}
