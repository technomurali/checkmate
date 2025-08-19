import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';

class PendingReceiptScreen extends StatefulWidget {
  final String eventId;
  const PendingReceiptScreen({super.key, required this.eventId});

  @override
  State<PendingReceiptScreen> createState() => _PendingReceiptScreenState();
}

class _PendingReceiptScreenState extends State<PendingReceiptScreen> {
  final EventController _eventController = EventController();
  EventModal event = EventModal.empty();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  fetchEvent() {
    setState(() {
      isLoading = true;
    });
    _eventController
        .fetchEvent(eventId: widget.eventId)
        .then(
          (v) => {
            v.hco != null ? fetchHcoName(v.hco.toString()) : null,
            setState(() {
              event = v;
              isLoading = false;
            }),
          },
        );
  }

  fetchHcoName(String hcoId) {
    setState(() {
      isLoading = true;
    });
    _eventController.getHcoName(hcoId).then((value) {
      setState(() {
        EventTextControllers.hcoController.text = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? start = event.startDate;
    final DateTime? end = event.endDate;
    final String startDateStr = start != null
        ? start.toLocal().toString().split(' ').first
        : '';
    final String endDateStr = end != null
        ? end.toLocal().toString().split(' ').first
        : '';
    final bool hasValidRange =
        start != null &&
        end != null &&
        (end.isAfter(start) || end.isAtSameMomentAs(start));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${event.eventName}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.pharmaRep),
                  Text("${userModal.firstName} ${userModal.lastName}"),
                ],
              ),
              Divider(),
              SizedBox(height: 16),
              if (hasValidRange) ...{
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.labelEventStartDate),
                    Text(
                      event.startDate!.toLocal().toString().split(' ').first,
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.labelEndDate),
                    Text(event.endDate!.toLocal().toString().split(' ').first),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
              } else ...{
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.labelStartDate),
                    Text(
                      event.startDate!.toLocal().toString().split(' ').first,
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
              },
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.numberOfStaff),
                  Text("${event.numberOfStaff}"),
                ],
              ),
              Divider(),
              SizedBox(height: 16),
              Text(AppStrings.hcoInEvent),
              SizedBox(height: 10),
              if (event.hco != null) ...{
                Row(children: [Text(EventTextControllers.hcoController.text)]),
                Divider(),
                SizedBox(height: 10),
              },
              SizedBox(height: 16),
              Text(AppStrings.hcpInEvent),
              SizedBox(height: 10),
              if (event.contactDtos != null) ...{
                for (var i = 0; i < event.contactDtos!.length; i++) ...{
                  Row(
                    children: [
                      Text(
                        "${i + 1}. ${event.contactDtos![i].firstName} ${event.contactDtos![i].lastName}",
                      ),
                    ],
                  ),
                },
                Divider(),
                SizedBox(height: 10),
              },
            ],
          ),
          Button(text: AppStrings.sendRequest, onPressed: () {}),
        ],
      ),
    );
  }
}
