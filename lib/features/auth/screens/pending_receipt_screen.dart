import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  List<Uint8List> eventAttachments = [];
  @override
  void initState() {
    super.initState();
    fetchEvent();
  }

  fetchImagesOfEvent(String eventId) async {
    // setState(() {
    //   isLoading = true;
    // });
    await _eventController.fetchEventAttachments(eventId).then((value) {
      if (value.statusCode == AppApiStatusCodes.success) {
        jsonDecode(value.body).forEach((attachment) {
          List attachments = [];
          attachments.add(attachment['base64']);
          setState(() {
            eventAttachments = attachments
                .map<Uint8List>(
                  (base64Str) =>
                      base64Decode(base64Str.toString().split(',').last),
                )
                .toList();
          });
        });
      } else {
        debugPrint("Failed to load attachments");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  String eventApprovalCodeToText(String statusCode) {
    if (statusCode == BasicCodesFromCrm.approval) {
      return "Approved";
    } else if (statusCode == BasicCodesFromCrm.pending) {
      return "Pending";
    } else if (statusCode == BasicCodesFromCrm.rejected) {
      return "Rejected";
    } else {
      return "Unknown";
    }
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
            }),
            fetchImagesOfEvent(v.eventId ?? widget.eventId),
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
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${event.eventName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                            event.startDate!
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first,
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.labelEndDate),
                          Text(
                            event.endDate!
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first,
                          ),
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
                            event.startDate!
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first,
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
                      Row(
                        children: [
                          Text(EventTextControllers.hcoController.text),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                    },
                    SizedBox(height: 10),
                    // Text(
                    //   '''${AppStrings.amount} ${event.amount} \nPer Hcp : ${((event.amount ?? 1) / (event.numberOfStaff! + event.contactDtos!.length)).toStringAsFixed(2)} ''',
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.amount),
                        Text("${event.amount}"),
                      ],
                    ),

                    SizedBox(height: 16),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Per Hcp "),
                        Text(
                          "${((event.amount ?? 1) / (event.numberOfStaff! + event.contactDtos!.length)).toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(AppStrings.hcpInEvent),
                    SizedBox(height: 10),
                    if (event.contactDtos != null) ...{
                      for (var i = 0; i < event.contactDtos!.length; i++) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${i + 1}. ${event.contactDtos![i].firstName} ${event.contactDtos![i].lastName}",
                            ),
                            if (event.contactDtos![i].approval.toString() !=
                                BasicCodesFromCrm.pending)
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: 24),
                                child: Text(
                                  eventApprovalCodeToText(
                                    event.contactDtos![i].approval ?? '0',
                                  ),
                                  style: TextStyle(
                                    color:
                                        event.contactDtos![i].approval
                                                .toString() ==
                                            BasicCodesFromCrm.approval
                                        ? AppColors.successGreen
                                        : event.contactDtos![i].approval
                                                  .toString() ==
                                              BasicCodesFromCrm.rejected
                                        ? AppColors.accentError
                                        : AppColors.pending,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (event.contactDtos![i].approval.toString() ==
                                    BasicCodesFromCrm.pending &&
                                userModal.role == UserType.pharmaRep)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    AppColors.upcomingStatusBadge,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Send for Approval",
                                  style: TextStyle(
                                    color:
                                        AppColors.upcomingStatusBadgeTextColor,
                                  ),
                                ),
                              ),
                            if (event.contactDtos![i].approval.toString() ==
                                    BasicCodesFromCrm.pending &&
                                userModal.role != UserType.pharmaRep)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      event.contactDtos![i].id ==
                                          userModal.kiosk
                                      ? MaterialStateProperty.all(
                                          AppColors.successGreen,
                                        )
                                      : MaterialStateProperty.all(
                                          AppColors.border,
                                        ),
                                ),
                                onPressed:
                                    event.contactDtos![i].id == userModal.kiosk
                                    ? () {
                                        // eventParticipantApproval(
                                        //   event.contactDtos![i].id,
                                        //   "",
                                        // );
                                      }
                                    : null,
                                child: Text(
                                  "Approve",
                                  style: TextStyle(color: AppColors.background),
                                ),
                              ),
                          ],
                        ),
                      },
                      Divider(),
                      SizedBox(height: 10),
                    },
                  ],
                ),
                for (var i = 0; i < eventAttachments.length; i++) ...{
                  Image.memory(
                    eventAttachments[i],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                },
                if (userModal.role == UserType.pharmaRep) ...{
                  Button(text: AppStrings.sendRequest, onPressed: () {}),
                } else if (userModal.role == UserType.hcp) ...{
                  if (event.eventStatus.toString() ==
                      BasicCodesFromCrm.completed) ...{
                    Button(
                      text: AppStrings.approve,
                      onPressed: () {
                        _eventController
                            .approve(
                              event.eventId,
                              userModal.kiosk,
                              "No remarks",
                            )
                            .then(
                              (v) => {
                                Provider.of<TopNavProvider>(
                                  context,
                                  listen: false,
                                )..goBack(),
                              },
                            );
                      },
                    ),
                    SizedBox(height: 10),
                    Button(
                      text: AppStrings.reject,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Confirm Rejection'),
                                  content: SizedBox(
                                    height: 220,
                                    child: Column(
                                      children: [
                                        Text(AppStrings.rejectMessage),
                                        SizedBox(height: 20),
                                        TextField(
                                          controller:
                                              ReceiptRejectionTextController
                                                  .remarksController,
                                          decoration: InputDecoration(
                                            labelText: 'Remarks',
                                          ),
                                          onChanged: (value) => setState(() {}),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Reject'),
                                      onPressed:
                                          ReceiptRejectionTextController
                                              .remarksController
                                              .text
                                              .isNotEmpty
                                          ? () {
                                              _eventController
                                                  .reject(
                                                    event.eventId,
                                                    userModal.kiosk,
                                                    ReceiptRejectionTextController
                                                        .remarksController
                                                        .text,
                                                  )
                                                  .then(
                                                    (v) => {
                                                      Provider.of<
                                                          TopNavProvider
                                                        >(
                                                          context,
                                                          listen: false,
                                                        )
                                                        ..goBack(),
                                                    },
                                                  );
                                              // Navigator.of(context).pop();
                                            }
                                          : null,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      color: Colors.red,
                    ),
                  },
                },
              ],
            ),
    );
  }
}
