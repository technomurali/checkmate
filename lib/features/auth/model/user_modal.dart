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
  });

  final int? id;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? pharmaCompany;

  UserModal copyWith({
    int? id,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? city,
    String? pharmaCompany,
  }) {
    return UserModal(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      pharmaCompany: pharmaCompany ?? this.pharmaCompany,
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
  };
  factory UserModal.empty() {
    return UserModal(
      id: 0,
      email: '',
      password: 'password',
      firstName: 'firstName',
      lastName: 'lastName',
      city: 'city',
      pharmaCompany: 'pharmaCompany',
    );
  }
}

UserModal userModal = UserModal.empty();
