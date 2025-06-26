import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
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
  final List<String> _statusOptions = [
    'All',
    'UPCOMING',
    'COMPLETED',
    'CANCELLED',
  ];

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
        return matchesQuery && matchesStatus;
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
      appBar: AppBar(title: Text(AppStrings.eventHistory)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchEvents,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                      _filterEvents();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedStatus ?? 'All',
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _filterEvents();
                  },
                ),
              ],
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
