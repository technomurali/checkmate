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
      pharmaCompanies: json["pharma_companies"] == null
          ? []
          : List<String>.from(json["pharma_companies"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "pharma_companies": pharmaCompanies.map((x) => x).toList(),
  };
}
