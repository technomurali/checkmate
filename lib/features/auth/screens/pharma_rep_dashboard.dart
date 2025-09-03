import 'package:checkmate/core/constants/app_Api.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
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
  bool isLoading = false;
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

              upcomingEvents = v
                  // ignore: unrelated_type_equality_checks
                  .where(
                    (e) =>
                        e.eventStatus == int.parse(BasicCodesFromCrm.upcoming),
                  )
                  .take(3)
                  .toList();
              // isLoading = false;
            }),
            fetchPendingEvents(),
          },
        );
  }

  fetchPendingEvents() async {
    // setState(() {
    //   isLoading = true;
    // });
    _eventController
        .fetchEventsWithPending(status: BasicCodesFromCrm.pending)
        .then(
          (v) => {
            setState(() {
              pendingEvents = v
                  .where(
                    (e) =>
                        e.eventApproval == int.parse(BasicCodesFromCrm.pending),
                  )
                  .take(3)
                  .toList();
              isLoading = false;
            }),
          },
        );
  }

  fetchDetails() {
    setState(() {
      isLoading = true;
    });
    fetchPendingEvents();
    fetchUpcomingEvents();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
    // fetchPendingEvents();
    // fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: isLoading ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Welcome Text
            Text(
              " ${AppStrings.helloUser} ${widget.user.firstName ?? ''}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            /// User Role Text
            const Text(
              " ${AppStrings.pharmaRep}",
              style: TextStyle(fontSize: 16),
            ),

            if (isLoading) ...{
              CircularProgressIndicator(),
            } else ...{
              const SizedBox(height: 20),
              if (upcomingEvents.isEmpty && pendingEvents.isEmpty) ...{
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    AppStrings.welcome,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              } else ...{
                /// Upcoming Events
                Text(
                  " ${AppStrings.upcomingEvents}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                /// Upcoming Events Card
                EventsReciptsCard(
                  items: [
                    if (upcomingEvents.isNotEmpty) ...{
                      for (var i = 0; i < upcomingEvents.length; i++) ...{
                        {
                          "title": upcomingEvents[i].eventName!,
                          "date": upcomingEvents[i].startDate!
                              .toLocal()
                              .toString()
                              .split(' ')
                              .first,
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
                    ).navigateTo(TopNavScreen.eventHistory,
                    argument: "UPCOMING"
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Pending Receipts Text
                Text(
                  " ${AppStrings.pendingReceipts}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                /// Pending Receipts Card
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
                    },
                  ],
                  onSeeAll: () {},
                ),
              },
            },
          ],
        ),
      ),
    );
  }
}
