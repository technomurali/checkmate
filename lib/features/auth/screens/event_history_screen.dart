import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/event_list_item_tile.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/material.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({super.key});

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  final EventController _eventController = EventController();
  List<EventModal> events = [];
  @override
  void initState() {
    super.initState();
    fetchAllEvents();
  }

  fetchAllEvents() {
    _eventController.fetchEvents().then(
      (v) => {
        setState(() {
          events = v;
        }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.eventHistory)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, i) {
            return EventListItemTile(
              eventName: events[i].eventName!,
              startDate: events[i].startDate!,
              endDate: events[i].endDate!,
              pharmaRep: events[i].pharmaRepName!,
              id: events[i].eventId!,
              status: events[i].eventStatus!,
            );
          },
        ),
      ),
    );
  }
}
