import 'package:checkmate/core/constants/modal_keys.dart';

class SignUpModel {
  SignUpModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.pharmaCompany,
    required this.companyId,
    required this.userRoleId,
    // "companyId": "string",
    // "userRoleId": "string",
  });

  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? pharmaCompany;
  final String companyId;
  final String userRoleId;

  SignUpModel copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? city,
    String? pharmaCompany,
    String? companyId,
    String? userRoleId,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      pharmaCompany: pharmaCompany ?? this.pharmaCompany,
      userRoleId: userRoleId ?? this.userRoleId,
      companyId: companyId ?? this.companyId,
    );
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      email: json[ModalKeys().email],
      password: json[ModalKeys().password],
      firstName: json[ModalKeys().firstName],
      lastName: json[ModalKeys().lastName],
      city: json[ModalKeys().city],
      pharmaCompany: json[ModalKeys().pharmaCompany],
      userRoleId: json['userRoleId'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() => {
    ModalKeys().email: email,
    ModalKeys().password: password,
    ModalKeys().firstName: firstName,
    ModalKeys().lastName: lastName,
    ModalKeys().city: city,
    ModalKeys().pharmaCompany: pharmaCompany,
    'userRoleId': userRoleId,
    "companyId": companyId,
  };
}
