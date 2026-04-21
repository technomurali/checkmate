import 'dart:convert';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/utils/event_status_mapper.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/core/widgets/rejection_remarks_dialog.dart';
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
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    _eventController.approve(event.eventId ?? '', doctorId, remarks).then((
      response,
    ) {
      if (!mounted) return;
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
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    _eventController.reject(event.eventId ?? '', doctorId, remarks).then((
      response,
    ) {
      if (!mounted) return;
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
        final List attachments = [];
        for (var attachment in body) {
          attachments.add(attachment['base64']);
        }
        if (!mounted) return;
        setState(() {
          eventAttachments = attachments
              .map<Uint8List>(
                (base64Str) => base64Decode(base64Str.toString().split(',').last),
              )
              .toList();
        });
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
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  String eventApprovalCodeToText(String statusCode) {
    return EventStatusMapper.approvalLabel(statusCode);
  }

  fetchEvent() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    _eventController
        .fetchEvent(eventId: widget.eventId)
        .then(
          (v) {
            if (!mounted) return;
            if (v.hco != null) {
              fetchHcoName(v.hco.toString());
            }
            setState(() {
              event = v;
            });
            fetchImagesOfEvent(v.eventId ?? widget.eventId);
          },
        );
  }

  fetchHcoName(String hcoId) {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    _eventController.getHcoName(hcoId).then((value) {
      if (!mounted) return;
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
        ? start.toString().split(' ').first
        : '';
    final String endDateStr = end != null
        ? end.toString().split(' ').first
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
          : RefreshIndicator(
              onRefresh: () async {
                fetchEvent();
              },
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          for (
                            var i = 0;
                            i < event.contactDtos!.length;
                            i++
                          ) ...{
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
                                        color: AppColors
                                            .upcomingStatusBadgeTextColor,
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
                                      style: TextStyle(
                                        color: AppColors.background,
                                      ),
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
                                        ? () async {
                                            final remarks =
                                                await showRejectionRemarksDialog(
                                                  context,
                                                );
                                            if (remarks == null) return;
                                            _eventController
                                                .reject(
                                                  event.eventId,
                                                  event.contactDtos![i].id,
                                                  remarks,
                                                )
                                                .then((v) {
                                                  final navProvider = Provider.of<
                                                    TopNavProvider
                                                  >(this.context, listen: false);
                                                  final didGoBack = navProvider
                                                      .goBack();
                                                  if (!didGoBack) {
                                                    Navigator.maybePop(
                                                      this.context,
                                                    );
                                                  }
                                                });
                                          }
                                        : null,
                                    child: Text(
                                      AppStrings.reject,
                                      style: TextStyle(
                                        color: AppColors.background,
                                      ),
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
                                          MediaQuery.of(context).size.height *
                                          0.75,
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
                          onPressed: () async {
                            final remarks = await showRejectionRemarksDialog(
                              context,
                            );
                            if (remarks == null) return;
                            _eventController
                                .reject(event.eventId, userModal.kiosk, remarks)
                                .then((v) {
                                  final navProvider = Provider.of<TopNavProvider>(
                                    this.context,
                                    listen: false,
                                  );
                                  navProvider.goBack();
                                });
                          },
                          color: Colors.red,
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
