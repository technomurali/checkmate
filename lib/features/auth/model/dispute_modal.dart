import 'dart:convert';

class DisputeModal {
  final String? disputeId;
  final HcpDetails? hcpDetails;
  final TransactionDetails? transactionDetails;
  final DisputeReason? disputeReason;
  final List<SupportingDocument>? supportingDocuments;
  final bool? declarationConfirmed;
  final DateTime? submittedAt;
  final String? status;

  DisputeModal({
    this.disputeId,
    this.hcpDetails,
    this.transactionDetails,
    this.disputeReason,
    this.supportingDocuments,
    this.declarationConfirmed,
    this.submittedAt,
    this.status,
  });

  factory DisputeModal.fromRawJson(String str) =>
      DisputeModal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DisputeModal.fromJson(Map<String, dynamic> json) => DisputeModal(
    hcpDetails: json["hcpDetails"] == null
        ? null
        : HcpDetails.fromJson(json["hcpDetails"]),
    transactionDetails: json["transactionDetails"] == null
        ? null
        : TransactionDetails.fromJson(json["transactionDetails"]),
    disputeReason: json["disputeReason"] == null
        ? null
        : DisputeReason.fromJson(json["disputeReason"]),
    supportingDocuments: json["supportingDocuments"] == null
        ? []
        : List<SupportingDocument>.from(
            json["supportingDocuments"]!.map(
              (x) => SupportingDocument.fromJson(x),
            ),
          ),
    declarationConfirmed: json["declarationConfirmed"],
    submittedAt: json["submittedAt"] == null
        ? null
        : DateTime.parse(json["submittedAt"]),
    status: json["status"],
    disputeId: json['disputeId'],
  );

  Map<String, dynamic> toJson() => {
    "disputeId": disputeId,
    "hcpDetails": hcpDetails?.toJson(),
    "transactionDetails": transactionDetails?.toJson(),
    "disputeReason": disputeReason?.toJson(),
    "supportingDocuments": supportingDocuments == null
        ? []
        : List<dynamic>.from(supportingDocuments!.map((x) => x.toJson())),
    "declarationConfirmed": declarationConfirmed,
    "submittedAt": submittedAt?.toIso8601String(),
    "status": status,
  };

  empty() {
    return DisputeModal(
      disputeId: "",
      hcpDetails: HcpDetails(),
      transactionDetails: TransactionDetails(),
      disputeReason: DisputeReason(),
      supportingDocuments: [],
    );
  }
}

class DisputeReason {
  final String? disputeCategory;
  final String? description;

  DisputeReason({this.disputeCategory, this.description});

  factory DisputeReason.fromRawJson(String str) =>
      DisputeReason.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DisputeReason.fromJson(Map<String, dynamic> json) => DisputeReason(
    disputeCategory: json["disputeCategory"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "disputeCategory": disputeCategory,
    "description": description,
  };
}

class HcpDetails {
  final String? fullName;
  final String? npiNumber;
  final String? organizationName;
  final String? email;
  final String? phone;

  HcpDetails({
    this.fullName,
    this.npiNumber,
    this.organizationName,
    this.email,
    this.phone,
  });

  factory HcpDetails.fromRawJson(String str) =>
      HcpDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HcpDetails.fromJson(Map<String, dynamic> json) => HcpDetails(
    fullName: json["fullName"],
    npiNumber: json["npiNumber"],
    organizationName: json["organizationName"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "npiNumber": npiNumber,
    "organizationName": organizationName,
    "email": email,
    "phone": phone,
  };
}

class SupportingDocument {
  final String? fileName;
  final String? fileUrl;

  SupportingDocument({this.fileName, this.fileUrl});

  factory SupportingDocument.fromRawJson(String str) =>
      SupportingDocument.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupportingDocument.fromJson(Map<String, dynamic> json) =>
      SupportingDocument(fileName: json["fileName"], fileUrl: json["fileUrl"]);

  Map<String, dynamic> toJson() => {"fileName": fileName, "fileUrl": fileUrl};
}

class TransactionDetails {
  final String? pharmaCompany;
  final String? eventInteraction;
  final String? paymentDate;
  final String? paymentAmount;
  final String? paymentType;
  final String? referenceNumber;

  TransactionDetails({
    this.pharmaCompany,
    this.eventInteraction,
    this.paymentDate,
    this.paymentAmount,
    this.paymentType,
    this.referenceNumber,
  });

  factory TransactionDetails.fromRawJson(String str) =>
      TransactionDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
        pharmaCompany: json["pharmaCompany"],
        eventInteraction: json["eventInteraction"],
        paymentDate: json["paymentDate"] == null ? null : json["paymentDate"],
        paymentAmount: json["paymentAmount"],
        paymentType: json["paymentType"],
        referenceNumber: json["referenceNumber"],
      );

  Map<String, dynamic> toJson() => {
    "pharmaCompany": pharmaCompany,
    "eventInteraction": eventInteraction,
    "paymentDate": "$paymentDate",
    "paymentAmount": paymentAmount,
    "paymentType": paymentType,
    "referenceNumber": referenceNumber,
  };
}
