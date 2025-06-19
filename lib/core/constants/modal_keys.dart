class ModalKeys with SignUpModalKeys, PharmaModalKeys, EmailVerificationKeys {}

mixin SignUpModalKeys {
  final String email = "email";
  final String password = "password";
  final String firstName = "firstName";
  final String lastName = "lastName";
  final String city = "city";
  final String pharmaCompany = "pharmaCompany";
}

mixin PharmaModalKeys {
  final String pharmaCompanies = "pharma_companies";
}

mixin EmailVerificationKeys {
  final String message = "message";
  final String emailVerificationCode = 'code';
}
