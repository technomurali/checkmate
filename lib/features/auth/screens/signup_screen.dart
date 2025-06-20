import 'package:checkmate/core/widgets/app_logo.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
import 'package:checkmate/features/auth/controllers/signup_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:checkmate/features/auth/widgets/social_buttons_row.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isSignUpDisabled = true;
  bool isOptedForSocialSignUp = false;
  final PharmaController _pharmaController = PharmaController();
  final SignupController _signupController = SignupController();

  List<String> items = [];
  List<String> items2 = [];
  // Used for Signup Button Enabling or Disabling
  Map<String, bool> isvalid = {
    "email": false,
    "newPassword": false,
    "confirmPassword": false,
    "firstName": false,
    "lastname": false,
    "city": false,
    "selectYourCompany": false,
  };

  getPharmaList() {
    _pharmaController.fetchPharmaCompanies().then(
      (v) => {
        setState(() {
          items2 = v.pharmaCompanies;
        }),
      },
    );
  }

  userSignUp() {
    SignUpModel data = SignUpModel(
      email: TextControllers.email.text,
      password: TextControllers.password.text,
      firstName: TextControllers.firstName.text,
      lastName: TextControllers.lastName.text,
      city: TextControllers.city.text,
      pharmaCompany: TextControllers.pharma.text,
    );
    _signupController
        .signupUser(data)
        .then(
          (v) => {
            setState(() {
              TextControllers.email.clear();
              TextControllers.password.clear();
              TextControllers.confirmPassword.clear();
              TextControllers.firstName.clear();
              TextControllers.lastName.clear();
              TextControllers.city.clear();
              TextControllers.pharma.clear();
            }),
          },
        );
  }

  void checkFormValidity() {
    final allValid = isvalid.values.every((element) => element);

    setState(() {
      isSignUpDisabled = !(allValid && !isOptedForSocialSignUp);
    });
  }

  @override
  void initState() {
    super.initState();

    TextControllers.email.addListener(() {
      isvalid['email'] = TextControllers.email.text.contains('@');
      checkFormValidity();
    });
    TextControllers.password.addListener(() {
      isvalid['newPassword'] = TextControllers.password.text.length >= 6;
      isvalid['confirmPassword'] =
          TextControllers.password.text == TextControllers.confirmPassword.text;
      checkFormValidity();
    });
    TextControllers.confirmPassword.addListener(() {
      isvalid['confirmPassword'] =
          TextControllers.password.text == TextControllers.confirmPassword.text;
      checkFormValidity();
    });
    TextControllers.firstName.addListener(() {
      isvalid['firstName'] = TextControllers.firstName.text.isNotEmpty;
      checkFormValidity();
    });
    TextControllers.lastName.addListener(() {
      isvalid['lastname'] = TextControllers.lastName.text.isNotEmpty;
      checkFormValidity();
    });
    TextControllers.city.addListener(() {
      isvalid['city'] = TextControllers.city.text.isNotEmpty;
      checkFormValidity();
    });
    TextControllers.pharma.addListener(() {
      isvalid['selectYourCompany'] =
          TextControllers.pharma.text != AppStrings.selectThePharma;
      checkFormValidity();
    });
    getPharmaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Text(AppStrings.signupTerms),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: isOptedForSocialSignUp,
                    onChanged: (value) {
                      setState(() {
                        isOptedForSocialSignUp = value!;
                      });
                    },
                  ),
                  const Text(AppStrings.socialMediaSignUp),
                ],
              ),

              const SizedBox(height: 16),
              if (isOptedForSocialSignUp) ...{
                const SocialButtonsRow(),
              } else ...{
                CustomTextField(
                  isRequired: true,
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
                  controller: TextControllers.email,
                  label: AppStrings.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  validator: (val) {
                    if (val.length < 6) return ErrorText.passMinError;
                    return null;
                  },
                  isRequired: true,
                  label: AppStrings.newPassword,
                  obscureText: true,
                  controller: TextControllers.password,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  validator: (val) {
                    if (val.length < 6) {
                      return ErrorText.passMinError;
                    } else if (val.length < 6 ||
                        (TextControllers.password.text != val)) {
                      return ErrorText.passMisMatch;
                    }

                    return null;
                  },
                  isRequired: true,
                  label: AppStrings.confirmPassword,
                  obscureText: true,
                  controller: TextControllers.confirmPassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  validator: (val) {
                    if (val.length < 2) {
                      return ErrorText.shortName;
                    } else if (val.isEmpty) {
                      return ErrorText.nameRequired;
                    }

                    return null;
                  },
                  isRequired: true,
                  controller: TextControllers.firstName,
                  label: AppStrings.firstName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  validator: (val) {
                    if (val.length < 2) {
                      return ErrorText.shortName;
                    } else if (val.isEmpty) {
                      return ErrorText.nameRequired;
                    }

                    return null;
                  },
                  isRequired: true,
                  controller: TextControllers.lastName,
                  label: AppStrings.lastName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  validator: (val) {
                    if (val.length < 2) {
                      return ErrorText.smallCity;
                    } else if (val.isEmpty) {
                      return ErrorText.cityRequired;
                    }

                    return null;
                  },
                  isRequired: true,
                  controller: TextControllers.city,
                  label: AppStrings.city,
                ),
              },
              const SizedBox(height: 16),

              CustomTextField(
                controller: TextControllers.pharma,
                label: AppStrings.selectThePharma,
                onChanged: (p0) {
                  if (p0.isEmpty) {
                    debugPrint("Items ::::");
                    setState(() {
                      items.clear();
                    });
                  } else {
                    setState(() {
                      items = items2.where((company) {
                        debugPrint(
                          "Items :: $p0 ${company.toLowerCase().contains(p0.toLowerCase())}",
                        );
                        return company.toLowerCase().contains(p0.toLowerCase());
                      }).toList();
                    });
                  }
                },
              ),
              if (items.isNotEmpty) ...{
                Container(
                  padding: EdgeInsets.all(10),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (int i = 0; i < items.length; i++) ...{
                          InkWell(
                            child: Text(items[i]),
                            onTap: () {
                              TextControllers.pharma.text = items[i];
                              setState(() {
                                items.clear();
                              });
                            },
                          ),
                          i == items.length - 1 ? SizedBox() : Divider(),
                        },
                      ],
                    ),
                  ),
                ),
              },
              const SizedBox(height: 16),
              Button(
                isDisabled: isSignUpDisabled,
                text: AppStrings.signup,
                onPressed: () {
                  userSignUp();
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.alreadyAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
