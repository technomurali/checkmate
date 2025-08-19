import 'dart:convert';

// class HcpModal {
//     List<Hcp> hcp;
//     String message;

//     HcpModal({
//         required this.hcp,
//         required this.message,
//     });

//     HcpModal copyWith({
//         List<Hcp>? hcp,
//         String? message,
//     }) =>
//         HcpModal(
//             hcp: hcp ?? this.hcp,
//             message: message ?? this.message,
//         );

//     factory HcpModal.fromRawJson(String str) => HcpModal.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory HcpModal.fromJson(Map<String, dynamic> json) => HcpModal(
//         hcp: List<Hcp>.from(json["hcp"].map((x) => Hcp.fromJson(x))),
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "hcp": List<dynamic>.from(hcp.map((x) => x.toJson())),
//         "message": message,
//     };
// }

class Hcp {
  String hcpId;
  String hcpName;
  String? specialty;
  String? contactEmail;
  List<Hco>? hco;
  String? npiNumber;
  String? phoneNumber;

  Hcp({
    required this.hcpId,
    required this.hcpName,
    this.specialty,
    this.contactEmail,
    this.hco,
    this.npiNumber,
    this.phoneNumber,
  });

  Hcp copyWith({
    String? hcpId,
    String? hcpName,
    String? specialty,
    String? contactEmail,
    List<Hco>? hco,
    String? npiNumber,
    String? phoneNumber,
  }) => Hcp(
    hcpId: hcpId ?? this.hcpId,
    hcpName: hcpName ?? this.hcpName,
    specialty: specialty ?? this.specialty,
    contactEmail: contactEmail ?? this.contactEmail,
    hco: hco ?? this.hco,
    npiNumber: npiNumber ?? this.npiNumber,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );

  factory Hcp.fromRawJson(String str) => Hcp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hcp.fromJson(Map<String, dynamic> json) => Hcp(
    hcpId: json["id"],
    hcpName: json["firstName"] + json['lastName'],
    specialty: json["specialty"] ?? '',
    contactEmail: json["email"],
    hco: json['hco'] != null
        ? List<Hco>.from(json["hco"].map((x) => Hco.fromJson(x)))
        : [],
    npiNumber: json["npiNumber"] ?? "",
    phoneNumber: json["phoneNumber"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": hcpId,
    "firstName": hcpName.split(' ')[0],
    "lastName": hcpName.split(' ')[1],
    "specialty": specialty,
    "email": contactEmail,
    "hco": List<dynamic>.from(hco?.map((x) => x.toJson()) ?? []),
    "npiNumber": npiNumber,
    "phoneNumber": phoneNumber,
  };
}

class Hco {
  String hcoName;
  String hcoId;

  Hco({required this.hcoName, required this.hcoId});

  Hco copyWith({String? hcoName, String? hcoId}) =>
      Hco(hcoName: hcoName ?? this.hcoName, hcoId: hcoId ?? this.hcoId);

  factory Hco.fromRawJson(String str) => Hco.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hco.fromJson(Map<String, dynamic> json) =>
      Hco(hcoName: json["hcoName"], hcoId: json["hcoId"]);

  Map<String, dynamic> toJson() => {"hcoName": hcoName, "hcoId": hcoId};
}
