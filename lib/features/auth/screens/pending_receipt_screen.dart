import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/firebase/notifications.dart';
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

  eventParticipantApproval(String doctorId, String remarks) {
    setState(() {
      isLoading = true;
    });
    _eventController.approve(event.eventId ?? '', doctorId, remarks).then((
      response,
    ) {
      if (response.statusCode == AppApiStatusCodes.success) {
        fetchEvent();
        setState(() {
          isLoading = false;
        });
        final navProvider = Provider.of<TopNavProvider>(context, listen: false);
        navProvider.goBack();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  eventParticipantRejection(String doctorId, String remarks) {
    setState(() {
      isLoading = true;
    });
    _eventController.reject(event.eventId ?? '', doctorId, remarks).then((
      response,
    ) {
      if (response.statusCode == AppApiStatusCodes.success) {
        setState(() {
          isLoading = false;
        });
        final navProvider = Provider.of<TopNavProvider>(context, listen: false);
        navProvider.goBack();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  fetchImagesOfEvent(String eventId) async {
    // setState(() {
    //   isLoading = true;
    // });
    await _eventController.fetchEventAttachments(eventId).then((value) {
      if (value.statusCode == AppApiStatusCodes.success) {
        var body = jsonDecode(value.body);
        List attachments = [];
        for (var attachment in body) {
          attachments.add(attachment['base64']);
          setState(() {
            eventAttachments = attachments
                .map<Uint8List>(
                  (base64Str) =>
                      base64Decode(base64Str.toString().split(',').last),
                )
                .toList();
          });
        }
        /*
        .forEach((attachment) {
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
         */
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
                      if (event.isMultiDay) ...{
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
                      },
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.91,
                            child: Text(
                              EventTextControllers.hcoController.text,
                            ),
                          ),
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
                          "\$ ${((event.amount ?? 1) / (event.numberOfStaff! + event.contactDtos!.length)).toStringAsFixed(2)}",
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
                                    event.contactDtos![i].approval,
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
                                ((userModal.role == UserType.pharmaRep)))
                              ElevatedButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all(
                                    Size(110, 40),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    AppColors.upcomingStatusBadge,
                                  ),
                                ),
                                onPressed: () {
                                  NotificationsController()
                                      .sendApprovalNotification(
                                        event.contactDtos![i].id ?? '',
                                        event.eventId ?? widget.eventId,
                                      );
                                },
                                child: Text(
                                  AppStrings.sendForApproval,
                                  style: TextStyle(
                                    color:
                                        AppColors.upcomingStatusBadgeTextColor,
                                  ),
                                ),
                              ),
                            if (event.contactDtos![i].approval.toString() ==
                                    BasicCodesFromCrm.pending &&
                                userModal.role != UserType.pharmaRep) ...{
                              ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                  fixedSize: WidgetStateProperty.all(
                                    Size(70, 40),
                                  ),
                                  backgroundColor:
                                      ((event.contactDtos![i].id ==
                                              userModal.kiosk) ||
                                          userModal.role == UserType.hco)
                                      ? WidgetStateProperty.all(
                                          AppColors.successGreen,
                                        )
                                      : WidgetStateProperty.all(
                                          AppColors.border,
                                        ),
                                ),
                                onPressed:
                                    (event.contactDtos![i].id ==
                                            userModal.kiosk ||
                                        userModal.role == UserType.hco)
                                    ? () {
                                        eventParticipantApproval(
                                          event.contactDtos![i].id ?? '',
                                          "",
                                        );
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.approve,
                                  style: TextStyle(color: AppColors.background),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.zero,
                                  ),
                                  fixedSize: WidgetStateProperty.all(
                                    Size(70, 40),
                                  ),
                                  backgroundColor:
                                      ((event.contactDtos![i].id ==
                                              userModal.kiosk) ||
                                          userModal.role == UserType.hco)
                                      ? WidgetStateProperty.all(
                                          AppColors.rejectedRed,
                                        )
                                      : WidgetStateProperty.all(
                                          AppColors.border,
                                        ),
                                ),
                                onPressed:
                                    (event.contactDtos![i].id ==
                                            userModal.kiosk ||
                                        userModal.role == UserType.hco)
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Confirm Rejection',
                                                  ),
                                                  content: SizedBox(
                                                    height: 220,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          AppStrings
                                                              .rejectMessage,
                                                        ),
                                                        SizedBox(height: 20),
                                                        TextField(
                                                          controller:
                                                              ReceiptRejectionTextController
                                                                  .remarksController,
                                                          decoration:
                                                              InputDecoration(
                                                                labelText:
                                                                    'Remarks',
                                                              ),
                                                          onChanged: (value) =>
                                                              setState(() {}),
                                                          maxLines: 3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          ReceiptRejectionTextController
                                                              .remarksController
                                                              .text
                                                              .isNotEmpty
                                                          ? () {
                                                              final dialogContext =
                                                                  context;
                                                              Navigator.of(
                                                                dialogContext,
                                                                rootNavigator:
                                                                    true,
                                                              ).pop();
                                                              _eventController
                                                                  .reject(
                                                                    event
                                                                        .eventId,
                                                                    userModal
                                                                        .kiosk,
                                                                    ReceiptRejectionTextController
                                                                        .remarksController
                                                                        .text,
                                                                  )
                                                                  .then((v) {
                                                                    final navProvider =
                                                                        Provider.of<
                                                                          TopNavProvider
                                                                        >(
                                                                          this.context,
                                                                          listen:
                                                                              false,
                                                                        );
                                                                    final didGoBack =
                                                                        navProvider
                                                                            .goBack();
                                                                    if (!didGoBack) {
                                                                      //murali_rejection_close_back
                                                                      Navigator.maybePop(
                                                                        this.context,
                                                                      );
                                                                    }
                                                                  });
                                                            }
                                                          : null,
                                                      child: Text('Reject'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.reject,
                                  style: TextStyle(color: AppColors.background),
                                ),
                              ),
                            },
                          ],
                        ),
                      },
                      Divider(),
                      SizedBox(height: 10),
                    },
                  ],
                ),
                Row(
                  children: [
                    for (var i = 0; i < eventAttachments.length; i++) ...{
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return Container(
                                  color: Colors.black,
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: InteractiveViewer(
                                          child: Image.memory(
                                            eventAttachments[i],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Image.memory(
                          eventAttachments[i],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                    },
                  ],
                ),
                SizedBox(height: 20),
                if (userModal.role == UserType.pharmaRep) ...{
                  // Button(text: AppStrings.sendRequest, onPressed: () {}),
                } else if ((userModal.role == UserType.hco) &&
                    event.contactDtos!.length > 3) ...{
                  if (event.eventStatus.toString() ==
                      BasicCodesFromCrm.completed) ...{
                    Button(
                      text: AppStrings.approve,
                      onPressed: () {
                        if (userModal.role == UserType.hco) {
                          for (var hcp in event.contactDtos!) {
                            _eventController.approve(
                              event.eventId,
                              hcp.id,
                              "Approved by ${userModal.firstName} ${userModal.lastName} of ${EventTextControllers.hcoController.text}",
                            );
                            Provider.of<TopNavProvider>(
                              context,
                              listen: false,
                            ).goBack();
                          }
                        } else {
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
                        }
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
                                      onPressed:
                                          ReceiptRejectionTextController
                                              .remarksController
                                              .text
                                              .isNotEmpty
                                          ? () {
                                              final dialogContext = context;
                                              Navigator.of(
                                                dialogContext,
                                                rootNavigator: true,
                                              ).pop();
                                              _eventController
                                                  .reject(
                                                    event.eventId,
                                                    userModal.kiosk,
                                                    ReceiptRejectionTextController
                                                        .remarksController
                                                        .text,
                                                  )
                                                  .then((v) {
                                                    final navProvider =
                                                        Provider.of<
                                                          TopNavProvider
                                                        >(
                                                          this.context,
                                                          listen: false,
                                                        );
                                                    navProvider.goBack();
                                                  });
                                            }
                                          : null,
                                      child: Text('Reject'),
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
