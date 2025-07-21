import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/features/auth/top_nav_provider.dart';

class HCPDashboard extends StatefulWidget {
  final UserModal user;
  const HCPDashboard({super.key, required this.user});

  @override
  State<HCPDashboard> createState() => _HCPDashboardState();
}

class _HCPDashboardState extends State<HCPDashboard> {
  final EventController _eventController = EventController();
  List<EventModal> events = [];
  fetchUpcomingEvents() async {
    _eventController
        .fetchEvents(status: "UPCOMING")
        .then(
          (v) => {
            setState(() {
              events = v.take(3).toList();
              debugPrint("Events ::: $events");
            }),
          },
        );
  }

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Text
          Text(
            " ${AppStrings.helloUser} ${widget.user.firstName}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          /// User Role Text
          const Text(" ${AppStrings.labelHCP}", style: TextStyle(fontSize: 16)),

          const SizedBox(height: 20),

          /// Upcoming Events Text
          Text(
            " ${AppStrings.upcomingEvents}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Upcoming Events Card
          EventsReciptsCard(
            items: [
              if (events.isNotEmpty) ...{
                for (var i = 0; i < 3; i++) ...{
                  {
                    "title": events[i].eventName!,
                    "date": events[i].startDate!,
                    "id": events[i].eventId!,
                    "onTap": () {
                      Provider.of<TopNavProvider>(
                        context,
                        listen: false,
                      ).navigateTo(
                        TopNavScreen.eventDetails,
                        argument: events[i].eventId!,
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

          /// Receipts for Approval Text
          Text(
            " ${AppStrings.receiptForApproval}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Receipts for Approval Card
          EventsReciptsCard(
            items: const [
              {"title": "diabetesCareSolutions", "date": "26/JUNE/2024"},
              {"title": "diabetesCareSolutions", "date": "26/JUNE/2024"},
              {"title": "respiratoryTherapy", "date": "26/JUNE/2024"},
            ],
            onSeeAll: () {},
          ),
        ],
      ),
    );
  }
}
