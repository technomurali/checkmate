import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDatePicked = DateTime.now();
  String? _selectedHCO;
  List<String> _selectedHCP = [];
  bool isMultiDay = false;

  final List<String> _hcos = [
    "Appolo Hospitals",
    "Yashoda Hospitals",
    "Fortis Hospital",
    "Care Hospitals",
    "Global Hospitals",
    "Rainbow Hospitals",
    "Continental Hospitals",
    "AIG Hospitals",
  ];

  final List<String> _hcps = [
    "Dr. Murali",
    "Dr. Ramesh",
    "Dr. Sneha",
    "Dr. Kavitha",
    "Dr. Latha",
    "Dr. Kiran",
    "Dr. Anita",
    "Dr. Anuradha",
    "Dr. Shalini",
  ];
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        // "pharmaRepId": UserModal().id,
        "eventName": EventTextControllers.eventNameController.text,
        "startDate": EventTextControllers.startDateController.text,
        "endDate": EventTextControllers.endDateController.text,
        "numberOfStaff": EventTextControllers.numberOfStaffController.text,
        "amount": EventTextControllers.amountController.text,
        "HCO": _selectedHCO,
        "HCP": _selectedHCP,
        "eventStatus": "U",
      };

      debugPrint("Creating Event: $newEvent");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.eventCreated)));

      _formKey.currentState!.reset();
      EventTextControllers.eventNameController.clear();
      EventTextControllers.startDateController.clear();
      EventTextControllers.endDateController.clear();
      EventTextControllers.numberOfStaffController.clear();
      EventTextControllers.amountController.clear();
      setState(() {
        _selectedHCO = null;
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
                  // Multi-day Event Checkbox
                  CheckboxListTile(
                    title: Text('Multi-day Event'),
                    value: isMultiDay,
                    onChanged: (val) {
                      setState(() {
                        isMultiDay = val ?? false;
                        if (!isMultiDay) {
                          EventTextControllers.endDateController.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  TextFormField(
                    controller: EventTextControllers.eventNameController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.labelEventName,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: EventTextControllers.startDateController,
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
                        EventTextControllers.startDateController.text =
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
                      controller: EventTextControllers.endDateController,
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
                          EventTextControllers.endDateController.text =
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
                    controller: EventTextControllers.numberOfStaffController,
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
                    items: (filter, loadProps) => _hcos,
                    selectedItem: _selectedHCO,
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: AppStrings.labelHCO,
                      ),
                    ),
                    onChanged: (value) => setState(() => _selectedHCO = value),
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.selectHCO
                        : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownSearch<String>.multiSelection(
                    items: (filter, loadProps) => _hcps,
                    selectedItems: _selectedHCP,
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: AppStrings.labelHCP,
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
              Button(onPressed: _submitForm, text: AppStrings.createEvent),
            ],
          ),
        ),
      ),
    );
  }
}
