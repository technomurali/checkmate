import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:checkmate/features/auth/controllers/events_controller.dart';
import 'package:checkmate/features/auth/controllers/new_event_controller.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDatePicked = DateTime.now();
  String? _selectedHCOId;
  String? _selectedHCOName;
  List<String> _selectedHCP = [];
  bool isMultiDay = false;

  final EventController _eventController = EventController();
  final NewEventController _newEventController = NewEventController();
  List<Map<String, dynamic>> _hcos = [];
  List<String> _hcps = [];
  bool _isHcpLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHCOs();
  }

  void fetchHCOs() async {
    final result = await _newEventController.getHCO();
    if (result['success'] == true && result['data'] != null) {
      setState(() {
        _hcos = List<Map<String, dynamic>>.from(result['data']);
      });
    } else {
      setState(() {
        _hcos = [];
      });
    }
  }

  // void fetchHCPs(String hcoId) async {
  //   setState(() {
  //     _isHcpLoading = true;
  //     _hcps = [];
  //     _selectedHCP = [];
  //   });
  //   final result = await _newEventController.getHCP(hcoId: hcoId);
  //   if (result['success'] == true && result['data'] != null) {
  //     setState(() {
  //       _hcps = List<String>.from(result['data'].map((e) => e.toString()));
  //       _isHcpLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       _hcps = [];
  //       _isHcpLoading = false;
  //     });
  //   }
  // }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        // "pharmaRepId": UserModal().id,
        "eventName": NewEventTextControllers.eventNameController.text,
        "startDate": NewEventTextControllers.startDateController.text,
        "endDate": NewEventTextControllers.endDateController.text,
        "numberOfStaff": NewEventTextControllers.numberOfStaffController.text,
        "amount": NewEventTextControllers.amountController.text,
        "HCO": _selectedHCOId,
        "HCP": _selectedHCP,
        "eventStatus": "U",
      };

      debugPrint("Creating Event: $newEvent");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.eventCreated)));

      _formKey.currentState!.reset();
      NewEventTextControllers.eventNameController.clear();
      NewEventTextControllers.startDateController.clear();
      NewEventTextControllers.endDateController.clear();
      NewEventTextControllers.numberOfStaffController.clear();
      NewEventTextControllers.amountController.clear();
      setState(() {
        _selectedHCOId = null;
        _selectedHCOName = null;
        _selectedHCP = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createNewEvent)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
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
                  CheckboxListTile(
                    title: Text('Multi-day Event'),
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
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        startDatePicked = pickedDate;
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
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
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        }
                      },
                      validator: (value) =>
                          isMultiDay && (value == null || value.isEmpty)
                          ? AppStrings.requiredField
                          : null,
                    ),
                  if (isMultiDay) const SizedBox(height: 10),
                  TextFormField(
                    controller: NewEventTextControllers.numberOfStaffController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.labelNumberOfStaff,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownSearch<String>(
                    items: (filter, loadProps) {
                      debugPrint("HCOs: $_hcos");
                      return _hcos
                          .map((hco) => hco['hcoName'] as String)
                          .toList();
                    },
                    selectedItem: _selectedHCOName,
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: AppStrings.labelHCO,
                      ),
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
                        _hcps = List<String>.from(selected['hcps']);
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
                  _isHcpLoading
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownSearch<String>.multiSelection(
                          items: (filter, loadProps) => _hcps,
                          selectedItems: _selectedHCP,
                          decoratorProps: const DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: AppStrings.labelHCP,
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => _selectedHCP = value),
                          validator: (value) => value == null || value.isEmpty
                              ? AppStrings.selectHCP
                              : null,
                        ),
                  const SizedBox(height: 10),
                ],
              ),
              Button(onPressed: _submitForm, text: AppStrings.createEvent),
            ],
          ),
        ),
      ),
    );
  }
}
