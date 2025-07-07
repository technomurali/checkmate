import 'package:checkmate/core/constants/modal_keys.dart';

class EventModal with EventsModalKeys {
  EventModal({
    required this.eventId,
    required this.pharmaRepId,
    required this.pharmaRepName,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.numberOfStaff,
    required this.hco,
    required this.hcp,
    required this.amount,
    required this.eventStatus,
    required this.isApproved,
    required this.eventDescription,
    required this.eventType,
  });

  final String? eventId;
  final String? pharmaRepId;
  final String? pharmaRepName;
  final String? eventName;
  final String? startDate;
  final String? endDate;
  final String? numberOfStaff;
  final List<dynamic> hco;
  final List<dynamic> hcp;
  final String? amount;
  final String? eventStatus;
  final String? isApproved;
  final String? eventDescription;
  final String? eventType;

  EventModal copyWith({
    String? eventId,
    String? pharmaRepId,
    String? pharmaRepName,
    String? eventName,
    String? startDate,
    String? endDate,
    String? numberOfStaff,
    List<dynamic>? hco,
    List<dynamic>? hcp,
    String? amount,
    String? eventStatus,
    String? eventDescription,
    String? eventType,
  }) {
    return EventModal(
      eventId: eventId ?? this.eventId,
      pharmaRepId: pharmaRepId ?? this.pharmaRepId,
      pharmaRepName: pharmaRepName ?? this.pharmaRepName,
      eventName: eventName ?? this.eventName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfStaff: numberOfStaff ?? this.numberOfStaff,
      hco: hco ?? this.hco,
      hcp: hcp ?? this.hcp,
      amount: amount ?? this.amount,
      eventStatus: eventStatus ?? this.eventStatus,
      isApproved: isApproved ?? isApproved,
      eventDescription: eventDescription ?? this.eventDescription,
      eventType: eventType ?? this.eventType,
    );
  }

  factory EventModal.fromJson(Map<String, dynamic> json) {
    return EventModal(
      eventId: json[EventsModalKeys.eventIdKey],
      pharmaRepId: json[EventsModalKeys.eventPharmaRepId],
      pharmaRepName: json[EventsModalKeys.eventPharmaRepName],
      eventName: json[EventsModalKeys.eventNameKey],
      startDate: json[EventsModalKeys.eventStartDate],
      endDate: json[EventsModalKeys.eventEndDate],
      numberOfStaff: json[EventsModalKeys.eventNumberOfStaff],
      hco: json[EventsModalKeys.eventHCO] == null
          ? []
          : List<dynamic>.from(json[EventsModalKeys.eventHCO].map((x) => x)),
      hcp: json[EventsModalKeys.eventHCP] == null
          ? []
          : List<dynamic>.from(json[EventsModalKeys.eventHCP].map((x) => x)),
      amount: json[EventsModalKeys.eventAmount],
      eventStatus: json[EventsModalKeys.eventStatusKey],
      isApproved: json[EventsModalKeys.eventApprovalStatus],
      eventDescription: json[EventsModalKeys.eventDescription],
      eventType: json[EventsModalKeys.eventType],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EventsModalKeys.eventIdKey: eventId,
      EventsModalKeys.eventPharmaRepId: pharmaRepId,
      EventsModalKeys.eventPharmaRepName: pharmaRepName,
      EventsModalKeys.eventNameKey: eventName,
      EventsModalKeys.eventStartDate: startDate,
      EventsModalKeys.eventEndDate: endDate,
      EventsModalKeys.eventNumberOfStaff: numberOfStaff,
      EventsModalKeys.eventHCO: hco,
      EventsModalKeys.eventHCP: hcp,
      EventsModalKeys.eventAmount: amount,
      EventsModalKeys.eventStatusKey: eventStatus,
      EventsModalKeys.eventApprovalStatus: isApproved,
      EventsModalKeys.eventDescription: eventDescription,
      EventsModalKeys.eventType: eventType,
    };
  }

  static EventModal empty() {
    return EventModal(
      eventId: '',
      pharmaRepId: '',
      pharmaRepName: '',
      eventName: 'Unknown Event',
      startDate: '',
      endDate: '',
      numberOfStaff: '0',
      hco: [],
      hcp: [],
      amount: '0',
      eventStatus: 'UNKNOWN',
      isApproved: '',
      eventDescription: '',
      eventType: '',
    );
  }
}
