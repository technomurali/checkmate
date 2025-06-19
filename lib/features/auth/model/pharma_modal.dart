import 'package:checkmate/core/constants/modal_keys.dart';

class PharmaModel {
  PharmaModel({required this.pharmaCompanies});

  final List<String> pharmaCompanies;

  PharmaModel copyWith({List<String>? pharmaCompanies}) {
    return PharmaModel(
      pharmaCompanies: pharmaCompanies ?? this.pharmaCompanies,
    );
  }

  factory PharmaModel.fromJson(Map<String, dynamic> json) {
    return PharmaModel(
      pharmaCompanies: json[ModalKeys().pharmaCompanies] == null
          ? []
          : List<String>.from(json[ModalKeys().pharmaCompanies]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    ModalKeys().pharmaCompanies: pharmaCompanies.map((x) => x).toList(),
  };
}
