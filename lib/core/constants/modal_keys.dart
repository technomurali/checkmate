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
  static const String signinSuccess = 'success';
  static const String signinMessage = 'message';
  static const String signinUser = 'user';
  static const String signinEmail = 'email';
  static const String signinPassword = 'password';
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

mixin EventsModalKeys {
  static const String events = 'events';
  static const String eventIdKey = "eventId";
  static const String eventPharmaRepId = "pharmaRepId";
  static const String eventPharmaRepName = "pharmaRepName";
  static const String eventNameKey = "eventName";
  static const String eventStartDate = "startDate";
  static const String eventEndDate = "endDate";
  static const String eventNumberOfStaff = "numberOfStaff";
  static const String eventHCO = "HCO";
  static const String eventHCP = "HCP";
  static const String eventAmount = "amount";
  static const String eventStatusKey = "eventStatus";
}
