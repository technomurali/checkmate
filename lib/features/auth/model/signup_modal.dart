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
      email: json["email"],
      password: json["password"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      city: json["city"],
      pharmaCompany: json["pharmaCompany"],
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "city": city,
    "pharmaCompany": pharmaCompany,
  };
}
