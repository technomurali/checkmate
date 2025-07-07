import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/hcp_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventController _eventController = EventController();
  EventModal event = EventModal.empty();
  bool isCheckedIn = false;
  String? _selectedSignInSheetFileName;
  String? _selectedReceiptFileName;
  DateTime? _checkInDateTime;
  List<Hcp> hcpList = [];
  @override
  void initState() {
    super.initState();
    fetchEvent();
    EventTextControllers.startDateController = TextEditingController(
      text: event.startDate,
    );
    EventTextControllers.endDateController = TextEditingController(
      text: event.endDate,
    );
  }

  @override
  void dispose() {
    EventTextControllers.startDateController.dispose();
    EventTextControllers.endDateController.dispose();
    super.dispose();
  }

  fetchEvent() {
    _eventController
        .fetchEvent(eventId: widget.eventId)
        .then(
          (v) => {
            v.hco[0]['hcoId'] != null ? fetchHcp(v.hco[0]['hcoId']) : null,
            setState(() {
              event = v;
              EventTextControllers.eventNameController.text =
                  event.eventName ?? '';
              EventTextControllers.pharmaRepController.text =
                  event.pharmaRepName ?? '';
              EventTextControllers.startDateController.text =
                  event.startDate ?? '';
              EventTextControllers.endDateController.text = event.endDate ?? '';
              EventTextControllers.numberOfStaffController.text =
                  event.numberOfStaff ?? '';
              if (event.hco.isNotEmpty) {
                EventTextControllers.hcoController.text =
                    event.hco[0]['hcoName'] ?? '';
              }
              EventTextControllers.eventDescriptionController.text =
                  event.eventDescription ?? '';
              debugPrint('Fetched event.hco: \\${event.hco}');
              debugPrint('Fetched event.hcp: \\${event.hcp}');
            }),
          },
        );
  }

  fetchHcp(String hcoId) {
    _eventController.fetchHcp(hcoId: hcoId).then((v) {
      setState(() {
        hcpList = v;
        debugPrint("hcpList: $hcpList");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopNav(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              event.eventStatus != null
                  ? Text("${event.eventStatus} EVENT")
                  : SizedBox(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  for (var i = 0; i < event.hco.length; i++) ...{
                    TextFormField(
                      enabled: false,
                      controller: EventTextControllers.hcoController,
                      decoration: InputDecoration(
                        labelText: AppStrings.labelHCO,
                      ),
                    ),

                    Divider(),
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
                        event = event.copyWith(pharmaRepName: val);
                      });
                    },
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  TextFormField(
                    enabled:
                        userModal.role == UserType.pharmaRep && isCheckedIn,
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
                  Divider(),
                  TextField(
                    enabled:
                        userModal.role == UserType.pharmaRep && isCheckedIn,
                    autocorrect: true,
                    minLines: AppSizes().eventDescriptionMinLines,
                    controller: EventTextControllers.eventDescriptionController,
                    decoration: InputDecoration(
                      labelText: AppStrings.labelEventDescription,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    enabled: isCheckedIn,
                    controller: EventTextControllers.startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: event.endDate != null
                          ? AppStrings.labelEventStartDate
                          : AppStrings.labelStartDate,
                    ),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        EventTextControllers.startDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        setState(() {
                          event = event.copyWith(
                            startDate:
                                EventTextControllers.startDateController.text,
                          );
                        });
                      }
                    },
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  event.endDate != null
                      ? TextFormField(
                          enabled: isCheckedIn,
                          controller: EventTextControllers.endDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: AppStrings.labelEndDate,
                          ),
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              EventTextControllers.endDateController.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              setState(() {
                                event = event.copyWith(
                                  endDate: EventTextControllers
                                      .endDateController
                                      .text,
                                );
                              });
                            }
                          },
                        )
                      : SizedBox(),
                  Divider(),
                  SizedBox(height: 16),
                  TextFormField(
                    enabled:
                        userModal.role == UserType.pharmaRep && isCheckedIn,
                    controller: EventTextControllers.numberOfStaffController,
                    decoration: InputDecoration(
                      labelText: AppStrings.labelNumberOfStaff,
                    ),
                    onChanged: (val) {
                      setState(() {
                        event = event.copyWith(numberOfStaff: val);
                      });
                    },
                  ),
                  Divider(),
                  SizedBox(height: 16),

                  // Text(AppStrings.hcpInEvent),
                  SizedBox(height: 10),
                  DropdownSearch<Map<String, dynamic>>.multiSelection(
                    enabled:
                        userModal.role == UserType.pharmaRep && isCheckedIn,
                    items: (filter, loadProps) => hcpList
                        .map<Map<String, dynamic>>(
                          (e) => {
                            "hcpId": (e.hcpId).toString(),
                            "hcpName": e.hcpName,
                          },
                        )
                        .toList(),
                    selectedItems: event.hcp
                        .map<Map<String, dynamic>>(
                          (e) => {
                            "hcpId": (e["hcpId"] ?? e['id'] ?? "").toString(),
                            "hcpName":
                                e["hcpName"] ?? e['name'] ?? e.toString(),
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
                      setState(() {
                        event = event.copyWith(
                          hcp: value
                              .map<Map<String, dynamic>>((e) => e)
                              .toList(),
                        );
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.selectHCP
                        : null,
                  ),
                  SizedBox(height: 16),
                  if (isCheckedIn && _checkInDateTime != null)
                    Padding(
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
                      controller: EventTextControllers.amountController,
                      decoration: InputDecoration(labelText: 'Amount'),
                      enabled: isCheckedIn,
                      onChanged: (val) {
                        setState(() {
                          event = event.copyWith(amount: val);
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Receipt upload button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upload Receipt'),
                        ElevatedButton(
                          onPressed: isCheckedIn
                              ? () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles();
                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    setState(() {
                                      _selectedReceiptFileName =
                                          result.files.single.name;
                                    });
                                  }
                                }
                              : () {
                                  debugPrint('Not checked in');
                                },
                          child: Text('Choose File'),
                        ),
                      ],
                    ),
                    if (_selectedReceiptFileName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected: [32m[1m[4m$_selectedReceiptFileName[0m',
                        ),
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
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles();
                                  if (result != null &&
                                      result.files.isNotEmpty) {
                                    setState(() {
                                      _selectedSignInSheetFileName =
                                          result.files.single.name;
                                    });
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected: [32m[1m[4m$_selectedSignInSheetFileName[0m',
                        ),
                      ),
                    SizedBox(height: 16),
                  },
                ],
              ),
              if (userModal.role == UserType.pharmaRep) ...{
                Button(
                  isDisabled:
                      (_selectedReceiptFileName == null ||
                          EventTextControllers.amountController.text.isEmpty) &&
                      isCheckedIn,
                  text: isCheckedIn
                      ? AppStrings.updateEvent
                      : AppStrings.checkIn,
                  onPressed: () {
                    setState(() {
                      isCheckedIn = true;
                      _checkInDateTime = DateTime.now();
                    });
                  },
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
