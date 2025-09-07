import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
import 'package:checkmate/features/auth/controllers/signup_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/signup_modal.dart';
import 'package:checkmate/core/constants/app_strings.dart';

class SignupScreenLogic extends ChangeNotifier {
  final PharmaController _pharmaController = PharmaController();
  final SignupController _signupController = SignupController();

  bool isSignUpDisabled = true;
  bool isOptedForSocialSignUp = false;
  bool isLoading = false;
  String? passwordError;
  String? emailError;

  List<Map> filteredCompanies = [];
  List<Map> allCompanies = [];

  final Map<String, bool> isValid = {
    "email": false,
    "newPassword": false,
    "confirmPassword": false,
    "firstName": false,
    "lastname": false,
    "selectYourCompany": false,
  };

  signupViewModel() {
    debugPrint("signupViewModel fetchPharmaCompanies");
    _initListeners();
    getPharmaList();
  }

  void _initListeners() {
    TextControllers.email.addListener(() {
      isValid['email'] = TextControllers.email.text.contains('@');
      _checkFormValidity();
      validateEmail();
    });
    TextControllers.password.addListener(() {
      isValid['newPassword'] = TextControllers.password.text.length >= 6;
      isValid['confirmPassword'] =
          TextControllers.password.text == TextControllers.confirmPassword.text;
      validatePassword();
      _checkFormValidity();
    });
    TextControllers.confirmPassword.addListener(() {
      isValid['confirmPassword'] =
          TextControllers.password.text == TextControllers.confirmPassword.text;
      _checkFormValidity();
    });
    TextControllers.firstName.addListener(() {
      isValid['firstName'] = TextControllers.firstName.text.isNotEmpty;
      _checkFormValidity();
    });
    TextControllers.lastName.addListener(() {
      isValid['lastname'] = TextControllers.lastName.text.isNotEmpty;
      _checkFormValidity();
    });
    // TextControllers.city.addListener(() {
    //   isValid['city'] = TextControllers.city.text.isNotEmpty;
    //   _checkFormValidity();
    // });
    TextControllers.pharma.addListener(() {
      isValid['selectYourCompany'] =
          TextControllers.pharma.text != AppStrings.selectThePharma;
      _checkFormValidity();
    });
  }

  void _checkFormValidity() {
    final allValid = isValid.values.every((e) => e);
    isSignUpDisabled = !((allValid || true) && !isOptedForSocialSignUp);
    notifyListeners();
  }

  void validateEmail() {
    final email = TextControllers.email.text.trim();
    if (TextControllers.email.text.trim() != "") {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        emailError = ErrorText.emailError;
      } else {
        emailError = null;
      }
    }
    notifyListeners();
  }

  void validatePassword() {
    final password = TextControllers.password.text.trim();
    if (!isValidPassword(password)) {
      passwordError = "Must be 6+ chars, include upper, lower, digit, special";
    } else {
      passwordError = '';
    }
    notifyListeners();
  }

  bool isValidPassword(String password) {
    if (password != "") {
      if (password.length < 6) return false;
      if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
      if (!RegExp(r'[a-z]').hasMatch(password)) return false;
      if (!RegExp(r'[0-9]').hasMatch(password)) return false;
      if (!RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(password)) return false;
    }
    return true;
  }

  void toggleSocialSignup(bool? value) {
    isOptedForSocialSignUp = value ?? false;
    _checkFormValidity();
    notifyListeners();
  }

  void getPharmaList() async {
    isLoading = true;
    notifyListeners();
    final result = await _pharmaController.fetchPharmaCompanies();
    debugPrint("fetchPharmaCompanies : $result");
    allCompanies = result.pharmaCompanies;
    isLoading = false;
    notifyListeners();
  }

  void filterCompanies(String input) {
    debugPrint("filterCompanies : $input , $allCompanies ,$filteredCompanies");
    if (input.isEmpty) {
      filteredCompanies.clear();
    } else {
      filteredCompanies = allCompanies
          .where(
            (company) => company['accountName'].toLowerCase().contains(
              input.toLowerCase(),
            ),
          )
          .toList();
    }
    notifyListeners();
  }

  void selectCompany(dynamic company) {
    TextControllers.pharma.text = company['accountName'];
    TextControllers.companyId.text = company['id'];
    filteredCompanies.clear();
    notifyListeners();
  }

  void signupUser(VoidCallback onSuccess) async {
    isLoading = true;
    notifyListeners();
    final data = SignUpModel(
      email: TextControllers.email.text,
      password: TextControllers.password.text,
      firstName: TextControllers.firstName.text,
      lastName: TextControllers.lastName.text,
      city: TextControllers.city.text,
      pharmaCompany: TextControllers.pharma.text,
      userRoleId: "546170001",
      companyId: TextControllers.companyId.text,
    );

    await _signupController.signupUser(data);

    // Clear controllers
    clearAllTextControllers();
    isLoading = false;
    notifyListeners();
    onSuccess();
  }

  clearAllTextControllers() {
    TextControllers.email.clear();
    TextControllers.password.clear();
    TextControllers.confirmPassword.clear();
    TextControllers.firstName.clear();
    TextControllers.lastName.clear();
    TextControllers.city.clear();
    TextControllers.pharma.clear();
  }
}
