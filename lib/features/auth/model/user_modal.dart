import 'package:checkmate/core/constants/modal_keys.dart';

class UserModal {
  UserModal({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.pharmaCompany,
    required this.role,
    required this.hco,
    required this.profileUrl,
    required this.modeOfAuthentication,
    this.npiNumber,
    this.phoneNumber,
  });

  final String? id;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? pharmaCompany;
  final String? role;
  final List<dynamic>? hco;
  final String? profileUrl;
  final String? modeOfAuthentication;
  final String? npiNumber;
  final String? phoneNumber;

  UserModal copyWith({
    String? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? city,
    String? pharmaCompany,
    String? role,
    List<dynamic>? hco,
    String? profileUrl,
    String? modeOfAuthentication,
    String? npiNumber,
    String? phoneNumber,
  }) {
    return UserModal(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      pharmaCompany: pharmaCompany ?? this.pharmaCompany,
      role: role ?? this.role,
      hco: hco ?? this.hco,
      profileUrl: profileUrl ?? this.profileUrl,
      modeOfAuthentication: modeOfAuthentication ?? this.modeOfAuthentication,
      npiNumber: npiNumber ?? this.npiNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      id: json[ModalKeys().userId],
      email: json[ModalKeys().userEmail],
      password: json[ModalKeys().userPassword],
      firstName: json[ModalKeys().userFirstName],
      lastName: json[ModalKeys().userLastName],
      city: json[ModalKeys().userCity],
      pharmaCompany: json[ModalKeys().userPharmaCompany],
      role: json[ModalKeys().userRole],
      hco: json[ModalKeys().userHco],
      profileUrl: json[ModalKeys().userProfileUrl],
      modeOfAuthentication: json[ModalKeys().userModeOfAuthentication],
      npiNumber: json[ModalKeys().userNpiNumber],
      phoneNumber: json[ModalKeys().userPhoneNumber],
    );
  }

  Map<String, dynamic> toJson() => {
    ModalKeys().userId: id,
    ModalKeys().userEmail: email,
    ModalKeys().userPassword: password,
    ModalKeys().userFirstName: firstName,
    ModalKeys().userLastName: lastName,
    ModalKeys().userCity: city,
    ModalKeys().userPharmaCompany: pharmaCompany,
    ModalKeys().userRole: role,
    ModalKeys().userHco: hco,
    ModalKeys().userProfileUrl: profileUrl,
    ModalKeys().userModeOfAuthentication: modeOfAuthentication,
    ModalKeys().userNpiNumber: npiNumber,
    ModalKeys().userPhoneNumber: phoneNumber,
  };
  factory UserModal.empty() {
    return UserModal(
      id: "0",
      email: '',
      password: 'password',
      firstName: 'firstName',
      lastName: 'lastName',
      city: 'city',
      pharmaCompany: 'pharmaCompany',
      role: 'role',
      hco: [],
      profileUrl: '',
      modeOfAuthentication: '',
      npiNumber: '',
      phoneNumber: '',
    );
  }
}

UserModal userModal = UserModal.empty();
