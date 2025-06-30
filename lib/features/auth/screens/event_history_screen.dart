import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/app_appbar.dart';
import 'package:checkmate/core/widgets/drawer_screen.dart';
import 'package:checkmate/core/widgets/event_list_item_tile.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:checkmate/core/widgets/confirm_alert_dialog.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({super.key});

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen>
    with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  List<EventModal> events = [];
  List<EventModal> filteredEvents = [];
  SlidableController? _slidableController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedStatus = 'All';
  String? _selectedApproval = 'All';
  final List<String> _statusOptions = [
    'All',
    'UPCOMING',
    'COMPLETED',
    'CANCELLED',
  ];
  final List<String> _approvalOptions = ['All', 'Approved', 'Not Approved'];

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

  void _filterEvents() {
    setState(() {
      filteredEvents = events.where((event) {
        final matchesQuery = event.eventName!.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final matchesStatus =
            _selectedStatus == null || _selectedStatus == 'All'
            ? true
            : event.eventStatus == _selectedStatus;
        final matchesApproval =
            _selectedApproval == null || _selectedApproval == 'All'
            ? true
            : (_selectedApproval == 'Approved'
                  ? event.isApproved == true
                  : event.isApproved == false || event.isApproved == null);

        return matchesQuery && matchesStatus && matchesApproval;
      }).toList();
    });
  }

  fetchAllEvents() {
    _eventController.fetchEvents().then(
      (v) => {
        setState(() {
          events = v;
          filteredEvents = v;
        }),
        _filterEvents(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppAppbar(actions: [], title: AppStrings.eventHistory),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchEvents,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
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
                    PopupMenuButton<String>(
                      icon: Icon(Icons.filter_list),
                      tooltip: 'Filter',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
                                children: [
                                  if (status == 'All')
                                    Icon(
                                      Icons.all_inclusive,
                                      color: AppColors.grey,
                                    )
                                  else if (status == 'UPCOMING')
                                    Icon(Icons.schedule, color: AppColors.blue)
                                  else if (status == 'COMPLETED')
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.successGreen,
                                    )
                                  else if (status == 'CANCELLED')
                                    Icon(
                                      Icons.cancel,
                                      color: AppColors.accentError,
                                    )
                                  else
                                    Icon(Icons.filter_list),
                                  const SizedBox(width: 8),
                                  Text(status),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.verified_user),
                      tooltip: 'Approval',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedApproval = value;
                        });
                        _filterEvents();
                      },
                      itemBuilder: (context) => _approvalOptions
                          .map(
                            (option) => PopupMenuItem<String>(
                              value: option,
                              child: Row(
                                children: [
                                  if (option == 'All')
                                    Icon(
                                      Icons.all_inclusive,
                                      color: AppColors.grey,
                                    )
                                  else if (option == 'Approved')
                                    Icon(
                                      Icons.verified,
                                      color: AppColors.successGreen,
                                    )
                                  else if (option == 'Not Approved')
                                    Icon(
                                      Icons.cancel,
                                      color: AppColors.accentError,
                                    )
                                  else
                                    Icon(Icons.verified_user),
                                  const SizedBox(width: 8),
                                  Text(option),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, i) {
                  final event = filteredEvents[i];
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
                                  setState(() {
                                    events.removeWhere(
                                      (e) => e.eventId == event.eventId,
                                    );
                                    filteredEvents.removeAt(i);
                                  });
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
                      eventName: event.eventName!,
                      startDate: event.startDate!,
                      endDate: event.endDate!,
                      pharmaRep: event.pharmaRepName!,
                      id: event.eventId!,
                      status: event.eventStatus!,
                      approvalStatus: event.isApproved ?? false,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
