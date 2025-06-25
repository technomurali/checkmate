import 'package:checkmate/features/auth/business_logic/signup_screen_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/widgets/social_buttons_row.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signupScreenLogic = Provider.of<SignupScreenLogic>(
        context,
        listen: false,
      );
      signupScreenLogic.signupViewModel();
      signupScreenLogic.clearAllTextControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final signupScreenLogic = context.watch<SignupScreenLogic>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Text(AppStrings.signupTerms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: signupScreenLogic.isOptedForSocialSignUp,
                    onChanged: signupScreenLogic.toggleSocialSignup,
                  ),
                  const Text(AppStrings.socialMediaSignUp),
                ],
              ),
              const SizedBox(height: 16),

              // Social or normal form
              if (signupScreenLogic.isOptedForSocialSignUp) ...[
                SocialButtonsRow(
                  disabled: TextControllers.pharma.text.isEmpty,
                  onDisabledTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.enterTheCompanyNameWarning),
                      ),
                    );
                  },
                ),
              ] else ...[
                CustomTextField(
                  isRequired: true,
                  controller: TextControllers.email,
                  label: AppStrings.email,
                  validator: (value) {
                    if (value.trim().isEmpty) return ErrorText.emailReq;
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return ErrorText.emailError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                CustomTextField(
                  isRequired: true,
                  controller: TextControllers.firstName,
                  label: AppStrings.firstName,
                  validator: (val) {
                    if (val.isEmpty) return ErrorText.nameRequired;
                    if (val.length < 2) return ErrorText.shortName;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  isRequired: true,
                  controller: TextControllers.lastName,
                  label: AppStrings.lastName,
                  validator: (val) {
                    if (val.isEmpty) return ErrorText.nameRequired;
                    if (val.length < 2) return ErrorText.shortName;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  isRequired: true,
                  controller: TextControllers.city,
                  label: AppStrings.city,
                  validator: (val) {
                    if (val.isEmpty) return ErrorText.cityRequired;
                    if (val.length < 2) return ErrorText.smallCity;
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),
              CustomTextField(
                controller: TextControllers.pharma,
                label: AppStrings.selectThePharma,
                onChanged: signupScreenLogic.filterCompanies,
              ),
              if (signupScreenLogic.filteredCompanies.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: signupScreenLogic.filteredCompanies
                          .asMap()
                          .entries
                          .map(
                            (entry) => Column(
                              children: [
                                InkWell(
                                  onTap: () => signupScreenLogic.selectCompany(
                                    entry.value,
                                  ),
                                  child: Text(entry.value),
                                ),
                                if (entry.key !=
                                    signupScreenLogic.filteredCompanies.length -
                                        1)
                                  const Divider(),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (!signupScreenLogic.isOptedForSocialSignUp)
                Button(
                  text: AppStrings.signup,
                  isDisabled: signupScreenLogic.isSignUpDisabled,
                  onPressed: () {
                    signupScreenLogic.signupUser(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signup successful!')),
                      );
                    });
                  },
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  signupScreenLogic.clearAllTextControllers();
                },
                child: const Text(AppStrings.alreadyAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
