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
  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  fetchEvent() {
    _eventController
        .fetchEvent(eventId: widget.eventId)
        .then(
          (v) => {
            setState(() {
              event = v;
            }),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
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
                    Text("${event.pharmaRepName}"),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.labelEventStartDate),
                    Text("${event.startDate}"),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.labelEndDate),
                    Text("${event.endDate}"),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
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
                for (var i = 0; i < event.hco.length; i++) ...{
                  Row(children: [Text("${i + 1}. ${event.hco[i]}")]),
                  Divider(),
                  SizedBox(height: 10),
                },
                SizedBox(height: 16),
                Text(AppStrings.hcpInEvent),
                SizedBox(height: 10),
                for (var i = 0; i < event.hcp.length; i++) ...{
                  Row(children: [Text("${i + 1}. ${event.hcp[i]["hcpName"]}")]),
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
