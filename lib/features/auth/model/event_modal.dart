import 'dart:convert';

import 'package:flutter/material.dart';

class EventModal {
  final String? eventId;
  final String? eventName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? numberOfStaff;
  final double? amount;
  final double? eventCostByPerson;
  final String? hco;
  final List<ContactDto>? contactDtos;
  final int? eventType;
  final int? eventStatus;
  final String? eventDescription;
  final int? eventApproval;
  final String? userName;
  final bool isMultiDay;

  EventModal({
    this.eventId,
    this.eventName,
    this.startDate,
    this.endDate,
    this.numberOfStaff,
    this.amount,
    this.eventCostByPerson,
    this.hco,
    this.contactDtos,
    this.eventType,
    this.eventStatus,
    this.eventDescription,
    this.eventApproval,
    this.userName,
    this.isMultiDay = false,
  });

  EventModal copyWith({
    String? eventId,
    String? eventName,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfStaff,
    double? amount,
    double? eventCostByPerson,
    String? hco,
    List<ContactDto>? contactDtos,
    int? eventType,
    int? eventStatus,
    String? eventDescription,
    int? eventApproval,
    String? userName,
    bool? isMultiDay,
  }) => EventModal(
    eventId: eventId ?? this.eventId,
    eventName: eventName ?? this.eventName,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    numberOfStaff: numberOfStaff ?? this.numberOfStaff,
    amount: amount ?? this.amount,
    eventCostByPerson: eventCostByPerson ?? this.eventCostByPerson,
    hco: hco ?? this.hco,
    contactDtos: contactDtos ?? this.contactDtos,
    eventType: eventType ?? this.eventType,
    eventStatus: eventStatus ?? this.eventStatus,
    eventDescription: eventDescription ?? this.eventDescription,
    eventApproval: eventApproval ?? this.eventApproval,
    userName: userName ?? this.userName,
    isMultiDay: isMultiDay ?? false,
  );

  factory EventModal.fromJson(Map<String, dynamic> json) {
    debugPrint("EventModal.fromJson: ${jsonEncode(json)}");
    return EventModal(
      eventId: json["eventId"],
      eventName: json["eventName"],
      startDate: json["startDate"] == null
          ? null
          : _parseDateTime(json["startDate"]),
      endDate: json["endDate"] == null ? null : _parseDateTime(json["endDate"]),
      numberOfStaff: json["numberOfStaff"],
      amount: double.parse(json["amount"].toString()),
      eventCostByPerson: double.parse(json["eventCostByPerson"].toString()),
      hco: json["hco"],
      contactDtos: json["contactDtos"] == null
          ? []
          : List<ContactDto>.from(
              json["contactDtos"]!.map((x) => ContactDto.fromJson(x)),
            ),
      eventType: json["eventType"],
      eventStatus: json["eventStatus"],
      eventDescription: json["eventDescription"],
      eventApproval: json["eventApproval"],
      userName: json["userName"],
      isMultiDay: json['isMultiDay'] ?? false,
    );
  }

  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;
    if (dateValue is DateTime) return dateValue;
    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue).toLocal();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    "eventName": eventName,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "numberOfStaff": numberOfStaff,
    "amount": amount,
    "eventCostByPerson": eventCostByPerson,
    "hco": hco,
    "contactDtos": contactDtos == null
        ? []
        : List<dynamic>.from(contactDtos!.map((x) => x.toJson())),
    "eventType": eventType,
    "eventStatus": eventStatus,
    "eventDescription": eventDescription,
    "eventApproval": eventApproval,
    "userName": userName,
    "isMultiDay": isMultiDay,
  };

  factory EventModal.empty() => EventModal(
    eventId: "",
    eventName: "",
    startDate: null,
    endDate: null,
    numberOfStaff: 0,
    amount: 0,
    eventCostByPerson: 0,
    hco: "",
    contactDtos: [],
    eventType: 0,
    eventStatus: 0,
    eventDescription: "",
    eventApproval: 0,
    userName: "",
    isMultiDay: false,
  );
}

class ContactDto {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? jobTitle;
  final String? company;

  ContactDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.jobTitle,
    this.company,
  });

  ContactDto copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? jobTitle,
    String? company,
  }) => ContactDto(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    jobTitle: jobTitle ?? this.jobTitle,
    company: company ?? this.company,
  );

  factory ContactDto.fromJson(Map<String, dynamic> json) => ContactDto(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    jobTitle: json["jobTitle"],
    company: json["company"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "jobTitle": jobTitle,
    "company": company,
  };
}
