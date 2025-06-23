class ModalKeys
    with
        SignUpModalKeys,
        PharmaModalKeys,
        EmailVerificationKeys,
        ResetPasswordKeys,
        SigninModalKeys,
        UserModalKeys {}

mixin SignUpModalKeys {
  final String email = "email";
  final String password = "password";
  final String firstName = "firstName";
  final String lastName = "lastName";
  final String city = "city";
  final String pharmaCompany = "pharmaCompany";
}

mixin SigninModalKeys {
  final String signinSuccess = 'success';
  final String signinMessage = 'message';
  final String signinUser = 'user';
  final String signinEmail = 'email';
  final String signinPassword = 'password';
}

mixin UserModalKeys {
  final String userId = 'id';
  final String userEmail = 'email';
  final String userPassword = 'password';
  final String userFirstName = 'firstName';
  final String userLastName = 'lastName';
  final String userCity = 'city';
  final String userPharmaCompany = 'pharmaCompany';
}

mixin PharmaModalKeys {
  final String pharmaModalCompanies = "pharma_companies";
}

mixin EmailVerificationKeys {
  final String message = "message";
  final String emailVerificationCode = 'code';
  final String statusCode = 'statusCode';
}

mixin ResetPasswordKeys {
  final String emailPasswordReset = "email";
  final String newPassword = "newPassword";
  final String resetMessage = 'message';
  final String resetSuccess = 'success';
}
