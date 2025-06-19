import 'package:checkmate/core/constants/modal_keys.dart';

class SignUpModel {
  SignUpModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.pharmaCompany,
  });

  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? pharmaCompany;

  SignUpModel copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? city,
    String? pharmaCompany,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      pharmaCompany: pharmaCompany ?? this.pharmaCompany,
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
    );
  }

  Map<String, dynamic> toJson() => {
    ModalKeys().email: email,
    ModalKeys().password: password,
    ModalKeys().firstName: firstName,
    ModalKeys().lastName: lastName,
    ModalKeys().city: city,
    ModalKeys().pharmaCompany: pharmaCompany,
  };
}
