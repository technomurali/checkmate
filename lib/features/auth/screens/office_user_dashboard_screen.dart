import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/controllers/profile_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';

class OfficeUserDashboardScreen extends StatefulWidget {
  final UserModal user;
  const OfficeUserDashboardScreen({super.key, required this.user});

  @override
  State<OfficeUserDashboardScreen> createState() =>
      _OfficeUserDashboardScreenState();
}

class _OfficeUserDashboardScreenState extends State<OfficeUserDashboardScreen> {
  final EventController _eventController = EventController();
  final ProfileController _profileController = ProfileController();
  List<EventModal> events = [];
  List<EventModal> pendingEvents = [];
  bool isLoading = false;
  fetchUpcomingEvents() async {
    setState(() {
      isLoading = true;
    });
    // debugPrint("ouser : ${widget.user.hco![0][HCOModalKeys.hcoId]}");
    _eventController
        .fetchEventsHCOWithStatus(
          status: BasicCodesFromCrm.upcoming,
          hcoId: widget.user.pharmaCompany,
        )
        .then(
          (v) => {
            setState(() {
              events = v.take(3).toList();
              isLoading = false;
            }),
            fetchHcoName(),
            fetchPendingEvents(),
          },
        );
  }

  fetchPendingEvents() async {
    setState(() {
      isLoading = true;
    });
    // debugPrint("ouser : ${widget.user.hco![0][HCOModalKeys.hcoId]}");
    _eventController
        .fetchEventsHCOWithPending(
          status: BasicCodesFromCrm.pending,
          hcoId: widget.user.pharmaCompany,
        )
        .then(
          (v) => {
            setState(() {
              pendingEvents = v.take(3).toList();
              isLoading = false;
            }),
          },
        );
  }

  String hcoName = "";

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
  }

  fetchHcoName() {
    setState(() {
      isLoading = true;
    });
    _profileController.getCompanyName(userModal.pharmaCompany ?? '').then((
      value,
    ) {
      setState(() {
        hcoName = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Welcome Text
                Text(
                  " ${AppStrings.helloUser} ${widget.user.firstName}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                /// User Role Text
                const Text(
                  " ${AppStrings.labelHCOOfficeUser}",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),

                /// HCO Name Text
                Text(" $hcoName", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                /// Upcoming Events Text
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
                    if (events.isNotEmpty) ...{
                      for (
                        var i = 0;
                        i < (events.length > 3 ? 3 : events.length);
                        i++
                      ) ...{
                        {
                          "title": events[i].eventName!,
                          "date": events[i].startDate! .toLocal()
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
                    ).navigateTo(
                      TopNavScreen.eventHistory,
                      argument: {"fromDashboard": true},
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Receipts for Approval Text
                Text(
                  " ${AppStrings.receiptForApproval}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
              ],
            ),
    );
  }
}
