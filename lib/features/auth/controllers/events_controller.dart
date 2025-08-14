import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/hcp_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventController {
  String? _error;
  String? get error => _error;

  Future<List<EventModal>> fetchEvents({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRep/${userModal.id}${status != null ? '?status=$status' : ''}",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        debugPrint("Events TRL 1 ::: $jsonBody");

        final List<dynamic> eventsJson = jsonBody;
        debugPrint("Events TRL 2 ::: ${eventsJson.runtimeType}");
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
        "${AppApi.baseUrl}${AppApi.event}${eventId != null ? '?eventId=$eventId' : ''}",
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

  Future<List<EventModal>> fetchHCOEvents(String hcoId) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.events}ofHco/${hcoId.toString()}",
      );
      debugPrint("uri: ${AppApi.baseUrl}${AppApi.events}ofHco/$hcoId'");
      // return [];
      final response = await http.get(uri);
      debugPrint("response: ${200.runtimeType}");
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        debugPrint("jsonBody: $jsonBody");
        final dynamic eventsJson = jsonBody[EventsModalKeys.events];
        return List<EventModal>.from(
          eventsJson.map((e) => EventModal.fromJson(e)),
        );
      } else {
        debugPrint("Failed to fetch events. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
      return [];
    }
  }

  Future<List<Hcp>> fetchHcp({required String hcoId}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl}${AppApi.hcpLists}?hcoId=${hcoId.toString()}",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return List<Hcp>.from(jsonBody['hcp'].map((e) => Hcp.fromJson(e)));
      } else {
        debugPrint("Failed to fetch hcp. Status: ${response.statusCode}");
        return [
          Hcp(hcpId: '', hcpName: '', specialty: '', contactEmail: '', hco: []),
        ];
      }
    } catch (e) {
      debugPrint("Error fetching hcp: $e");
      return [
        Hcp(hcpId: '', hcpName: '', specialty: '', contactEmail: '', hco: []),
      ];
    }
  }
}
