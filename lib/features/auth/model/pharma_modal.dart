import 'package:checkmate/core/constants/modal_keys.dart';

class PharmaModel {
  PharmaModel({required this.pharmaCompanies});

  final List<Map> pharmaCompanies;

  PharmaModel copyWith({List<Map>? pharmaCompanies}) {
    return PharmaModel(
      pharmaCompanies: pharmaCompanies ?? this.pharmaCompanies,
    );
  }

  factory PharmaModel.fromJson(Map<String, dynamic> json) {
    return PharmaModel(
      pharmaCompanies: json[ModalKeys().pharmaModalCompanies] == null
          ? []
          : List<Map>.from(
              json[ModalKeys().pharmaModalCompanies]!.map((x) => x),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    ModalKeys().pharmaModalCompanies: pharmaCompanies.map((x) => x).toList(),
  };
}
