import 'package:checkmate/features/auth/business_logic/signup_screen_logic.dart';
import 'package:checkmate/features/auth/screens/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/widgets/social_buttons_row.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/routes/route_name.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _acceptedTerms = false;
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
      body: Stack(
        children: [
          Padding(
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
                  Text(AppStrings.secureCompliance),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: signupScreenLogic.isOptedForSocialSignUp,
                  //       onChanged: signupScreenLogic.toggleSocialSignup,
                  //     ),
                  //     const Text(AppStrings.socialMediaSignUp),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),

                  // Social or normal form
                  if (signupScreenLogic.isOptedForSocialSignUp) ...[
                    SocialButtonsRow(
                      disabled: TextControllers.pharma.text.isEmpty,
                      onDisabledTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              AppStrings.enterTheCompanyNameWarning,
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    CustomTextField(
                      prefixIcon: Icon(Icons.email_outlined),
                      isRequired: true,
                      controller: TextControllers.email,
                      label: AppStrings.email,
                     errorText: signupScreenLogic.emailError,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      prefixIcon: Icon(Icons.lock_outline),
                      isRequired: true,
                      controller: TextControllers.password,
                      label: AppStrings.newPassword,
                      obscureText: true,
                      errorText: signupScreenLogic.passwordError,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      prefixIcon: Icon(Icons.lock_outline),
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            isRequired: true,
                            controller: TextControllers.firstName,
                            label: AppStrings.firstName,
                            validator: (val) {
                              if (val.isEmpty) return ErrorText.nameRequired;
                              if (val.length < 2) return ErrorText.shortName;
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            isRequired: true,
                            controller: TextControllers.lastName,
                            label: AppStrings.lastName,
                            validator: (val) {
                              if (val.isEmpty) return ErrorText.nameRequired;
                              if (val.length < 2) return ErrorText.shortName;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    //const SizedBox(height: 16),
                    // CustomTextField(
                    //   isRequired: true,
                    //   controller: TextControllers.city,
                    //   label: AppStrings.city,
                    //   validator: (val) {
                    //     if (val.isEmpty) return ErrorText.cityRequired;
                    //     if (val.length < 2) return ErrorText.smallCity;
                    //     return null;
                    //   },
                    // ),
                  ],

                  const SizedBox(height: 16),

                  ///Pharma Company Selection TextField Search Button
                  CustomTextField(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
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
                                      onTap: () => signupScreenLogic
                                          .selectCompany(entry.value),
                                      child: Text(entry.value['accountName']),
                                    ),
                                    if (entry.key !=
                                        signupScreenLogic
                                                .filteredCompanies
                                                .length -
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

                  ///Terms and Conditions button
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        final accepted = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditionsScreen(),
                          ),
                        );
                        if (accepted == true) {
                          setState(() {
                            _acceptedTerms = true;
                          });
                        } else if (accepted == false) {
                          setState(() {
                            _acceptedTerms = false;
                          });
                        }
                      },
                      // child: Text(
                      //   "${AppStrings.signupTerms} ${AppStrings.termsAndConditions}",
                      // ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${AppStrings.signupTerms} ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: AppStrings.termsAndConditions,
                              style: TextStyle(
                                color: AppColors.termsColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!signupScreenLogic.isOptedForSocialSignUp)
                    Button(
                      // color: Color(0xFF3C8AD0),
                      text: AppStrings.signup,
                      isDisabled:
                          signupScreenLogic.isSignUpDisabled || !_acceptedTerms,
                      onPressed: () {
                        signupScreenLogic.signupUser(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signup successful!')),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            RouteName.signIn,
                          );
                        });
                      },
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteName.signIn);
                      signupScreenLogic.clearAllTextControllers();
                    },
                    child: const Text(AppStrings.alreadyAccount),
                  ),
                ],
              ),
            ),
          ),
          if (signupScreenLogic.isLoading) ...{
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: AppColors.border.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          },
        ],
      ),
    );
  }
}
