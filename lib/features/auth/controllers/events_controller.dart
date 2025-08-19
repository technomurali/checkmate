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

  Future<List<EventModal>> fetchEventsWithStatus({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndStatus/${userModal.id}/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndStatus/${userModal.id}/$status",
      );
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

  Future<List<EventModal>> fetchEventsWithPending({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndApproval/${userModal.id}/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndStatus/${userModal.id}/$status",
      );
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
      final uri = Uri.parse("${AppApi.baseUrl1}${AppApi.events}/$eventId");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        final dynamic eventsJson = jsonBody;
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

  Future<String> getHcoName(String hcoId) async {
    try {
      //https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/Accounts/88dfb0a4-a1fd-ee11-a1fe-000d3a30eadf
      final uri = "${AppApi.baseUrl1}/Accounts/$hcoId";
      final responce = await http.get(Uri.parse(uri));
      if (responce.statusCode == AppApiStatusCodes.success) {
        final jsonBody = json.decode(responce.body);
        return jsonBody["accountName"];
      } else {
        return "Error Fetching HCO Name";
      }
    } catch (e) {
      debugPrint("Error fetching hcp: $e");
      return "";
    }
  }

  Future<List<Hcp>> fetchHcp({required String hcoId}) async {
    try {
      final uri = Uri.parse("${AppApi.baseUrl1}/Contact/physicians-active");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return List<Hcp>.from(jsonBody.map((e) => Hcp.fromJson(e)));
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

  Future<int> deleteEvent(String eventId) async {
    try {
      //https://checkmate-qa-aggnd3ahabbudhdm.canadacentral-01.azurewebsites.net/api/Events/40272d55-267c-f011-b4cc-6045bd0460f1
      final uri = Uri.parse("${AppApi.baseUrl1}${AppApi.events}/$eventId");
      final responce = await http.delete(uri);
      return responce.statusCode;
    } catch (e) {
      debugPrint("Error Deleting Event $e");
      return AppApiStatusCodes.error;
    }
  }
}
