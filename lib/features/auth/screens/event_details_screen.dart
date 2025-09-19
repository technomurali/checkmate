import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/core/widgets/approval_dialog.dart';
import 'package:checkmate/core/widgets/confirm_alert_dialog.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/controllers/new_event_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/hcp_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/firebase/notifications.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventController _eventController = EventController();
  final NewEventController _newEventController = NewEventController();
  EventModal event = EventModal.empty();
  bool isCheckedIn = false;
  String? _selectedSignInSheetFileName;
  String? _selectedReceiptFileName;
  String? receiptBase64;
  String? signInSheetBase64;
  DateTime? _checkInDateTime;
  List<Hcp> hcpList = [];
  List<Hcp> hcpPractioners = [];
  bool hcpInHcoSelected = true;
  bool isEdit = false;
  bool isLoading = false;
  bool isCheckinPossible = true;
  int amountForIndividualHcp = 0;
  List<Uint8List> eventAttachments = [];
  @override
  void initState() {
    super.initState();
    fetchEvent();
    fetchHcpPractionners();
    EventTextControllers.startDateController = TextEditingController(
      text: event.startDate.toString(),
    );
    EventTextControllers.endDateController = TextEditingController(
      text: event.endDate.toString(),
    );
  }

  fetchImagesOfEvent(String eventId) async {
    setState(() {
      isLoading = true;
    });
    await _eventController.fetchEventAttachments(eventId).then((value) {
      if (value.statusCode == AppApiStatusCodes.success) {
        List attachments = [];
        jsonDecode(value.body).forEach((attachment) {
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

  submitCheckIn() {
    setState(() {
      isLoading = true;
    });
    var payload = [
      {
        "subject": "Event Receipt",
        "notetext":
            "This is attached Receipt for the ${event.eventName} conducted on ${event.startDate!.day} of ${event.startDate!.month}",
        "filename": "$_selectedReceiptFileName",
        "mimetype": _selectedReceiptFileName!.split('.').last,
        "base64": receiptBase64,
      },
      {
        "subject": "Signin Sheet",
        "notetext":
            "This is Attendee list for the ${event.eventName} conducted on ${event.startDate!.day} of ${event.startDate!.month}",
        "filename": "$_selectedSignInSheetFileName",
        "mimetype": _selectedSignInSheetFileName!.split('.').last,
        "base64": signInSheetBase64,
      },
    ];
    debugPrint("Check-In Payload: $payload");
    _eventController.eventAttachments(payload, event.eventId ?? '').then((
      response,
    ) {
      if (response.statusCode == AppApiStatusCodes.success) {
        event = event.copyWith(
          amount: EventTextControllers.amountController.text.isNotEmpty
              ? double.parse(EventTextControllers.amountController.text)
              : 0.0,
        );
        event = event.copyWith(
          eventStatus: int.parse(BasicCodesFromCrm.completed),
        );
        Map<String, dynamic> checkinPayLoad = {
          "eventCost": double.parse(EventTextControllers.amountController.text),
          "statusCode": int.parse(BasicCodesFromCrm.completed),
          "eventCheckIn": _checkInDateTime!.toIso8601String(),
        };
        _eventController
            .submitCheckIn(checkinPayLoad, event.eventId ?? '')
            .then((value) {
              setState(() {
                isLoading = false;
              });
              final navProvider = Provider.of<TopNavProvider>(
                context,
                listen: false,
              );
              navProvider.goBack();
            });
        setState(() {
          isCheckedIn = true;
          _checkInDateTime = DateTime.now();
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.checkInSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.receiptUploadFailed)),
        );
        setState(() {
          isLoading = false;
        });
      }
    });
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

  deleteEvent(String eventId) {
    setState(() {
      isLoading = true;
    });
    _eventController.deleteEvent(eventId).then((value) {
      if (value == AppApiStatusCodes.success) {
        final navProvider = Provider.of<TopNavProvider>(context, listen: false);
        setState(() {
          isLoading = false;
        });
        navProvider.goBack();
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

  updateEvent() {
    setState(() {
      isLoading = true;
    });
    final navProvider = Provider.of<TopNavProvider>(context, listen: false);
    var testData = {
      "eventName": event.eventName,
      "startDate": event.startDate!.toIso8601String(),
      "endDate": event.endDate!.toIso8601String(),
      "numberOfStaff": event.numberOfStaff,
      "amount": EventTextControllers.amountController.text.isNotEmpty
          ? double.parse(EventTextControllers.amountController.text)
          : 0.0,
      "eventCostByPerson": 0,
      "hco": "/accounts(${event.hco})",
      "contactDtos": event.contactDtos,
      "eventType": int.parse(
        (event.eventType ?? BasicCodesFromCrm.upcoming).toString(),
      ),
      "eventStatus": int.parse(BasicCodesFromCrm.upcoming),
      "eventDescription":
          NewEventTextControllers.eventDescriptionController.text,
      "eventApproval": int.parse(BasicCodesFromCrm.pending),
      "userName": "/contacts(${event.userName})",
      "isMultiDay": event.isMultiDay,
    };
    debugPrint("Test Data for Update Event ${jsonEncode(testData)}");
    _eventController.updateEvent(event.eventId ?? '', testData).then((value) {
      setState(() {
        isEdit = false;
        isLoading = false;
      });
      navProvider.goBack();
    });
  }

  @override
  void dispose() {
    EventTextControllers.startDateController.dispose();
    EventTextControllers.endDateController.dispose();
    EventTextControllers.amountController.text = '';
    super.dispose();
  }

  fetchEvent() {
    setState(() {
      isLoading = true;
    });
    _eventController
        .fetchEvent(eventId: widget.eventId)
        .then(
          (v) => {
            v.hco != null ? fetchHcp(v.hco!) : null,
            setState(() {
              event = v;
              EventTextControllers.eventNameController.text =
                  event.eventName ?? '';
              EventTextControllers.pharmaRepController.text =
                  "${userModal.firstName}  ${userModal.lastName}";
              EventTextControllers.startDateController.text =
                  event.startDate != null
                  ? "${event.startDate!.day.toString().padLeft(2, '0')}/${event.startDate!.month.toString().padLeft(2, '0')}/${event.startDate!.year}"
                  : '';
              EventTextControllers.endDateController.text =
                  event.endDate != null
                  ? "${event.endDate!.day.toString().padLeft(2, '0')}/${event.endDate!.month.toString().padLeft(2, '0')}/${event.endDate!.year}"
                  : '';
              EventTextControllers.numberOfStaffController.text = event
                  .numberOfStaff
                  .toString();
              EventTextControllers.hcoController.text = '';
              EventTextControllers.eventDescriptionController.text =
                  event.eventDescription ?? '';
              // isCheckinPossible = !event.startDate!.isBefore(DateTime.now());
              EventTextControllers.amountController.text = event.amount != null
                  ? event.amount.toString()
                  : '';
              isCheckinPossible = !(isPastDate(
                event.startDate ?? DateTime.now(),
              ));
              debugPrint(
                "isCheckinPossible : $isCheckinPossible ${event.startDate!.isBefore(DateTime.now())} event.startDate : ${event.startDate!.isAtSameMomentAs(DateTime.now())} compare : ${event.startDate!.compareTo(DateTime.now())} compareCondition : ${event.startDate!.compareTo(DateTime.now()) > 0} isSameDay : ${isPastDate(event.startDate ?? DateTime.now())}",
              );
            }),
            v.hco != null ? fetchHcoName(v.hco!) : null,
            fetchImagesOfEvent(v.eventId ?? widget.eventId),
          },
        );
  }

  bool isPastDate(DateTime eventDate) {
    final now = DateTime.now();

    // strip time -> keep only year, month, day
    final event = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final today = DateTime(now.year, now.month, now.day);

    return !event.isAtSameMomentAs(today); // true only if event < today
  }

  bool isPastEventDate(DateTime eventDate) {
    final now = DateTime.now();

    // strip time -> keep only year, month, day
    final event = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final today = DateTime(now.year, now.month, now.day);

    return !event.isBefore(today); // true only if event < today
  }

  fetchHcpPractionners() async {
    setState(() {
      isLoading = true;
    });
    await _newEventController.getHCP().then((result) {
      if (result['success'] == true && result['data'] != null) {
        var hcpPractionners = List<Hcp>.from(
          List<Map<String, dynamic>>.from(
            result['data'],
          ).map((e) => Hcp.fromJson(e)),
        );
        setState(() {
          hcpPractioners = hcpPractionners;
          isLoading = false;
        });
      }
    });
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

  fetchHcp(String hcoId) {
    setState(() {
      isLoading = true;
    });
    _eventController.fetchHcp(hcoId: hcoId).then((v) {
      setState(() {
        hcpList = v;
        isLoading = false;
      });
    });
  }

  String ifPastStatusText() {
    if (event.statusText != null) {
      if (event.eventCheckIn == null &&
          event.statusText!.toUpperCase() == "PAST") {
        return "IN-COMPLETE EVENT";
      } else if (event.eventCheckIn == null &&
          event.statusText!.toUpperCase() == "UPCOMING" &&
          event.eventStatus == int.parse(BasicCodesFromCrm.terminated) &&
          event.eventStatus == int.parse(BasicCodesFromCrm.upcoming)) {
        return "${eventStatusCodeToText(event.eventStatus.toString())} EVENT";
      } else {
        return "${eventStatusCodeToText(event.eventStatus.toString())} & ${eventApprovalCodeToText(event.eventApproval.toString()).toUpperCase()} EVENT";
        //"${eventStatusCodeToText(event.eventStatus.toString())}-${eventApprovalCodeToText(event.eventApproval.toString())}-EVENT"
      }
    } else {
      return "${eventStatusCodeToText(event.eventStatus.toString())} EVENT";
    }
  }

  String eventStatusCodeToText(String statusCode) {
    if (statusCode == BasicCodesFromCrm.upcoming) {
      return "UPCOMING";
    } else if (statusCode == BasicCodesFromCrm.terminated) {
      return "TERMINATED";
    } else if (statusCode == BasicCodesFromCrm.completed) {
      return "COMPLETED";
    } else if (statusCode == BasicCodesFromCrm.disputed) {
      return "DISPUTED";
    } else {
      return "";
    }
  }

  String eventApprovalCodeToText(String statusCode) {
    if (statusCode == BasicCodesFromCrm.approval) {
      return "Approved";
    } else if (statusCode == BasicCodesFromCrm.pending) {
      return "In Review";
    } else if (statusCode == BasicCodesFromCrm.rejected) {
      return "Rejected";
    } else {
      return "";
    }
  }

  showdialogforcheckAvailability() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.checkIn),
        content: Text(AppStrings.checkInNotPossible),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  checkinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.submitCheckIn),
        content: Text(AppStrings.submitCheckinMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              submitCheckIn();
            },
            child: Text('Proceed'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.eventId);
    return Container(
      height: isLoading ? MediaQuery.of(context).size.height * 0.5 : null,
      alignment: isLoading ? Alignment.bottomCenter : null,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  event.eventStatus != null
                      ? Text(
                          event.statusText != null
                              ? !(event.statusText!.toLowerCase() == "past")
                                    ? ifPastStatusText()
                                    : "${eventStatusCodeToText(event.eventStatus.toString())} & ${eventApprovalCodeToText(event.eventApproval.toString()).toUpperCase()} EVENT"
                              : "${eventStatusCodeToText(event.eventStatus.toString())} & ${eventApprovalCodeToText(event.eventApproval.toString()).toUpperCase()} EVENT",
                        )
                      : SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.statusText!.toLowerCase() == "past" &&
                          event.eventCheckIn == null &&
                          userModal.role == UserType.hco) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isEdit = !isEdit;
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: !isEdit
                                    ? AppColors.blue
                                    : AppColors.border,
                              ),
                            ),
                          ],
                        ),
                      },
                      if (event.eventStatus.toString() ==
                              BasicCodesFromCrm.upcoming &&
                          !isCheckedIn &&
                          ((userModal.role == UserType.pharmaRep ||
                                  userModal.role == UserType.hco) ||
                              userModal.role == UserType.hco)) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isPastEventDate(
                              event.startDate ?? DateTime.now(),
                            )) ...{
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: !isEdit
                                      ? AppColors.blue
                                      : AppColors.border,
                                ),
                              ),
                            },
                            SizedBox(width: 10),
                            if (isPastEventDate(
                              event.startDate ?? DateTime.now(),
                            ))
                              InkWell(
                                onTap: () {
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
                                child: Icon(
                                  Icons.delete,
                                  color: AppColors.accentError,
                                ),
                              ),
                          ],
                        ),
                      },
                      SizedBox(height: 15),
                      if (event.hco != null) ...{
                        TextFormField(
                          enabled: false,
                          controller: EventTextControllers.hcoController,
                          decoration: InputDecoration(
                            labelText: AppStrings.labelHCO,
                          ),
                        ),

                        SizedBox(height: 10),
                      },
                      SizedBox(height: 16),
                      TextFormField(
                        enabled: false,
                        controller: EventTextControllers.pharmaRepController,
                        decoration: InputDecoration(
                          labelText: AppStrings.pharmaRep,
                        ),
                        onChanged: (val) {
                          setState(() {
                            event = event.copyWith(userName: val);
                          });
                        },
                      ),

                      SizedBox(height: 16),
                      TextFormField(
                        enabled:
                            ((userModal.role == UserType.pharmaRep ||
                                    userModal.role == UserType.hco) ||
                                userModal.role == UserType.hco) &&
                            isEdit,
                        controller: EventTextControllers.eventNameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.labelEventName,
                        ),
                        onChanged: (val) {
                          setState(() {
                            event = event.copyWith(eventName: val);
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      TextField(
                        enabled:
                            ((userModal.role == UserType.pharmaRep ||
                                userModal.role == UserType.hco)) &&
                            isEdit,
                        autocorrect: true,
                        minLines: AppSizes().eventDescriptionMinLines,
                        controller:
                            EventTextControllers.eventDescriptionController,
                        decoration: InputDecoration(
                          labelText: AppStrings.labelEventDescription,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        enabled: isEdit,
                        controller: EventTextControllers.startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: event.isMultiDay
                              ? AppStrings.labelEventStartDate
                              : AppStrings.labelStartDate,
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            EventTextControllers.startDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            setState(() {
                              isCheckinPossible = !isPastDate(pickedDate);
                              event = event.copyWith(startDate: pickedDate);
                              debugPrint(
                                "Start Date : ${event.startDate} event : ${json.encode(event)} ",
                              );
                            });
                          }
                        },
                      ),
                      event.isMultiDay ? Divider() : SizedBox(),
                      SizedBox(height: 16),
                      event.isMultiDay
                          ? TextFormField(
                              enabled: isEdit,
                              controller:
                                  EventTextControllers.endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: AppStrings.labelEndDate,
                              ),
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                if (pickedDate != null) {
                                  EventTextControllers.endDateController.text =
                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                  setState(() {
                                    event = event.copyWith(endDate: pickedDate);
                                  });
                                }
                              },
                            )
                          : SizedBox(),

                      SizedBox(height: 16),

                      // Text(AppStrings.hcpInEvent),
                      if (event.eventStatus ==
                          int.parse(BasicCodesFromCrm.upcoming)) ...{
                        if (isEdit)
                          Container(
                            width: double.infinity,
                            height: 40,
                            // padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        hcpInHcoSelected = true;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: hcpInHcoSelected
                                            ? AppColors.primary
                                            : AppColors.transparent,
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: double.infinity,
                                      height: 50,

                                      child: Center(
                                        child: Text(
                                          "HCP in HCO",
                                          style: TextStyle(
                                            color: hcpInHcoSelected
                                                ? AppColors.background
                                                : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        hcpInHcoSelected = false;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: hcpInHcoSelected
                                            ? AppColors.transparent
                                            : AppColors.primary,
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "HCP Practitioner",
                                          style: TextStyle(
                                            color: !hcpInHcoSelected
                                                ? AppColors.background
                                                : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(height: 10),
                        if (hcpInHcoSelected)
                          DropdownSearch<Map<String, dynamic>>.multiSelection(
                            popupProps: const PopupPropsMultiSelection.menu(
                              showSearchBox:
                                  true, // <- this brings the search field
                              searchFieldProps: TextFieldProps(
                                // customise it if you like
                                decoration: InputDecoration(
                                  labelText: 'Search HCP',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            enabled:
                                ((userModal.role == UserType.pharmaRep ||
                                    userModal.role == UserType.hco)) &&
                                isEdit,
                            items: (filter, loadProps) => hcpList
                                .map<Map<String, dynamic>>(
                                  (e) => {
                                    "hcpId": (e.hcpId).toString(),
                                    "hcpName": e.hcpName,
                                  },
                                )
                                .toList(),
                            selectedItems: (event.contactDtos ?? [])
                                .map<Map<String, dynamic>>(
                                  (e) => {
                                    "hcpId": (e.id ?? "").toString(),
                                    "hcpName": "${e.firstName} ${e.lastName}",
                                  },
                                )
                                .toList(),
                            itemAsString: (item) => item["hcpName"] ?? "",
                            compareFn: (item, selectedItem) =>
                                item["hcpId"] == selectedItem["hcpId"],
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: AppStrings.hcpInEvent,
                              ),
                            ),
                            onChanged: (value) {
                              var a = FocusScope.of(context).focusedChild;
                              if (a != null) {
                                a.unfocus();
                              }
                              int noOfselecteHcps = value.length;
                              int noOfStaff = int.parse(
                                EventTextControllers
                                        .numberOfStaffController
                                        .text
                                        .isNotEmpty
                                    ? EventTextControllers
                                          .numberOfStaffController
                                          .text
                                    : '0',
                              );

                              setState(() {
                                event = event.copyWith(
                                  contactDtos: value
                                      .map(
                                        (e) => ContactDto(
                                          id: e["hcpId"] ?? "0",
                                          firstName: (e["hcpName"] ?? "")
                                              .split(" ")
                                              .first,
                                          lastName:
                                              (e["hcpName"] ?? "")
                                                      .split(" ")
                                                      .length >
                                                  1
                                              ? (e["hcpName"] ?? "")
                                                    .split(" ")
                                                    .sublist(1)
                                                    .join(" ")
                                              : "",
                                          approval: BasicCodesFromCrm.pending,
                                        ),
                                      )
                                      .toList(),
                                );
                              });
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? AppStrings.selectHCP
                                : null,
                          ),

                        if (!hcpInHcoSelected)
                          DropdownSearch<Map<String, dynamic>>.multiSelection(
                            popupProps: const PopupPropsMultiSelection.menu(
                              showSearchBox:
                                  true, // <- this brings the search field
                              searchFieldProps: TextFieldProps(
                                // customise it if you like
                                decoration: InputDecoration(
                                  labelText: 'Search HCP Practitioners',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            enabled:
                                ((userModal.role == UserType.pharmaRep ||
                                    userModal.role == UserType.hco)) &&
                                isEdit,
                            items: (filter, loadProps) =>
                                hcpPractioners.map<Map<String, dynamic>>((e) {
                                  return {
                                    "hcpId": (e.hcpId).toString(),
                                    "hcpName": e.hcpName,
                                  };
                                }).toList(),
                            selectedItems: (event.contactDtos ?? [])
                                .map<Map<String, dynamic>>(
                                  (e) => {
                                    "hcpId": (e.id ?? "").toString(),
                                    "hcpName": "${e.firstName} ${e.lastName}",
                                  },
                                )
                                .toList(),
                            itemAsString: (item) => item["hcpName"] ?? "",
                            compareFn: (item, selectedItem) =>
                                item["hcpId"] == selectedItem["hcpId"],
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: AppStrings.hcpInEvent,
                              ),
                            ),
                            onChanged: (value) {
                              var a = FocusScope.of(context).focusedChild;
                              if (a != null) {
                                a.unfocus();
                              }
                              int noOfselecteHcps = value.length;
                              int noOfStaff = int.parse(
                                EventTextControllers
                                        .numberOfStaffController
                                        .text
                                        .isNotEmpty
                                    ? EventTextControllers
                                          .numberOfStaffController
                                          .text
                                    : '0',
                              );

                              /*else {
                              setState(() {
                                _selectedHCP = value;

                                hcpContactDto = value.map((e) {
                                  return {
                                    HCPModalKeys.hcpId: e[HCPModalKeys.hcpId],
                                    "": "",
                                  };
                                }).toList();
                              });
                            }
                          },
                         
                              */

                              setState(() {
                                event = event.copyWith(
                                  contactDtos: value
                                      .map(
                                        (e) => ContactDto(
                                          id: e["hcpId"] ?? "0",
                                          firstName: (e["hcpName"] ?? "")
                                              .split(" ")
                                              .first,
                                          lastName:
                                              (e["hcpName"] ?? "")
                                                      .split(" ")
                                                      .length >
                                                  1
                                              ? (e["hcpName"] ?? "")
                                                    .split(" ")
                                                    .sublist(1)
                                                    .join(" ")
                                              : "",
                                          approval: BasicCodesFromCrm.pending,
                                        ),
                                      )
                                      .toList(),
                                );
                              });
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? AppStrings.selectHCP
                                : null,
                          ),
                      },

                      SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        enabled:
                            ((userModal.role == UserType.pharmaRep ||
                                userModal.role == UserType.hco)) &&
                            isEdit,
                        controller:
                            EventTextControllers.numberOfStaffController,
                        decoration: InputDecoration(
                          labelText: AppStrings.labelNumberOfStaff,
                        ),
                        onChanged: (val) {
                          setState(() {
                            event = event.copyWith(
                              numberOfStaff: int.parse(val),
                            );
                          });
                        },
                      ),
                      //
                      SizedBox(height: 16),
                      if (event.contactDtos != null) ...{
                        if (event.contactDtos!.isNotEmpty) ...{
                          Text(
                            "Total HCP's in Event: ${event.contactDtos!.length}",
                          ),
                          const SizedBox(height: 10),
                        },
                        if (event.contactDtos!.isNotEmpty &&
                            EventTextControllers
                                .numberOfStaffController
                                .text
                                .isNotEmpty) ...{
                          Text(
                            "Total Participants in Event: ${event.contactDtos!.length + int.parse(EventTextControllers.numberOfStaffController.text)}",
                          ),
                          const SizedBox(height: 10),
                        },
                      },

                      if (event.eventStatus !=
                          int.parse(BasicCodesFromCrm.completed))
                        if (event.eventStatus ==
                            int.parse(BasicCodesFromCrm.completed)) ...{
                          SizedBox(height: 16),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: EventTextControllers.amountController,
                            decoration: InputDecoration(
                              labelText: '${AppStrings.amount} *',
                              prefixIcon: Icon(Icons.monetization_on_outlined),
                            ),
                            enabled: false,
                            onChanged: (val) {
                              setState(() {
                                event = event.copyWith(
                                  amount: double.parse(val),
                                );
                              });
                            },
                          ),
                          if (EventTextControllers
                              .amountController
                              .text
                              .isNotEmpty) ...{
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${AppStrings.amountPerHcp} ${event.contactDtos != null && event.contactDtos!.isNotEmpty ? (double.parse(EventTextControllers.amountController.text) / (event.contactDtos!.length + double.parse(EventTextControllers.numberOfStaffController.text))).toStringAsFixed(2) : '0.00'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          },

                          SizedBox(height: 16),
                        },

                      if (event.eventStatus ==
                          int.parse(BasicCodesFromCrm.completed))
                        Column(
                          children: [
                            Text("HCPs Attendees"),
                            SizedBox(height: 10),
                            for (var contact in event.contactDtos ?? []) ...{
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${contact.firstName} ${contact.lastName}",
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  //contact.approval.toString() == BasicCodesFromCrm.pending
                                  if (contact.approval.toString() !=
                                      BasicCodesFromCrm.pending)
                                    InkWell(
                                      onTap: () {
                                        if (userModal.role == UserType.hco &&
                                            contact.approval.toString() ==
                                                BasicCodesFromCrm.rejected) {
                                          eventParticipantApproval(
                                            contact.id,
                                            "",
                                          );
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(right: 24),
                                        child: Text(
                                          eventApprovalCodeToText(
                                            contact.approval ?? '0',
                                          ),
                                          style: TextStyle(
                                            color:
                                                contact.approval.toString() ==
                                                    BasicCodesFromCrm.approval
                                                ? AppColors.successGreen
                                                : contact.approval.toString() ==
                                                      BasicCodesFromCrm.rejected
                                                ? AppColors.accentError
                                                : AppColors.pending,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (contact.approval.toString() ==
                                          BasicCodesFromCrm.pending &&
                                      (userModal.role == UserType.pharmaRep))
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              AppColors.upcomingStatusBadge,
                                            ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        NotificationsController()
                                            .sendApprovalNotification(
                                              contact.id ?? '',
                                              event.eventId ?? '',
                                            )
                                            .then((result) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showGeneralDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                barrierLabel:
                                                    'Submission Status',
                                                barrierColor: Colors.black54,
                                                transitionDuration:
                                                    const Duration(
                                                      milliseconds: 240,
                                                    ),
                                                pageBuilder: (_, __, ___) =>
                                                    const SizedBox.shrink(),
                                                transitionBuilder: (ctx, anim, _, __) {
                                                  final curved =
                                                      CurvedAnimation(
                                                        parent: anim,
                                                        curve:
                                                            Curves.easeOutBack,
                                                      );
                                                  return Transform.scale(
                                                    scale:
                                                        0.95 +
                                                        0.05 * curved.value,
                                                    child: Opacity(
                                                      opacity: anim.value,
                                                      child: ApprovalDialog(
                                                        contactDto: contact,
                                                        event: event,
                                                        secondaryLabel:
                                                            result.body,
                                                        success:
                                                            result.statusCode ==
                                                            AppApiStatusCodes
                                                                .success, // adjust to your return type
                                                        onPrimary: () =>
                                                            Navigator.of(
                                                              ctx,
                                                            ).pop(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                      },
                                      child: Text(
                                        AppStrings.sendForApproval,
                                        style: TextStyle(
                                          color: AppColors
                                              .upcomingStatusBadgeTextColor,
                                        ),
                                      ),
                                    ),
                                  if (contact.approval.toString() ==
                                          BasicCodesFromCrm.pending &&
                                      (userModal.role == UserType.hcp ||
                                          userModal.role == UserType.hco))
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(
                                              EdgeInsets.zero,
                                            ),
                                            fixedSize: WidgetStateProperty.all(
                                              Size(70, 40),
                                            ),
                                            backgroundColor:
                                                (contact.id ==
                                                        userModal.kiosk ||
                                                    userModal.role ==
                                                        UserType.hco)
                                                ? WidgetStateProperty.all(
                                                    AppColors.successGreen,
                                                  )
                                                : WidgetStateProperty.all(
                                                    AppColors.border,
                                                  ),
                                          ),
                                          onPressed:
                                              (contact.id == userModal.kiosk ||
                                                  userModal.role ==
                                                      UserType.hco)
                                              ? () {
                                                  eventParticipantApproval(
                                                    contact.id,
                                                    "",
                                                  );
                                                }
                                              : null,
                                          child: Text(
                                            "Approve",
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
                                                (contact.id ==
                                                        userModal.kiosk ||
                                                    userModal.role ==
                                                        UserType.hco)
                                                ? WidgetStateProperty.all(
                                                    AppColors.rejectedRed,
                                                  )
                                                : WidgetStateProperty.all(
                                                    AppColors.border,
                                                  ),
                                          ),
                                          onPressed:
                                              (contact.id == userModal.kiosk ||
                                                  userModal.role ==
                                                      UserType.hco)
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
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  TextField(
                                                                    controller:
                                                                        ReceiptRejectionTextController
                                                                            .remarksController,
                                                                    decoration: InputDecoration(
                                                                      labelText:
                                                                          'Remarks',
                                                                    ),
                                                                    onChanged:
                                                                        (
                                                                          value,
                                                                        ) => setState(
                                                                          () {},
                                                                        ),
                                                                    maxLines: 3,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text(
                                                                  'Cancel',
                                                                ),
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
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop();
                                                                        _eventController
                                                                            .reject(
                                                                              event.eventId,
                                                                              userModal.kiosk,
                                                                              ReceiptRejectionTextController.remarksController.text,
                                                                            )
                                                                            .then(
                                                                              (
                                                                                v,
                                                                              ) => {
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
                                                                child: Text(
                                                                  'Reject',
                                                                ),
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
                                            "Reject",
                                            style: TextStyle(
                                              color: AppColors.background,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  SizedBox(width: 8),
                                ],
                              ),

                              SizedBox(height: 16),
                            },
                          ],
                        ),
                      if (event.contactDtos!.length > 3)
                        if (event.eventApproval !=
                                int.parse(BasicCodesFromCrm.approval) &&
                            event.eventStatus ==
                                int.parse(BasicCodesFromCrm.completed) &&
                            (userModal.role == UserType.hco)) ...{
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                for (var contact in event.contactDtos ?? []) {
                                  if (contact.approval.toString() ==
                                      BasicCodesFromCrm.pending) {
                                    eventParticipantApproval(
                                      contact.id,
                                      "Approved By Office User ${userModal.firstName} ${userModal.lastName} working for ${EventTextControllers.hcoController.text} ",
                                    );
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                Provider.of<TopNavProvider>(
                                  context,
                                  listen: false,
                                ).goBack();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  AppColors.successGreen,
                                ),
                              ),
                              child: const Text(
                                "Approve All",
                                style: TextStyle(color: AppColors.background),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
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
                                                      // _eventController
                                                      //     .reject(
                                                      //       event.eventId,
                                                      //       userModal.kiosk,
                                                      //       ReceiptRejectionTextController
                                                      //           .remarksController
                                                      //           .text,
                                                      //     )
                                                      //     .then(
                                                      //       (v) => {
                                                      //         Provider.of<
                                                      //             TopNavProvider
                                                      //           >(
                                                      //             context,
                                                      //             listen: false,
                                                      //           )
                                                      //           ..goBack(),
                                                      //       },
                                                      //     );
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
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      TextField(
                                                                        controller:
                                                                            ReceiptRejectionTextController.remarksController,
                                                                        decoration: InputDecoration(
                                                                          labelText:
                                                                              'Remarks',
                                                                        ),
                                                                        onChanged:
                                                                            (
                                                                              value,
                                                                            ) => setState(
                                                                              () {},
                                                                            ),
                                                                        maxLines:
                                                                            3,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: Text(
                                                                      'Cancel',
                                                                    ),
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
                                                                            Navigator.of(
                                                                              context,
                                                                            ).pop();
                                                                            _eventController
                                                                                .reject(
                                                                                  event.eventId,
                                                                                  userModal.kiosk,
                                                                                  ReceiptRejectionTextController.remarksController.text,
                                                                                )
                                                                                .then(
                                                                                  (
                                                                                    v,
                                                                                  ) => {
                                                                                    Provider.of<
                                                                                        TopNavProvider
                                                                                      >(
                                                                                        context,
                                                                                        listen: false,
                                                                                      )
                                                                                      ..goBack(),
                                                                                  },
                                                                                );
                                                                          }
                                                                        : null,
                                                                    child: Text(
                                                                      'Reject',
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );

                                                      // Navigator.of(context).pop();
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
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  AppColors.rejectedRed,
                                ),
                              ),
                              child: const Text(
                                "Reject All",
                                style: TextStyle(color: AppColors.background),
                              ),
                            ),
                          ),
                        },
                      SizedBox(height: 16),
                      if (isCheckedIn && _checkInDateTime != null)
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Checked in at: '
                            '${_checkInDateTime!.day}/${_checkInDateTime!.month}/${_checkInDateTime!.year} '
                            '${_checkInDateTime!.hour}:${_checkInDateTime!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: AppColors.accentSuccess,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isCheckedIn) ...{
                        SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: EventTextControllers.amountController,
                          decoration: InputDecoration(
                            labelText: '${AppStrings.amount} *',
                            prefixIcon: Icon(Icons.monetization_on_outlined),
                          ),
                          enabled: isCheckedIn,
                          onChanged: (val) {
                            setState(() {
                              event = event.copyWith(amount: double.parse(val));
                            });
                          },
                        ),
                        if (EventTextControllers
                            .amountController
                            .text
                            .isNotEmpty) ...{
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${AppStrings.amountPerHcp} ${event.contactDtos != null && event.contactDtos!.isNotEmpty ? (double.parse(EventTextControllers.amountController.text) / (event.contactDtos!.length + double.parse(EventTextControllers.numberOfStaffController.text))).toStringAsFixed(2) : '0.00'}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        },
                        SizedBox(height: 16),
                        // Receipt upload button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Upload Receipt'),
                            ElevatedButton(
                              onPressed: isCheckedIn
                                  ? () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                            type: FileType.image,
                                          );

                                      if (result != null &&
                                          result.files.single.bytes != null) {
                                        setState(() {
                                          _selectedReceiptFileName =
                                              result.files.single.name;
                                          receiptBase64 = base64Encode(
                                            result.files.single.bytes!,
                                          );
                                        });
                                      } else {
                                        final bytes = await File(
                                          result!.files.single.path!,
                                        ).readAsBytes();
                                        setState(() {
                                          _selectedReceiptFileName =
                                              result.files.single.name;
                                          receiptBase64 = base64Encode(bytes);
                                        });
                                      }

                                      debugPrint(
                                        "Receipt Base64 : $receiptBase64",
                                      );
                                    }
                                  : () {
                                      debugPrint('Not checked in');
                                    },
                              child: Text('Choose File'),
                            ),
                          ],
                        ),
                        if (_selectedReceiptFileName != null)
                          Container(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Selected:  $_selectedReceiptFileName'),
                          ),
                        SizedBox(height: 16),
                        // Receipt upload button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Upload Sign-In Sheet'),
                            ElevatedButton(
                              onPressed: isCheckedIn
                                  ? () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                            type: FileType.image,
                                          );
                                      if (result != null &&
                                          result.files.isNotEmpty) {
                                        if (result.files.single.bytes != null) {
                                          setState(() {
                                            _selectedSignInSheetFileName =
                                                result.files.single.name;
                                            signInSheetBase64 = base64Encode(
                                              result.files.single.bytes!,
                                            );
                                          });
                                        } else {
                                          final bytes = await File(
                                            result.files.single.path!,
                                          ).readAsBytes();
                                          setState(() {
                                            _selectedSignInSheetFileName =
                                                result.files.single.name;
                                            signInSheetBase64 = base64Encode(
                                              bytes,
                                            );
                                          });
                                        }
                                      }
                                    }
                                  : () {
                                      debugPrint('Not checked in');
                                    },
                              child: Text('Choose File'),
                            ),
                          ],
                        ),
                        if (_selectedSignInSheetFileName != null)
                          Container(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Selected:  $_selectedSignInSheetFileName',
                            ),
                          ),
                        SizedBox(height: 16),
                      },
                    ],
                  ),
                  if (isEdit)
                    Button(
                      text: AppStrings.updateEvent,
                      onPressed: () {
                        updateEvent();
                      },
                    ),
                  if (isEdit) SizedBox(height: 12),
                  if (isEdit)
                    Button(
                      text: AppStrings.cancelupdateEvent,
                      onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      },
                    ),
                  if ((userModal.role == UserType.pharmaRep ||
                          userModal.role == UserType.hco) &&
                      // ignore: unrelated_type_equality_checks
                      event.eventStatus ==
                          int.parse(BasicCodesFromCrm.upcoming) &&
                      !isEdit) ...{
                    if (isCheckedIn) ...{
                      Button(
                        isDisabled:
                            (_selectedReceiptFileName == null ||
                                EventTextControllers
                                    .amountController
                                    .text
                                    .isEmpty ||
                                _selectedSignInSheetFileName == null) &&
                            isCheckedIn,
                        text: AppStrings.submitCheckIn,
                        onPressed: () {
                          debugPrint("Submit Check-In ${json.encode(event)}");
                          checkinDialog();
                        },
                      ),
                    },
                    if (!isCheckinPossible) ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.checkInNotPossible,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.accentError,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    },
                    if (!isCheckedIn) ...{
                      Button(
                        isDisabled: !isCheckinPossible,
                        text: AppStrings.checkIn,
                        onPressed: () {
                          if (!isCheckinPossible) {
                            showdialogforcheckAvailability();
                          } else {
                            setState(() {
                              isCheckedIn = true;
                              _checkInDateTime = DateTime.now();
                            });
                          }
                        },
                      ),
                    },
                    SizedBox(height: 12),
                    if (isCheckedIn)
                      Button(
                        color: AppColors.accentError,
                        isDisabled: !isCheckedIn,
                        text: AppStrings.cancelCheckIn,
                        onPressed: () {
                          setState(() {
                            isCheckedIn = !isCheckedIn;
                            _checkInDateTime = null;
                          });
                        },
                      ),
                  },
                  if (event.eventStatus ==
                      int.parse(BasicCodesFromCrm.completed)) ...{
                    if (eventAttachments.isNotEmpty) Text("Attachments"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        for (var i = 0; i < eventAttachments.length; i++) ...{
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              shape: LinearBorder(),
                            ),
                            onPressed: () {
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
                  },
                ],
              ),
            ),
    );
  }
}
