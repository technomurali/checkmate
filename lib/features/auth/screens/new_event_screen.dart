import 'dart:convert';

import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:checkmate/features/auth/controllers/new_event_controller.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDatePicked = DateTime.now();
  DateTime endDatePicked = DateTime.now();
  String? _selectedHCOId;
  String? _selectedHCOName;
  List<Map<String, dynamic>> _selectedHCP = [];
  bool isMultiDay = false;
  String? _selectedEventType;

  final NewEventController _newEventController = NewEventController();
  List<Map<String, dynamic>> _hcos = [];
  List<Map<String, dynamic>> _hcps = [];
  List<Map<String, dynamic>> _hcpPractitioners = [];
  bool hcpInHcoSelected = true;

  @override
  void initState() {
    super.initState();
    fetchHCOs();
    fetchHCPs();
  }

  void fetchHCOs() async {
    final result = await _newEventController.getHCO();
    if (result['success'] == true && result['data'] != null) {
      setState(() {
        _hcos = List<Map<String, dynamic>>.from(result['data']);
        print("hco hcps: ${_hcos}");
      });
    } else {
      setState(() {
        _hcos = [];
      });
    }
  }

  void fetchHCPs() async {
    final result = await _newEventController.getHCP();
    if (result['success'] == true && result['data'] != null) {
      setState(() {
        _hcpPractitioners = List<Map<String, dynamic>>.from(result['data']);
        print('pract hcps: $_hcpPractitioners');
      });
    } else {
      setState(() {
        _hcpPractitioners = [];
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        "userId": userModal.id,
        "userType": "1",
        "userName": "${userModal.firstName} ${userModal.lastName!}",
        "eventName": NewEventTextControllers.eventNameController.text,
        "startDate": NewEventTextControllers.startDateController.text,
        "endDate": NewEventTextControllers.endDateController.text,
        "numberOfStaff": NewEventTextControllers.numberOfStaffController.text,
        "amount": NewEventTextControllers.amountController.text,
        "HCO": _selectedHCOName,
        "HCP": _selectedHCP,
        "eventType": _selectedEventType,
        "eventStatus": "UPCOMING",
        "eventDescription":
            NewEventTextControllers.eventDescriptionController.text,
        "isMultiDay": isMultiDay,
      };
      var testData = {
        "eventId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        "eventName": NewEventTextControllers.eventNameController.text,
        "startDate": startDatePicked.toIso8601String(),
        "endDate": endDatePicked.toIso8601String(),
        "numberOfStaff": int.parse(
          NewEventTextControllers.numberOfStaffController.text,
        ),
        "amount": 0,
        "eventCostByPerson": 0,
        "hco": "/accounts(0200a49c-3617-ef11-9f8a-000d3a313e7f)",
        "contactDtos": [
          {"id": "af0119e5-c3fd-ee11-a1fe-000d3a313e7f"},
          {"id": "b10119e5-c3fd-ee11-a1fe-000d3a313e7f"},
        ],
        "eventType": 546170000,
        "eventStatus": 1,
        "eventDescription":
            NewEventTextControllers.eventDescriptionController.text,
        "eventApproval": 546170000,
        "userName": "/contacts(b10119e5-c3fd-ee11-a1fe-000d3a313e7f)",
      };
      debugPrint("Creating Event: ${json.encode(newEvent)}");
      _newEventController.createEvent(testData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.eventCreated)));

      _formKey.currentState!.reset();
      NewEventTextControllers.eventNameController.clear();
      NewEventTextControllers.startDateController.clear();
      NewEventTextControllers.endDateController.clear();
      NewEventTextControllers.numberOfStaffController.clear();
      NewEventTextControllers.amountController.clear();
      NewEventTextControllers.eventDescriptionController.clear();
      setState(() {
        _selectedHCOId = null;
        _selectedHCOName = null;
        _selectedHCP = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                /// HCO Dropdown
                DropdownSearch<String>(
                  items: (filter, loadProps) {
                    return _hcos
                        .map((hco) => hco['hcoName'] as String)
                        .toList();
                  },
                  selectedItem: _selectedHCOName,
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(labelText: AppStrings.labelHCO),
                  ),
                  onChanged: (value) {
                    final selected = _hcos.firstWhere(
                      (hco) => hco['hcoName'] == value,
                      orElse: () => {},
                    );
                    setState(() {
                      _selectedHCOName = value;
                      _selectedHCOId = selected['hcoId']?.toString();
                      _selectedHCP = [];
                      print("selected hcps: ${selected['hcps']}");
                      _hcps = List<Map<String, dynamic>>.from(selected['hcps']);
                    });
                    // if (_selectedHCOId != null) {
                    //   fetchHCPs(_selectedHCOId!);
                    // }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.selectHCO
                      : null,
                ),
                const SizedBox(height: 10),

                /// Event Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedEventType,
                  decoration: InputDecoration(
                    labelText: AppStrings.labelEventType,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: EventType.lunch,
                      child: Text(EventType.lunch),
                    ),
                    DropdownMenuItem(
                      value: EventType.dinner,
                      child: Text(EventType.dinner),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedEventType = value),
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.selectEventType
                      : null,
                ),
                const SizedBox(height: 10),

                /// Event Name TextField
                TextFormField(
                  controller: NewEventTextControllers.eventNameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.labelEventName,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.requiredField
                      : null,
                ),
                const SizedBox(height: 10),

                /// Event Description TextField
                TextField(
                  autocorrect: true,
                  minLines: AppSizes().eventDescriptionMinLines,
                  controller:
                      NewEventTextControllers.eventDescriptionController,
                  decoration: InputDecoration(
                    labelText: AppStrings.labelEventDescription,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                SizedBox(height: 10),

                /// Multi-day Event Checkbox
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppStrings.multiDayEvent),
                  value: isMultiDay,
                  onChanged: (val) {
                    setState(() {
                      isMultiDay = val ?? false;
                      if (!isMultiDay) {
                        NewEventTextControllers.endDateController.clear();
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 10),

                /// Start Date TextField
                TextFormField(
                  controller: NewEventTextControllers.startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: !!isMultiDay
                        ? AppStrings.labelEventStartDate
                        : AppStrings.labelStartDate,
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      NewEventTextControllers.startDateController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} : ${pickedDate.hour}:${pickedDate.minute}";
                      startDatePicked = pickedDate;
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.requiredField
                      : null,
                ),
                const SizedBox(height: 10),

                /// Multi-day Event Start Date
                if (isMultiDay)
                  TextFormField(
                    controller: NewEventTextControllers.endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: AppStrings.labelEndDate,
                    ),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startDatePicked,
                        firstDate: startDatePicked,
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        NewEventTextControllers.endDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} : ${pickedDate.hour}:${pickedDate.minute}";
                        endDatePicked = pickedDate;
                      }
                    },
                    validator: (value) =>
                        isMultiDay && (value == null || value.isEmpty)
                        ? AppStrings.requiredField
                        : null,
                  ),

                /// Multi-day Event End Date
                if (isMultiDay) const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: NewEventTextControllers.numberOfStaffController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.labelNumberOfStaff,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? AppStrings.requiredField
                      : null,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 40,
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
                              border: Border.all(color: AppColors.border),
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
                              border: Border.all(color: AppColors.border),
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

                /// HCP Dropdown
                if (hcpInHcoSelected)
                  DropdownSearch<Map<String, dynamic>>.multiSelection(
                    items: (filter, loadProps) {
                      print("hcps: ${_hcps}");
                      return _hcps
                          .map<Map<String, dynamic>>(
                            (e) => {
                              HCPModalKeys.hcpId: (e[HCPModalKeys.hcpId])
                                  .toString(),
                              HCPModalKeys.hcpName: e[HCPModalKeys.hcpName],
                            },
                          )
                          .toList();
                    },
                    selectedItems: _selectedHCP
                        .map<Map<String, dynamic>>(
                          (e) => {
                            HCPModalKeys.hcpId:
                                (e[HCPModalKeys.hcpId] ??
                                        e[HCPModalKeys.hcpId] ??
                                        "")
                                    .toString(),
                            HCPModalKeys.hcpName:
                                e[HCPModalKeys.hcpName] ??
                                e[HCPModalKeys.hcpName] ??
                                e.toString(),
                          },
                        )
                        .toList(),
                    itemAsString: (item) {
                      return item[HCPModalKeys.hcpName] ??
                          item[HCPModalKeys.hcpName] ??
                          "";
                    },
                    compareFn: (item, selectedItem) =>
                        item[HCPModalKeys.hcpId] ==
                        selectedItem[HCPModalKeys.hcpId],
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(labelText: "HCPs In HCO"),
                    ),
                    onChanged: (value) => setState(() => _selectedHCP = value),
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.selectHCP
                        : null,
                  ),

                if (!hcpInHcoSelected)
                  DropdownSearch<Map<String, dynamic>>.multiSelection(
                    items: (filter, loadProps) => _hcpPractitioners
                        .map<Map<String, dynamic>>(
                          (e) => {
                            HCPModalKeys.hcpId: (e[HCPModalKeys.hcpId])
                                .toString(),
                            HCPModalKeys.hcpName: e[HCPModalKeys.hcpName],
                          },
                        )
                        .toList(),
                    selectedItems: _selectedHCP
                        .map<Map<String, dynamic>>(
                          (e) => {
                            HCPModalKeys.hcpId:
                                (e[HCPModalKeys.hcpId] ??
                                        e[HCPModalKeys.hcpId] ??
                                        "")
                                    .toString(),
                            HCPModalKeys.hcpName:
                                e[HCPModalKeys.hcpName] ??
                                e[HCPModalKeys.hcpName] ??
                                e.toString(),
                          },
                        )
                        .toList(),
                    itemAsString: (item) {
                      return item[HCPModalKeys.hcpName] ??
                          item[HCPModalKeys.hcpName] ??
                          "";
                    },
                    compareFn: (item, selectedItem) =>
                        item[HCPModalKeys.hcpId] ==
                        selectedItem[HCPModalKeys.hcpId],
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: "HCP Practitioners",
                      ),
                    ),
                    onChanged: (value) => setState(() => _selectedHCP = value),
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.selectHCP
                        : null,
                  ),

                const SizedBox(height: 10),
              ],
            ),

            /// Create Event Button
            Button(onPressed: _submitForm, text: AppStrings.createEvent),
          ],
        ),
      ),
    );
  }
}
