import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/controllers/new_event_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/features/auth/model/hcp_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
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
  final NewEventController _newEventController = NewEventController();
  EventModal event = EventModal.empty();
  bool isCheckedIn = false;
  String? _selectedSignInSheetFileName;
  String? _selectedReceiptFileName;
  DateTime? _checkInDateTime;
  List<Hcp> hcpList = [];
  List<Hcp> hcpPractioners = [];
  bool hcpInHcoSelected = true;
  bool isEdit = false;
  bool isLoading = false;
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
              EventTextControllers.hcoController.text = event.hco ?? '';
              EventTextControllers.eventDescriptionController.text =
                  event.eventDescription ?? '';

              isLoading = false;
            }),
            v.hco != null ? fetchHcoName(v.hco!) : null,
          },
        );
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
        debugPrint("hcpList: $hcpList");
        isLoading = false;
      });
    });
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
      return "Unknown";
    }
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
                          "${eventStatusCodeToText(event.eventStatus.toString())} EVENT",
                        )
                      : SizedBox(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (event.eventStatus.toString() ==
                              BasicCodesFromCrm.upcoming &&
                          !isCheckedIn) ...{
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
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {},
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
                            event = event.copyWith(userName: val);
                          });
                        },
                      ),
                      Divider(),
                      SizedBox(height: 16),
                      TextFormField(
                        enabled:
                            (userModal.role == UserType.pharmaRep &&
                                isCheckedIn) ||
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
                      Divider(),
                      TextField(
                        enabled:
                            (userModal.role == UserType.pharmaRep &&
                                isCheckedIn) ||
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
                        enabled: isCheckedIn || isEdit,
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
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            EventTextControllers.startDateController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            setState(() {
                              event = event.copyWith(
                                startDate: DateTime.parse(
                                  EventTextControllers.startDateController.text,
                                ),
                              );
                            });
                          }
                        },
                      ),
                      event.isMultiDay ? Divider() : SizedBox(),
                      SizedBox(height: 16),
                      event.isMultiDay
                          ? TextFormField(
                              enabled: isCheckedIn || isEdit,
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
                                    event = event.copyWith(
                                      endDate: DateTime.parse(
                                        EventTextControllers
                                            .endDateController
                                            .text,
                                      ),
                                    );
                                  });
                                }
                              },
                            )
                          : SizedBox(),
                      Divider(),
                      SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        enabled:
                            (userModal.role == UserType.pharmaRep &&
                                isCheckedIn) ||
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
                      Divider(),
                      SizedBox(height: 16),

                      // Text(AppStrings.hcpInEvent),
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
                              (userModal.role == UserType.pharmaRep &&
                                  isCheckedIn) ||
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
                            setState(() {
                              event = event.copyWith(
                                contactDtos: value
                                    .map(
                                      (e) => ContactDto(
                                        id: int.tryParse(
                                          e["hcpId"] ?? "0",
                                        ).toString(),
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
                              (userModal.role == UserType.pharmaRep &&
                                  isCheckedIn) ||
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
                            setState(() {
                              event = event.copyWith(
                                contactDtos: value
                                    .map(
                                      (e) => ContactDto(
                                        id: int.tryParse(
                                          e["hcpId"] ?? "0",
                                        ).toString(),
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
                          keyboardType: TextInputType.number,
                          controller: EventTextControllers.amountController,
                          decoration: InputDecoration(labelText: 'Amount'),
                          enabled: isCheckedIn,
                          onChanged: (val) {
                            setState(() {
                              event = event.copyWith(amount: double.parse(val));
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
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles();
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
                                          await FilePicker.platform.pickFiles();
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
                              'Selected:  $_selectedSignInSheetFileName',
                            ),
                          ),
                        SizedBox(height: 16),
                      },
                    ],
                  ),
                  if (isEdit)
                    Button(text: AppStrings.updateEvent, onPressed: () {}),
                  if (userModal.role == UserType.pharmaRep &&
                      // ignore: unrelated_type_equality_checks
                      event.eventStatus ==
                          int.parse(BasicCodesFromCrm.upcoming) &&
                      !isEdit) ...{
                    Button(
                      isDisabled:
                          (_selectedReceiptFileName == null ||
                              EventTextControllers
                                  .amountController
                                  .text
                                  .isEmpty) &&
                          isCheckedIn,
                      text: isCheckedIn
                          ? AppStrings.submitCheckIn
                          : AppStrings.checkIn,
                      onPressed: () {
                        setState(() {
                          isCheckedIn = true;
                          _checkInDateTime = DateTime.now();
                        });
                      },
                    ),
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
                ],
              ),
            ),
    );
  }
}
