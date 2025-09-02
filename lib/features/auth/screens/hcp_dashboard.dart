import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';

class HCPDashboard extends StatefulWidget {
  final UserModal user;
  const HCPDashboard({super.key, required this.user});

  @override
  State<HCPDashboard> createState() => _HCPDashboardState();
}

class _HCPDashboardState extends State<HCPDashboard> {
  final EventController _eventController = EventController();
  bool isLoading = false;
  List<EventModal> events = [];
  List<EventModal> pendingEvents = [];
  fetchUpcomingEvents() async {
    setState(() {
      isLoading = true;
    });
    _eventController
        .fetchEventsWithStatus(status: BasicCodesFromCrm.upcoming)
        .then(
          (v) => {
            setState(() {
              events = v.take(3).toList();
              debugPrint("Events ::: $events");
            }),
          },
        );
    fetchPENDINGEvents();
  }

  fetchPENDINGEvents() async {
    _eventController
        .fetchEventsWithStatus(status: BasicCodesFromCrm.pending)
        .then(
          (v) => {
            setState(() {
              pendingEvents = v.take(3).toList();
              debugPrint("Events ::: $pendingEvents");
              isLoading = false;
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
          if (isLoading) ...{
            CircularProgressIndicator(),
          } else ...{
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
                  for (var i = 0; i < events.length; i++) ...{
                    {
                      "title": events[i].eventName!,
                      "date": events[i].startDate!
                          .toLocal()
                          .toString()
                          .split(' ')
                          .first,
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
              isPending: true,
              items: [
                if (pendingEvents.isNotEmpty) ...{
                  for (var i = 0; i < pendingEvents.length; i++) ...{
                    {
                      "title": pendingEvents[i].eventName!,
                      "date": pendingEvents[i].startDate!
                          .toLocal()
                          .toString()
                          .split(' ')
                          .first,
                      "id": pendingEvents[i].eventId!,
                      "onTap": () {
                        Provider.of<TopNavProvider>(
                          context,
                          listen: false,
                        ).navigateTo(
                          TopNavScreen.pendingReceipt,
                          argument: pendingEvents[i].eventId!,
                        );
                      },
                    },
                  },
                } else
                  ...{},
              ],

              onSeeAll: () {},
            ),
          },
        ],
      ),
    );
  }
}
