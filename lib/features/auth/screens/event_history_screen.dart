import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/event_list_item_tile.dart';
import 'package:checkmate/core/widgets/filter_icon.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:checkmate/core/widgets/confirm_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';

class EventHistoryScreen extends StatefulWidget {
  final bool fromDashboard;
  final bool isPending;
  const EventHistoryScreen({
    super.key,
    this.fromDashboard = false,
    this.isPending = false,
  });

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen>
    with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  bool isLoading = false;
  List<EventModal> events = [];
  List<EventModal> filteredEvents = [];
  SlidableController? _slidableController;
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedStatus = 'All';
  String selectedStatusId = '';
  final List<String> _statusOptions = [
    'All',
    "DISPUTED",
    'UPCOMING',
    'IN COMPLETE',
    'COMPLETED',
    'TERMINATED',
    'APPROVED',
    'IN REVIEW',
    'REJECTED',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllEvents();
    if (widget.fromDashboard) {
      _selectedStatus = 'UPCOMING';
      fetchAllEvents();
    }
    if (widget.isPending) {
      _selectedStatus = 'IN REVIEW';
      // _filterEvents();
      fetchAllEvents();
    }
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

  Map<String, String> statusCodeFor(String status) {
    switch (status) {
      case 'APPROVED':
        return {
          'status': 'APPROVED',
          'code': 'A',
          'statusId': BasicCodesFromCrm.approval,
        };
      case 'UPCOMING':
        return {
          'status': 'UPCOMING',
          'code': 'B',
          'statusId': BasicCodesFromCrm.upcoming,
        };
      case 'IN COMPLETE':
        return {'status': 'IN COMPLETE', 'code': 'B', 'statusId': '123'};
      case 'COMPLETED':
        return {
          'status': 'COMPLETED',
          'code': 'B',
          'statusId': BasicCodesFromCrm.completed,
        };
      case 'TERMINATED':
        return {
          'status': 'TERMINATED',
          'code': 'B',
          'statusId': BasicCodesFromCrm.terminated,
        };
      case 'IN REVIEW':
        return {
          'status': 'IN REVIEW',
          'code': 'A',
          'statusId': BasicCodesFromCrm.pending,
        };
      case 'REJECTED':
        return {
          'status': 'REJECTED',
          'code': 'A',
          'statusId': BasicCodesFromCrm.rejected,
        };
      case 'DISPUTED':
        return {
          'status': 'DISPUTED',
          'code': 'B',
          'statusId': BasicCodesFromCrm.disputed,
        };
      default:
        return {
          'status': 'UPCOMING',
          'code': 'B',
          'statusId': BasicCodesFromCrm.upcoming,
        };
    }
  }

  caseofINReview(
    eventStatus,
    selectedStatus,
    eventApproval, {
    EventModal? event,
  }) {
    if (selectedStatus == "IN REVIEW") {
      return eventApproval == BasicCodesFromCrm.pending &&
          eventStatus == BasicCodesFromCrm.completed;
    } else if (selectedStatus == "IN COMPLETE") {
      return event?.eventCheckIn == null &&
          event?.statusText!.toUpperCase() == "PAST" && eventStatus == BasicCodesFromCrm.upcoming && eventStatus != BasicCodesFromCrm.terminated;
    } else if (selectedStatus == "COMPLETED") {
      return event?.eventCheckIn != null &&
          (event?.statusText!.toUpperCase() == "PAST" ||
              event?.statusText!.toUpperCase() == "UPCOMING");
    } else if (selectedStatus == "UPCOMING") {
      return eventStatus == BasicCodesFromCrm.upcoming &&
          event?.statusText!.toUpperCase() != "PAST";
    } else {
      return false;
    }
  }

  void _filterEvents() {
    setState(() {
      isLoading = true;
      filteredEvents = events.where((event) {
        final matchesQuery = event.eventName!.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        debugPrint('Selected status: ${userModal.kiosk}');
        bool matchesStatus;

        if (_selectedStatus == null || _selectedStatus == 'All') {
          matchesStatus = true;
        } else if (_selectedStatus == "IN REVIEW" ||
            _selectedStatus == "IN COMPLETE" ||
            _selectedStatus == "COMPLETED" ||
            _selectedStatus == "UPCOMING") {
          matchesStatus = caseofINReview(
            event.eventStatus.toString(),
            _selectedStatus!,
            event.eventApproval.toString(),
            event: event,
          );
        } else if (statusCodeFor(_selectedStatus!)['code'] == 'B') {
          matchesStatus =
              event.eventStatus.toString() ==
              statusCodeFor(_selectedStatus!)['statusId'];
        } else {
          matchesStatus =
              event.eventApproval.toString() ==
              statusCodeFor(_selectedStatus!)['statusId'];
        }

        return matchesQuery && matchesStatus;
      }).toList();
      if (_selectedStatus == "UPCOMING") {
        filteredEvents = filteredEvents.reversed.toList();
      }
      debugPrint('Filtered events: $filteredEvents');
      isLoading = false;
    });
  }

  Future<void> fetchAllEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<EventModal> v = [];

      if (userModal.role == UserType.hcp) {
        v = await _eventController.fetchHcpEvents();
      } else if (userModal.role == UserType.pharmaRep) {
        v = await _eventController.fetchEvents();
      } else if (userModal.role == UserType.hco) {
        v = await _eventController.fetchOfficeuserEvents(
          userModal.pharmaCompany,
        );
      }

      setState(() {
        events = v;
        filteredEvents = v;
        isLoading = false;
      });

      _filterEvents();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally show an error; keeping consistent with existing UX
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load events')));
    }
  }

  deleteEvent(String eventId) {
    setState(() {
      isLoading = true;
    });
    _eventController.deleteEvent(eventId).then((value) {
      if (value == AppApiStatusCodes.success) {
        fetchAllEvents();
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.eventDeletefailed)),
        );
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 24,
                  color: AppColors.eventTitleIconColor,
                ),
                SizedBox(width: 10),
                Text(
                  "Events",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.eventTitleTextColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (userModal.role != UserType.hcp)
                  InkWell(
                    onTap: () {
                      Provider.of<TopNavProvider>(
                        context,
                        listen: false,
                      ).navigateTo(TopNavScreen.newEvent);
                    },
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: AppColors.eventTitleIconColor,
                    ),
                  ),

                // SizedBox(width: 10),
                // Icon(
                //   Icons.bar_chart,
                //   size: 24,
                //   color: AppColors.eventTitleIconColor,
                // ),
                // SizedBox(width: 10),
                // Icon(
                //   Icons.access_time,
                //   size: 24,
                //   color: AppColors.eventTitleIconColor,
                // ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchEvents,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      // borderSide: BorderSide.none,
                      borderSide: BorderSide(color: Color(0xFFE9EEF2)),
                    ),
                    suffixIcon: PopupMenuButton<String>(
                      enabled: !widget.fromDashboard && !widget.isPending,
                      icon: FilterIcon(status: _selectedStatus!),
                      tooltip: 'Filter',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Color(0xFFE9EEF2)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                        _filterEvents();
                      },
                      itemBuilder: (context) => _statusOptions
                          .map(
                            (status) => PopupMenuItem<String>(
                              value: status,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FilterIcon(status: status),
                                  Text(status),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterEvents();
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
            onRefresh: () async {
              await fetchAllEvents();
            },
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  // Use a ListView with AlwaysScrollableScrollPhysics so pull-to-refresh works while loading
                  return ListView(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    physics: NeverScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: 200),
                    ],
                  );
                }

                if (filteredEvents.isEmpty) {
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    children: const [
                      Center(child: Text('No Events With the Selected Filter')),
                    ],
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, i) => EventListItemTile(
                    event: filteredEvents[i],
                    onTap: () {
                      Provider.of<TopNavProvider>(
                        context,
                        listen: false,
                      ).navigateTo(
                        TopNavScreen.eventDetails,
                        argument: {
                          'eventId': filteredEvents[i].eventId,
                          'eventType':
                              filteredEvents[i].statusText
                                          .toString()
                                          .toUpperCase() ==
                                      "PAST" &&
                                  filteredEvents[i].eventCheckIn == null
                              ? "PASTED"
                              : filteredEvents[i].statusText
                                            .toString()
                                            .toUpperCase() ==
                                        "UPCOMING" &&
                                    filteredEvents[i].eventCheckIn == null
                              ? "UPCOMING"
                              : "",
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget historyItemBuilder(int i) {
    final event = filteredEvents.isNotEmpty
        ? filteredEvents[i]
        : EventModal.empty();

    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (ctx) => ConfirmAlertDialog(
                  title: AppStrings.deleteEvent,
                  content: AppStrings.deleteEventContent,
                  onConfirm: () {
                    deleteEvent(event.eventId!);
                  },
                ),
              );
            },
            backgroundColor: AppColors.accentError,
            foregroundColor: AppColors.background,
            icon: Icons.delete,
          ),
        ],
      ),
      key: ValueKey(event.eventId),
      child: EventListItemTile(
        event: event,
        onTap: () {
          Provider.of<TopNavProvider>(context, listen: false).navigateTo(
            TopNavScreen.eventDetails,
            argument: {
              'eventId': events[i].eventId,
              'eventType':
                  events[i].statusText.toString().toUpperCase() == "PAST" &&
                      events[i].eventCheckIn == null
                  ? "PASTED"
                  : events[i].statusText.toString().toUpperCase() ==
                            "UPCOMING" &&
                        events[i].eventCheckIn == null
                  ? "UPCOMING"
                  : "",
            },
          );
        },
      ),
    );
  }
}
