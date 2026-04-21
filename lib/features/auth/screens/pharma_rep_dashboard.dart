// ignore_for_file: control_flow_in_finally

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
  Future<void> fetchUpcomingEvents() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      final v = await _eventController.fetchEventsWithStatus(
        status: BasicCodesFromCrm.upcoming,
      );

      if (!mounted) return;
      setState(() {
        events = v.take(3).toList();

        upcomingEvents = v
            .where(
              (e) => e.eventStatus == int.parse(BasicCodesFromCrm.upcoming),
            )
            .take(3)
            .toList();
      });

      // Also refresh pending events after upcoming are fetched
      await fetchPendingEvents();
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }
Future<void> fetchUpcomingEventsAfter() async {
    if (!mounted) return;
   
    try {
      final v = await _eventController.fetchEventsWithStatus(
        status: BasicCodesFromCrm.upcoming,
      );

      if (!mounted) return;
      setState(() {
        events = v.reversed.take(3).toList();

        upcomingEvents = v
            .where(
              (e) => e.eventStatus == int.parse(BasicCodesFromCrm.upcoming),
            )
            .take(3)
            .toList();
      });

      // Also refresh pending events after upcoming are fetched
      await fetchPendingEvents();
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPendingEvents() async {
    final v = await _eventController.fetchEventsWithPending(
      status: BasicCodesFromCrm.pending,
    );

    if (!mounted) return;
    setState(() {
      pendingEvents = v
          .where((e) => e.eventApproval == int.parse(BasicCodesFromCrm.pending))
          .take(3)
          .toList();
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
    return RefreshIndicator(
      color: Colors.blue, // loader color
      backgroundColor: Colors.white, // background of loader
      displacement: 40,
      onRefresh: fetchUpcomingEventsAfter,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(child: CircularProgressIndicator()),
                ),
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
                                argument: {
                                  'eventId': events[i].eventId,
                                  'eventType':
                                      events[i].statusText
                                                  .toString()
                                                  .toUpperCase() ==
                                              "PAST" &&
                                          events[i].eventCheckIn == null
                                      ? "PASTED"
                                      : events[i].statusText
                                                    .toString()
                                                    .toUpperCase() ==
                                                "UPCOMING" &&
                                            events[i].eventCheckIn == null
                                      ? "UPCOMING"
                                      : "",
                                },
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
                      ).navigateTo(
                        TopNavScreen.eventHistory,
                        argument: {"fromDashboard": true},
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
                    onSeeAll: () {
                      Provider.of<TopNavProvider>(
                        context,
                        listen: false,
                      ).navigateTo(
                        TopNavScreen.eventHistory,
                        argument: {"isPending": true},
                      );
                    },
                  ),
                },
              },
            ],
          ),
        ),
      ),
    );
  }
}
