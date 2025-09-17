import 'dart:convert';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/features/auth/controllers/interceptor.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/hcp_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
// import 'package:http/http.dart' as http;

class EventController {
  String? _error;
  String? get error => _error;
  Client http = InterceptedClient.build(interceptors: [Interceptor()]);
  Future<List<EventModal>> fetchEvents({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRep/${userModal.kiosk}${status != null ? '?status=$status' : ''}",
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

  Future<List<EventModal>> fetchHcpEvents({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByHcp/${userModal.kiosk}${status != null ? '?status=$status' : ''}",
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

  Future<List<EventModal>> fetchOfficeuserEvents(hcoId) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByHco/${hcoId.toString()}",
      );
      debugPrint(
        "uri: ${AppApi.baseUrl1}${AppApi.events}/getEventsByHco/${hcoId.toString()}}",
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
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndStatus/${userModal.kiosk}/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByRepAndApproval/${userModal.kiosk}/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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

  Future<List<EventModal>> fetchHcpEventsWithStatus({String? status}) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByHcpAndStatus/${userModal.kiosk}/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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

  Future<List<EventModal>> fetchHcpEventsWithPending({String? status}) async {
    //Events/doctors/events/956f74f7-0b8b-f011-b4cc-6045bd0460f1
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/doctors/events/${userModal.kiosk}",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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

  Future<List<EventModal>> fetchEventsHCOWithStatus({
    String? status,
    hcoId,
  }) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByHcoAndStatus/$hcoId/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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

  Future<List<EventModal>> fetchEventsHCOWithPending({
    String? status,
    String? hcoId,
  }) async {
    try {
      final uri = Uri.parse(
        "${AppApi.baseUrl1}${AppApi.events}/getEventsByHcoAndApproval/$hcoId/$status",
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
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

  Future<bool> updateEvent(String eventId, body) async {
    try {
      final uri = Uri.parse("${AppApi.baseUrl1}${AppApi.events}/$eventId");
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
      if (response.statusCode == AppApiStatusCodes.postSuccess) {
        debugPrint("Event updated successfully.");
        return true;
      } else {
        debugPrint("Failed to update event. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error updating event: $e");
      return false;
    }
  }

  // Attachments Receipts
  Future<Response> eventAttachments(
    List<Map<String, dynamic>> body,
    String eventId,
  ) async {
    var data = json.encode(body);
    try {
      final uri = Uri.parse(AppApi.buildAttachmentsUrl(eventId));
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: data,
      );
      return response;
    } catch (e) {
      debugPrint("Error updating event: $e");
      return Response('Error', 400);
    }
  }

  Future submitCheckIn(Map<String, dynamic> payload, String id) async {
    var url = Uri.parse(
      "${AppApi.baseUrl1}${AppApi.events}/${AppApi.events}/$id",
    );
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      debugPrint("submitCheckIn payload: ${jsonEncode(payload)}");
      if (response.statusCode == AppApiStatusCodes.postSuccess) {
        debugPrint("Check-In submitted successfully.");
        return true;
      } else {
        debugPrint("Failed to submit Check-In. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error submitting Check-In: $e");
      return false;
    }
  }

  Future<Response> approve(eventId, doctorId, remarks) async {
    var url = Uri.parse(AppApi.buildApprovalUrl(eventId, doctorId, "remarks"));
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint(
        "approvebyHcp payload: ${jsonEncode({'eventId': eventId, 'doctorId': doctorId, 'remarks': remarks})}",
      );
      return response;
    } catch (e) {
      debugPrint("Error submitting approvebyHcp: $e");
      return Response('Error : $e', 400);
    }
  }

  Future<Response> reject(eventId, doctorId, remarks) async {
    var url = Uri.parse(
      AppApi.buildRejectionUrl(eventId, doctorId, "$remarks"),
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint(
        "approvebyHcp payload: ${jsonEncode({'eventId': eventId, 'doctorId': doctorId, 'remarks': remarks})}",
      );
      return response;
    } catch (e) {
      debugPrint("Error submitting approvebyHcp: $e");
      return Response('Error : $e', 400);
    }
  }

  Future<Response> fetchEventAttachments(String eventId) async {
    final uri = Uri.parse(AppApi.buildAttachmentsUrl(eventId));
    try {
      return await http.get(uri, headers: {'Content-Type': 'application/json'});
    } catch (e) {
      debugPrint("Error fetching event attachments: $e");
      return Response('Error', 400);
    }
  }
}
