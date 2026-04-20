class ModalKeys
    with
        SignUpModalKeys,
        PharmaModalKeys,
        EmailVerificationKeys,
        ResetPasswordKeys,
        SigninModalKeys,
        UserModalKeys,
        HCOModalKeys {}

mixin SignUpModalKeys {
  // CRM expects `emailaddress1` for contact email.
  final String email = "emailaddress1";
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
  static const String fcmToken = 'fcmToken';
}

mixin UserModalKeys {
  final String userId = 'id';
  // CRM response usually returns `emailaddress1` instead of `email`.
  final String userEmail = 'emailaddress1';
  final String userPassword = 'password';
  final String userFirstName = 'firstName';
  final String userLastName = 'lastName';
  final String userCity = 'city';
  final String userPharmaCompany = 'companyId';
  // CRM response usually returns `crddb_contacttype` instead of `userRoleId`.
  final String userRole = 'crddb_contacttype';
  final String userHco = 'hco';
  final String userProfileUrl = 'profileUrl';
  final String userModeOfAuthentication = 'modeOfAuthentication';
  final String userNpiNumber = 'npiNumber';
  final String userPhoneNumber = 'phoneNumber';
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
  final String verificationCode = "code";
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
  static const String eventHCO = "hco";
  static const String eventHCP = "hcp";
  static const String eventAmount = "amount";
  static const String eventStatusKey = "eventStatus";
  static const String eventApprovalStatus = "approvalStatus";
  static const String eventDescription = "eventDescription";
  static const String eventType = "eventType";
}

mixin HCOModalKeys {
  static const String hcoId = "hcoId";
  static const String hcoName = "hcoName";
}
mixin HCPModalKeys {
  static const String hcpId = "id";
  static const String hcpName = "name";
}
