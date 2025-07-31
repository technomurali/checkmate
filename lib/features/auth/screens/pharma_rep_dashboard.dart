import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';

class PharmaRepDashboard extends StatefulWidget {
  final UserModal user;
  const PharmaRepDashboard({super.key, required this.user});

  @override
  State<PharmaRepDashboard> createState() => _PharmaRepDashboardState();
}

class _PharmaRepDashboardState extends State<PharmaRepDashboard> {
  final EventController _eventController = EventController();
  List<EventModal> events = [];
  List<EventModal> pendingEvents = [];
  List<EventModal> upcomingEvents = [];
  fetchUpcomingEvents() async {
    _eventController
        .fetchEvents(status: "UPCOMING")
        .then(
          (v) => {
            setState(() {
              events = v.take(3).toList();

              upcomingEvents = v
                  .where((e) => e.eventStatus == EventStatus.upcoming)
                  .take(3)
                  .toList();
            }),
          },
        );
  }

  fetchPendingEvents() async {
    _eventController
        .fetchEvents(status: EventStatus.completed)
        .then(
          (v) => {
            setState(() {
              pendingEvents = v
                  .where((e) => e.isApproved == EventStatus.pending)
                  .toList();
            }),
          },
        );
  }

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
    fetchPendingEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Text
          Text(
           "${AppStrings.helloUser} ${widget.user.firstName ?? ''}", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          /// User Role Text
          const Text(
            " ${AppStrings.pharmaRep}",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          /// Upcoming Events
          Text(
            " ${AppStrings.upcomingEvents}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Upcoming Events Card
          EventsReciptsCard(
            items: [
              if (upcomingEvents.isNotEmpty) ...{
                for (var i = 0; i < upcomingEvents.length; i++) ...{
                  {
                    "title": upcomingEvents[i].eventName!,
                    "date": upcomingEvents[i].startDate!,
                    "id": upcomingEvents[i].eventId!,
                    "onTap": () {
                      Provider.of<TopNavProvider>(
                        context,
                        listen: false,
                      ).navigateTo(
                        TopNavScreen.eventDetails,
                        argument: upcomingEvents[i].eventId!,
                      );
                    },
                  },
                },
              } else
                ...{},
            ],
            showCheckIn: true,
            onSeeAll: () {
              Provider.of<TopNavProvider>(
                context,
                listen: false,
              ).navigateTo(TopNavScreen.eventHistory);
            },
          ),

          const SizedBox(height: 16),

          /// Pending Receipts Text
          Text(
            " ${AppStrings.pendingReceipts}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Pending Receipts Card
          EventsReciptsCard(
            isPending: true,
            items: [
              if (pendingEvents.isNotEmpty) ...{
                for (var i = 0; i < 3; i++) ...{
                  {
                    "title": pendingEvents[i].eventName!,
                    "date": pendingEvents[i].startDate!,
                    "id": pendingEvents[i].eventId!,
                  },
                },
              },
            ],
            onSeeAll: () {},
          ),
        ],
      ),
    );
  }
}
