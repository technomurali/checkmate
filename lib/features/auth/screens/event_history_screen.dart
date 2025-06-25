import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/event_list_item_tile.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({super.key});

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen>
    with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  List<EventModal> events = [];
  SlidableController? _slidableController;
  @override
  void initState() {
    super.initState();
    fetchAllEvents();
    // Initialize controller
    _slidableController = SlidableController(this);

    // Animate first tile after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      _slidableController?.openEndActionPane();
      await Future.delayed(const Duration(seconds: 2));
      _slidableController?.close();
    });
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
            return Slidable(
              startActionPane: ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      // TODO: handle delete
                    },
                    backgroundColor: AppColors.accentError,
                    foregroundColor: AppColors.background,
                    icon: Icons.delete,
                  ),
                ],
              ),
              key: ValueKey(events[i].eventId),

              child: EventListItemTile(
                eventName: events[i].eventName!,
                startDate: events[i].startDate!,
                endDate: events[i].endDate!,
                pharmaRep: events[i].pharmaRepName!,
                id: events[i].eventId!,
                status: events[i].eventStatus!,
              ),
            );
          },
        ),
      ),
    );
  }
}
