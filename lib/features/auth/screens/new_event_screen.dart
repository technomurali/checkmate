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
        "eventName": TextControllers.eventNameController.text,
        "startDate": TextControllers.startDateController.text,
        "endDate": TextControllers.endDateController.text,
        "numberOfStaff": TextControllers.numberOfStaffController.text,
        "amount": TextControllers.amountController.text,
        "HCO": _selectedHCO,
        "HCP": _selectedHCP,
        "eventStatus": "U",
      };

      debugPrint("Creating Event: $newEvent");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.eventCreated)));

      _formKey.currentState!.reset();
      TextControllers.eventNameController.clear();
      TextControllers.startDateController.clear();
      TextControllers.endDateController.clear();
      TextControllers.numberOfStaffController.clear();
      TextControllers.amountController.clear();
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
                  TextFormField(
                    controller: TextControllers.eventNameController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.labelEventName,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: TextControllers.startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: AppStrings.labelStartDate,
                    ),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        TextControllers.startDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        startDatePicked = pickedDate;
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: TextControllers.endDateController,
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
                        TextControllers.endDateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: TextControllers.numberOfStaffController,
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
