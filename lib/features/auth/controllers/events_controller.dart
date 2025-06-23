import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventController {
  String? _error;
  String? get error => _error;

  Future<List<EventModal>> fetchEvents({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.events}${status != null ? '?status=$status' : ''}",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        // debugPrint("Events TRL 1 ::: $jsonBody");

        final List<dynamic> eventsJson = jsonBody[EventsModalKeys.events];

        return eventsJson.map((e) => EventModal.fromJson(e)).toList();
      } else {
        debugPrint("Failed to fetch events. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
      return [];
    }
  }

  Future<EventModal> fetchEvent({String? eventId}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.events}${eventId != null ? '?eventId=$eventId' : ''}",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        final dynamic eventsJson = jsonBody[EventsModalKeys.events];

        return EventModal.fromJson(eventsJson);
      } else {
        debugPrint("Failed to fetch events. Status: ${response.statusCode}");
        return EventModal.empty();
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
      return EventModal.empty();
    }
  }
}
