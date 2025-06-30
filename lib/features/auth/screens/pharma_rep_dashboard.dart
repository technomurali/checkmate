import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/app_appbar.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/drawer_screen.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/new_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmaRepDashboard extends StatefulWidget {
  final UserModal user;
  const PharmaRepDashboard({super.key, required this.user});

  @override
  State<PharmaRepDashboard> createState() => _PharmaRepDashboardState();
}

class _PharmaRepDashboardState extends State<PharmaRepDashboard> {
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
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppAppbar(
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.border,
              child: FaIcon(
                FontAwesomeIcons.user,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " ${AppStrings.helloUser} ${widget.user.firstName}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              " ${AppStrings.pharmaRep}",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            Text(
              " ${AppStrings.upcomingEvents}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            EventsReciptsCard(
              items: [
                if (events.isNotEmpty) ...{
                  for (var i = 0; i < 3; i++) ...{
                    {
                      "title": events[i].eventName!,
                      "date": events[i].startDate!,
                      "id": events[i].eventId!,
                    },
                  },
                } else
                  ...{},
                // {"title": events[0].eventName!, "date": events[0].startDate!},
                // {"title": events[1].eventName!, "date": events[1].startDate!},
              ],
              showCheckIn: true,
              onSeeAll: () {},
            ),

            const SizedBox(height: 16),
            Text(
              " ${AppStrings.pendingReceipts}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            EventsReciptsCard(
              items: const [
                {"title": "diabetesCareSolutions", "date": "26/JUNE/2024"},
                {"title": "diabetesCareSolutions", "date": "26/JUNE/2024"},
                {"title": "respiratoryTherapy", "date": "26/JUNE/2024"},
              ],
              onSeeAll: () {},
            ),

            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.7,
              children: [
                Button(
                  text: AppStrings.eventHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventHistoryScreen(),
                      ),
                    );
                  },
                ),
                Button(
                  text: AppStrings.disputeHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisputeHistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Button(
              text: AppStrings.createNewEvent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewEventScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
