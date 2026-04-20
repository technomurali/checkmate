class SignUpModel {
  SignUpModel({
    required this.emailaddress1,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.pharmaCompany,
    required this.companyId,
    required this.crddbContacttype,
    this.phoneNumber,
    this.street,
    this.postalCode,
    this.country,
  });

  // CRM contract field name for contact email.
  final String? emailaddress1;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? pharmaCompany;
  final String companyId;
  // CRM contract field name for contact type.
  final String crddbContacttype;
  final String? phoneNumber;
  final String? street;
  final String? postalCode;
  final String? country;

  SignUpModel copyWith({
    String? emailaddress1,
    String? password,
    String? firstName,
    String? lastName,
    String? city,
    String? pharmaCompany,
    String? companyId,
    String? crddbContacttype,
    String? phoneNumber,
    String? street,
    String? postalCode,
    String? country,
  }) {
    return SignUpModel(
      emailaddress1: emailaddress1 ?? this.emailaddress1,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      pharmaCompany: pharmaCompany ?? this.pharmaCompany,
      crddbContacttype: crddbContacttype ?? this.crddbContacttype,
      companyId: companyId ?? this.companyId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> address =
        json['address'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['address'])
        : <String, dynamic>{};

    return SignUpModel(
      emailaddress1:
          json['emailaddress1']?.toString() ?? json['email']?.toString(),
      password: json['password']?.toString(),
      firstName: json['firstname']?.toString() ?? json['firstName']?.toString(),
      lastName: json['lastname']?.toString() ?? json['lastName']?.toString(),
      city: address['city']?.toString() ?? json['city']?.toString(),
      pharmaCompany: json['pharmaCompany']?.toString(),
      crddbContacttype:
          json['crddb_contacttype']?.toString() ??
          json['userRoleId']?.toString() ??
          '',
      companyId: json['companyId'],
      phoneNumber:
          json['telephone1']?.toString() ?? json['phoneNumber']?.toString(),
      street: address['street']?.toString(),
      postalCode: address['postalCode']?.toString(),
      country: address['country']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final normalizedEmail = (emailaddress1 ?? '').trim();
    final normalizedFirstName = (firstName ?? '').trim();
    final normalizedLastName = (lastName ?? '').trim();

    final derivedUserName = normalizedEmail.contains('@')
        ? normalizedEmail.split('@').first
        : normalizedFirstName;
    final displayName = [normalizedFirstName, normalizedLastName]
        .where((value) => value.isNotEmpty)
        .join(' ');

    return {
      'userName': derivedUserName,
      'password': (password ?? '').trim(),
      'displayName': displayName.isEmpty ? derivedUserName : displayName,
      'firstname': normalizedFirstName,
      'lastname': normalizedLastName,
      'emailaddress1': normalizedEmail,
      'telephone1': (phoneNumber ?? '').trim(),
      'companyId': companyId,
      'crddb_contacttype': int.tryParse(crddbContacttype) ?? 546170001,
      'address': {
        'street': (street ?? '').trim(),
        'city': (city ?? '').trim(),
        'postalCode': (postalCode ?? '').trim(),
        'country': (country ?? '').trim(),
      },
    };
  }
}
