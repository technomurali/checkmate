import 'dart:convert';

import 'package:checkmate/features/auth/model/hcp_modal.dart';

HcoModal hcoModalFromJson(String str) => HcoModal.fromJson(json.decode(str));

String hcoModalToJson(HcoModal data) => json.encode(data.toJson());

class HcoModal {
  String hcoId;
  String hcoName;
  List<Hcp> hcps;
  List<OfficeUser> officeUsers;

  HcoModal({
    required this.hcoId,
    required this.hcoName,
    required this.hcps,
    required this.officeUsers,
  });

  HcoModal copyWith({
    String? hcoId,
    String? hcoName,
    List<Hcp>? hcps,
    List<OfficeUser>? officeUsers,
  }) => HcoModal(
    hcoId: hcoId ?? this.hcoId,
    hcoName: hcoName ?? this.hcoName,
    hcps: hcps ?? this.hcps,
    officeUsers: officeUsers ?? this.officeUsers,
  );

  factory HcoModal.fromJson(Map<String, dynamic> json) => HcoModal(
    hcoId: json["hcoId"],
    hcoName: json["hcoName"],
    hcps: List<Hcp>.from(json["hcps"].map((x) => Hcp.fromJson(x))),
    officeUsers: List<OfficeUser>.from(
      json["office_users"].map((x) => OfficeUser.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "hcoId": hcoId,
    "hcoName": hcoName,
    "hcps": List<dynamic>.from(hcps.map((x) => x.toJson())),
    "office_users": List<dynamic>.from(officeUsers.map((x) => x.toJson())),
  };
}

class OfficeUser {
  String userName;
  String hcoUId;

  OfficeUser({required this.userName, required this.hcoUId});

  OfficeUser copyWith({String? userName, String? hcoUId}) => OfficeUser(
    userName: userName ?? this.userName,
    hcoUId: hcoUId ?? this.hcoUId,
  );

  factory OfficeUser.fromJson(Map<String, dynamic> json) =>
      OfficeUser(userName: json["userName"], hcoUId: json["hcoUId"]);

  Map<String, dynamic> toJson() => {"userName": userName, "hcoUId": hcoUId};
}
