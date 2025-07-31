import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/event_list_item_tile.dart';
import 'package:checkmate/core/widgets/filter_icon.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
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
  List<EventModal> events = [];
  List<EventModal> filteredEvents = [];
  SlidableController? _slidableController;
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedStatus = 'All';
  final List<String> _statusOptions = [
    'All',
    'UPCOMING',
    'COMPLETED',
    'TERMINATED',
    'APPROVED',
    'PENDING',
    'REJECTED',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllEvents();
    if (widget.fromDashboard) {
      _selectedStatus = 'UPCOMING';
      _filterEvents();
    }
    if (widget.isPending) {
      _selectedStatus = 'PENDING';
      _filterEvents();
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

  void _filterEvents() {
    setState(() {
      filteredEvents = events.where((event) {
        final matchesQuery = event.eventName!.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        Map<String, String> statusCodeFor(String status) {
          switch (status) {
            case 'APPROVED':
              return {'status': 'APPROVED', 'code': 'A'};
            case 'UPCOMING':
              return {'status': 'UPCOMING', 'code': 'B'};
            case 'COMPLETED':
              return {'status': 'COMPLETED', 'code': 'B'};
            case 'TERMINATED':
              return {'status': 'TERMINATED', 'code': 'B'};
            case 'PENDING':
              return {'status': 'PENDING', 'code': 'A'};
            case 'REJECTED':
              return {'status': 'REJECTED', 'code': 'A'};
            default:
              return {'status': 'UPCOMING', 'code': 'B'};
          }
        }

        // Debug print for status comparison
        final matchesStatus =
            _selectedStatus == null || _selectedStatus == 'All'
            ? true
            : statusCodeFor(_selectedStatus!)['code'] == 'B'
            ? event.eventStatus == statusCodeFor(_selectedStatus!)['status']
            : event.isApproved == statusCodeFor(_selectedStatus!)['status'];
        // final matchesApproval =
        //     _selectedApproval == null || _selectedApproval == 'All'
        //     ? true
        //     : event.isApproved == _selectedApproval;

        return matchesQuery && matchesStatus;
      }).toList();
      debugPrint('Filtered events: $filteredEvents');
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
    return Column(
      children: [
        Card(
          color: AppColors.searchCard,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
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
                  enabled: !widget.fromDashboard && !widget.isPending,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilterIcon(status: status),
                              Text(status),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 12),
                FilterIcon(status: _selectedStatus!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < filteredEvents.length; i++) ...{
          historyItemBuilder(i),
        },
      ],
    );
  }

  Widget historyItemBuilder(int i) {
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
                      events.removeWhere((e) => e.eventId == event.eventId);
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
        eventName: event.eventName ?? '',
        startDate: event.startDate ?? '',
        endDate: event.endDate ?? '',
        pharmaRep: event.pharmaRepName ?? '',
        id: event.eventId ?? '',
        status: event.eventStatus ?? '',
        approvalStatus: event.isApproved ?? '',
        onTap: () {
          Provider.of<TopNavProvider>(
            context,
            listen: false,
          ).navigateTo(TopNavScreen.eventDetails, argument: event.eventId);
        },
      ),
    );
  }
}
