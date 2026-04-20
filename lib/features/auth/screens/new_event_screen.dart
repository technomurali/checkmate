// ignore_for_file: deprecated_member_use
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/app_text_themes.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/profile_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:checkmate/features/auth/controllers/new_event_controller.dart';
import 'package:checkmate/core/constants/app_Api.dart';
import 'package:provider/provider.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  bool _isLoading = false;
  bool isEventTypeIsLoading = false;
  bool fetchingHcpInHco = false;
  late TextEditingController _autocompleteController;
  late TextEditingController _autocompleteControllerHCO;
  TextEditingController hcoNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime startDatePicked = DateTime.now();
  DateTime endDatePicked = DateTime.now();
  String? _selectedHCOId;
  // ignore: unused_field
  String? _selectedHCOName;
  List<Map<String, dynamic>> _selectedHCP = [];
  bool isMultiDay = false;
  String? _selectedEventType;
  int remainingStaff = 0;
  final NewEventController _newEventController = NewEventController();
  final ProfileController _eventController = ProfileController();
  List<Map<String, dynamic>> _hcos = [];
  List<Map<String, dynamic>> _hcps = [];
  List<Map<String, dynamic>> eventTypes = [];
  List<Map<String, dynamic>> _hcpPractitioners = [];
  bool hcpInHcoSelected = true;

  @override
  void initState() {
    super.initState();
    fetchHCOs();
    fetchHCPs();
    fetchEventTypes();
  }

  void fetchEventTypes() async {
    if (!mounted) return;
    setState(() {
      isEventTypeIsLoading = true;
    });
    final value = await _newEventController.getEventTypes();
    if (!mounted) return;
    setState(() {
      isEventTypeIsLoading = false;
      if (value.isNotEmpty) {
        eventTypes = value;
      }
    });
  }

  void fetchHCOs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    if (userModal.role == UserType.hco) {
      //final result = await _newEventController.getHCO();

      // if (result['success'] == true && result['data'] != null) {

      //setState(() {

      //_hcos = List<Map<String, dynamic>>.from(result['data']);

      //_isLoading = false;

      //});

      // } else {

      //setState(() {

      //_isLoading = false;

      //_hcos = [];

      //});

      // }

      final v = await _eventController.getCompanyName(
        userModal.pharmaCompany ?? "",
      );
      if (!mounted) return;
      setState(() {
        _hcos = [
          {"id": userModal.pharmaCompany, "accountName": v},
        ];
        _selectedHCOId = userModal.pharmaCompany;
        _selectedHCOName = v;
        hcoNameController.text = v;
        _isLoading = false;
      });
      fetchHCPbyHCO(_selectedHCOId);
    } else {
      final result = await _newEventController.getHCO();
      if (!mounted) return;

      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _hcos = List<Map<String, dynamic>>.from(result['data']);

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;

          _hcos = [];
        });
      }
    }
  }

  void fetchHCPbyHCO(id) {
    if (!mounted) return;
    setState(() {
      fetchingHcpInHco = true;
    });
    _newEventController.getHCPbyHCO(id).then((result) {
      if (!mounted) return;
      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _hcps = List<Map<String, dynamic>>.from(result['data']);
        });
      } else {
        setState(() {
          _hcps = [];
        });
      }
      setState(() {
        fetchingHcpInHco = false;
      });
    });
  }

  void fetchHCPs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final value = await _newEventController.getHCP();
      if (!mounted) return;
      setState(() {
        if (value['success'] == true && value['data'] != null) {
          _hcpPractitioners = List<Map<String, dynamic>>.from(value['data']);
        } else {
          _hcpPractitioners = [];
        }
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> hcpContactDto = [];

  static const String _fallbackNpi = '9999999';

  String _extractNpi(Map<String, dynamic> source) {
    final dynamic raw =
        source['npiNumber'] ??
        source['NpiNumber'] ??
        source['npinumber'] ??
        source['npi_number'] ??
        source['npi'] ??
        source['npiNo'];
    final value = raw?.toString().trim() ?? '';
    // Backend has null NPI for some HCP rows; use agreed fallback.
    if (value.isEmpty || value.toLowerCase() == 'null') return _fallbackNpi;
    return value;
  }

  void _logSelectedHcpNpi(List<Map<String, dynamic>> selected, String source) {
    final summary = selected
        .map((hcp) {
          final id =
              (hcp[HCPModalKeys.hcpId] ?? hcp['id'] ?? '').toString().trim();
          final name =
              (hcp[HCPModalKeys.hcpName] ??
                      '${hcp['firstName'] ?? ''} ${hcp['lastName'] ?? ''}')
                  .toString()
                  .trim();
          final npi = _extractNpi(hcp);
          return {'id': id, 'name': name, 'npiNumber': npi};
        })
        .toList();
    debugPrint('HCP NPI check [$source]: $summary');
  }

  Map<String, dynamic> _toHcpSelectionMap(
    Map<String, dynamic> source, {
    String? defaultCompany,
  }) {
    final String id =
        (source[HCPModalKeys.hcpId] ?? source['id'] ?? source['contactId'] ?? '')
            .toString();
    final String firstName = (source['firstName']?.toString() ?? '').trim();
    final String lastName = (source['lastName']?.toString() ?? '').trim();

    return {
      HCPModalKeys.hcpId: id,
      HCPModalKeys.hcpName:
          (source[HCPModalKeys.hcpName]?.toString() ?? '$firstName $lastName')
              .trim(),
      'firstName': firstName,
      'lastName': lastName,
      'email':
          source['email']?.toString() ?? source['emailaddress1']?.toString(),
      'phoneNumber': source['phoneNumber']?.toString(),
      'jobTitle': source['jobTitle']?.toString(),
      'company': source['company']?.toString() ?? defaultCompany,
      'approval': source['approval'],
      'approvalLabel': source['approvalLabel']?.toString() ?? '',
      'remarks': source['remarks']?.toString() ?? '',
      'npiNumber': _extractNpi(source),
    };
  }

  Map<String, dynamic> _toContactDto(Map<String, dynamic> selectedHcp) {
    final dynamic id =
        selectedHcp[HCPModalKeys.hcpId] ??
        selectedHcp['id'] ??
        selectedHcp['contactId'];
    final String npi = _extractNpi(selectedHcp);

    final String firstName =
        (selectedHcp['firstName']?.toString() ?? '').trim();
    final String lastName = (selectedHcp['lastName']?.toString() ?? '').trim();

    return {
      'id': id?.toString() ?? '',
      'firstName': firstName,
      'lastName': lastName,
      'email':
          selectedHcp['email']?.toString() ??
          selectedHcp['emailaddress1']?.toString(),
      'phoneNumber': selectedHcp['phoneNumber']?.toString(),
      'jobTitle': selectedHcp['jobTitle']?.toString(),
      'company': selectedHcp['company']?.toString(),
      'approval': selectedHcp['approval'],
      'approvalLabel': selectedHcp['approvalLabel']?.toString() ?? '',
      'remarks': selectedHcp['remarks']?.toString() ?? '',
      'npiNumber': npi,
    };
  }

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      // Rebuild from currently selected chips to avoid stale entries.
      final currentContactDtos = _selectedHCP.map(_toContactDto).toList();
      hcpContactDto = currentContactDtos;
      _logSelectedHcpNpi(_selectedHCP, 'submit');

      final bool hasMissingNpi = currentContactDtos.any(
        (e) => (e['npiNumber']?.toString().trim().isEmpty ?? true),
      );
      if (hasMissingNpi) {
        final missingIds = currentContactDtos
            .where((e) => (e['npiNumber']?.toString().trim().isEmpty ?? true))
            .map((e) => e['id']?.toString() ?? '')
            .toList();
        debugPrint('HCP NPI missing for IDs: $missingIds');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected HCP is missing NPI Number.'),
          ),
        );
        return;
      }

      final int amount = int.tryParse(
            NewEventTextControllers.amountController.text.trim(),
          ) ??
          0;
      final int staffCount = int.parse(
        NewEventTextControllers.numberOfStaffController.text,
      );
      final int eventCostByPerson = staffCount > 0 ? (amount ~/ staffCount) : 0;
      final String eventStatusLabel = startDatePicked.isBefore(DateTime.now())
          ? "Past"
          : "Upcoming";
      final String? hcoRef = (_selectedHCOId != null && _selectedHCOId!.isNotEmpty)
          ? "/accounts($_selectedHCOId)"
          : null;
      final String? userRef =
          (userModal.kiosk != null && userModal.kiosk!.isNotEmpty)
          ? "/contacts(${userModal.kiosk})"
          : null;

      var testData = {
        "eventId": null,
        "eventName": NewEventTextControllers.eventNameController.text,
        "startDate": startDatePicked.toIso8601String(),
        "endDate": isMultiDay
            ? endDatePicked.toIso8601String()
            : startDatePicked.toIso8601String(),
        "numberOfStaff": staffCount,
        "amount": amount,
        "eventCostByPerson": eventCostByPerson,
        "remarks": "",
        "hco": hcoRef,
        "contactDtos": currentContactDtos,
        "eventType": int.parse(_selectedEventType!),
        "eventStatus": int.parse(BasicCodesFromCrm.upcoming),
        "eventApproval": int.parse(BasicCodesFromCrm.pending),
        "eventDescription":
            NewEventTextControllers.eventDescriptionController.text,
        // History endpoints are keyed by this contact reference.
        "userName": userRef,
        "isMultiDay": isMultiDay,
        "eventCheckIn": startDatePicked.toIso8601String(),
        "status": eventStatusLabel,
      };

      _newEventController.createEvent(testData).then((value) {
        if (!mounted) return;
        if (value['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.eventCreated)),
          );

          _formKey.currentState!.reset();

          NewEventTextControllers.eventNameController.clear();

          NewEventTextControllers.startDateController.clear();

          NewEventTextControllers.endDateController.clear();

          NewEventTextControllers.numberOfStaffController.clear();

          NewEventTextControllers.amountController.clear();

          NewEventTextControllers.eventDescriptionController.clear();

          userModal.role == UserType.pharmaRep
              ? _autocompleteControllerHCO.clear()
              : hcoNameController.clear();

          setState(() {
            _selectedHCOId = null;

            _selectedHCOName = null;

            _selectedHCP = [];

            _isLoading = false;
          });

          Provider.of<TopNavProvider>(
            context,
            listen: false,
          ).navigateTo(TopNavScreen.dashboard);
        } else {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.eventCreatedFailed)),
          );
        }
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    NewEventTextControllers.eventNameController.text = "";
    NewEventTextControllers.startDateController.text = "";
    NewEventTextControllers.endDateController.text = "";
    NewEventTextControllers.numberOfStaffController.text = "";
    NewEventTextControllers.amountController.text = "";
    NewEventTextControllers.pharmaRepController.text = "";
    NewEventTextControllers.hcoController.text = "";
    NewEventTextControllers.eventDescriptionController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userModal.role == UserType.pharmaRep) ...{
                      Autocomplete<Map<String, dynamic>>(
                        displayStringForOption: (option) =>
                            option['accountName'],
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return Iterable.empty();
                          } else {
                            return _hcos.where((ele) {
                              return ele['accountName'].toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              );
                            });
                          }
                        },
                        onSelected: (selection) {
                          setState(() {
                            _selectedHCOName = selection['accountName'];

                            _selectedHCOId = selection['id']?.toString();

                            _selectedHCP = [];

                            // print("selected hcps: ${selected['hcps']}");

                            if (_selectedHCOId != null) {
                              _hcps = [];

                              fetchHCPbyHCO(_selectedHCOId!);
                            }

                            // _hcps = List<Map<String, dynamic>>.from(selected['hcps']);
                          });
                        },
                        fieldViewBuilder:
                            (
                              context,
                              textEditingController,
                              focusNode,
                              onFieldSubmitted,
                            ) {
                              _autocompleteControllerHCO =
                                  textEditingController;

                              return TextField(
                                enabled: !_isLoading,
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  label: AppTextThemes.labelWithImportant(
                                    AppStrings.searchHCO,
                                  ),
                                  // labelText: AppStrings.searchHCO,
                                  suffixIcon: _isLoading
                                      ? Transform.scale(
                                          scale: 0.5, // shrink proportionally
                                          child: CircularProgressIndicator(),
                                        )
                                      : Icon(Icons.search),
                                ),
                              );
                            },
                      ),
                    } else ...{
                      TextFormField(
                        // initialValue: _selectedHCOName,
                        controller: hcoNameController,
                        enabled: false,
                        readOnly: true,

                        decoration: InputDecoration(
                          // labelText: AppStrings.labelHCO,
                          label: AppTextThemes.labelWithImportant(
                            AppStrings.labelHCO,
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 10),

                    /// Event Type Dropdown
                    DropdownButtonFormField<String>(
                      // hint: _isLoading ? Text("Loading....") : null,
                      icon: isEventTypeIsLoading
                          ? Transform.scale(
                              scale: 0.5, // shrink proportionally
                              child: CircularProgressIndicator(),
                            )
                          : null,
                      value: _selectedEventType,
                      decoration: InputDecoration(
                        // labelText: AppStrings.labelEventType,
                        label: AppTextThemes.labelWithImportant(
                          AppStrings.labelEventType,
                        ),
                      ),
                      items: eventTypes.map<DropdownMenuItem<String>>((event) {
                        return DropdownMenuItem<String>(
                          value: event["value"].toString(),
                          child: Text(event["label"] as String),
                        );
                      }).toList(),
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
                      decoration: InputDecoration(
                        // labelText: AppStrings.labelEventName,
                        label: AppTextThemes.labelWithImportant(
                          AppStrings.labelEventName,
                        ),
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

                    // CheckboxListTile(

                    //contentPadding: EdgeInsets.zero,

                    //title: Text(AppStrings.multiDayEvent),

                    //value: isMultiDay,

                    //onChanged: (val) {

                    //setState(() {

                    //isMultiDay = val ?? false;

                    //if (!isMultiDay) {

                    //NewEventTextControllers.endDateController.clear();

                    //}

                    //});

                    //},

                    //controlAffinity: ListTileControlAffinity.leading,

                    // ),

                    // Row(

                    //mainAxisAlignment: MainAxisAlignment.start,

                    //children: [

                    //Switch(

                    //value: isMultiDay,

                    //onChanged: (v) {

                    //setState(() {

                    //isMultiDay = !isMultiDay;

                    //if (!isMultiDay) {

                    //NewEventTextControllers.endDateController

                    //.clear();

                    //}

                    //});

                    //},

                    //),

                    //SizedBox(width: 10),

                    //Text(AppStrings.multiDayEvent),

                    //],

                    // ),

                    // const SizedBox(height: 10),

                    /// Start Date TextField
                    TextFormField(
                      controller: NewEventTextControllers.startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        // labelText: !!isMultiDay
                        //     ? AppStrings.labelEventStartDate
                        //     : AppStrings.labelStartDate,
                        label: !!isMultiDay
                            ? AppTextThemes.labelWithImportant(
                                AppStrings.labelEventStartDate,
                              )
                            : AppTextThemes.labelWithImportant(
                                AppStrings.labelStartDate,
                              ),
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
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

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

                    if (_selectedHCP.isNotEmpty) ...{
                      Text(
                        'Selected HCP Practitioners',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true, // Optional: disable manual typing

                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minHeight: 48,
                            minWidth: 0,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedHCP.map((hcp) {
                                return Chip(
                                  label: Text(
                                    hcp["name"] ??
                                        hcp[HCPModalKeys.hcpName] ??
                                        "${hcp['firstName'] ?? ''} ${hcp['lastName'] ?? ''}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors.lightBlue.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedHCP.remove(hcp);
                                      hcpContactDto = _selectedHCP
                                          .map(_toContactDto)
                                          .toList();
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    },

                    /// HCP Dropdown
                    if (hcpInHcoSelected) ...{
                      if (_hcps.length < 11) ...{
                        Autocomplete<Map<String, dynamic>>(
                          displayStringForOption: (option) =>
                              "${option['firstName']} ${option['lastName']}",
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return Iterable.empty();
                            } else {
                              return _hcps.where((ele) {
                                String name =
                                    "${ele['firstName']} ${ele['lastName']}";

                                return name.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                );
                              });
                            }
                          },
                          fieldViewBuilder:
                              (
                                context,
                                textEditingController,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                _autocompleteController = textEditingController;

                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    // labelText:
                                    //     AppStrings.searchHcpPractitioners,
                                    label: AppTextThemes.labelWithImportant(
                                      AppStrings.searchHcpPractitioners,
                                    ),
                                    // suffixIcon: Icon(Icons.search),
                                    suffixIcon: fetchingHcpInHco
                                        ? Transform.scale(
                                            scale: 0.5, // shrink proportionally
                                            child: CircularProgressIndicator(),
                                          )
                                        : Icon(Icons.search),
                                  ),
                                );
                              },
                          onSelected: (selection) {
                            var a = FocusScope.of(context).focusedChild;

                            if (a != null) {
                              a.unfocus();
                            }

                            if (!_selectedHCP.any(
                              (hcp) =>
                                  hcp[HCPModalKeys.hcpId] ==
                                  (selection[HCPModalKeys.hcpId] ??
                                      selection['id']),
                            )) {
                              setState(() {
                                _selectedHCP.add(
                                  _toHcpSelectionMap(
                                    Map<String, dynamic>.from(selection),
                                    defaultCompany: _selectedHCOId,
                                  ),
                                );
                                hcpContactDto = _selectedHCP
                                    .map(_toContactDto)
                                    .toList();
                                _logSelectedHcpNpi(
                                  _selectedHCP,
                                  'autocomplete-select',
                                );
                              });

                              Future.delayed(Duration(milliseconds: 100), () {
                                _autocompleteController.clear();
                              });
                            }
                          },
                        ),
                      } else ...{
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

                          items: (filter, loadProps) {
                            return _hcps
                                .map<Map<String, dynamic>>(
                                  (e) => _toHcpSelectionMap(
                                    Map<String, dynamic>.from(e),
                                    defaultCompany: _selectedHCOId,
                                  ),
                                )
                                .toList();
                          },
                          selectedItems: _selectedHCP
                              .map<Map<String, dynamic>>(
                                (e) => _toHcpSelectionMap(
                                  Map<String, dynamic>.from(e),
                                  defaultCompany: _selectedHCOId,
                                ),
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
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: _selectedHCP.isEmpty
                                  ? "Select HCPs In HCO"
                                  : null,
                              suffixIcon: _isLoading
                                  ? Transform.scale(
                                      scale: 0.5, // shrink proportionally
                                      child: CircularProgressIndicator(),
                                    )
                                  : null,
                            ),
                          ),
                          dropdownBuilder: (context, selectedItems) =>
                              _selectedHCP.isNotEmpty
                              ? SizedBox(child: Text('Select HCPs In HCO'))
                              : SizedBox(),
                          onChanged: (value) {
                            var a = FocusScope.of(context).focusedChild;

                            if (a != null) {
                              a.unfocus();
                            }

                            int noOfselecteHcps = value.length;

                            int noOfStaff = int.parse(
                              NewEventTextControllers
                                      .numberOfStaffController
                                      .text
                                      .isNotEmpty
                                  ? NewEventTextControllers
                                        .numberOfStaffController
                                        .text
                                  : '0',
                            );

                            setState(() {
                              _selectedHCP = value;

                              hcpContactDto = value.map(_toContactDto).toList();
                              _logSelectedHcpNpi(
                                _selectedHCP,
                                'hco-multiselect-change',
                              );
                            });
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? AppStrings.selectHCP
                              : null,
                        ),
                      },
                    } else ...{
                      DropdownSearch<Map<String, dynamic>>.multiSelection(
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox:
                              true, // <- this brings the search field

                          searchFieldProps: TextFieldProps(
                            enabled: !_isLoading,
                            // customise it if you like
                            decoration: InputDecoration(
                              // labelText: AppStrings.selectHcpPractitioners,
                              label: AppTextThemes.labelWithImportant(
                                AppStrings.selectHcpPractitioners,
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        items: (filter, loadProps) => _hcpPractitioners
                            .map<Map<String, dynamic>>(
                              (e) => _toHcpSelectionMap(
                                Map<String, dynamic>.from(e),
                                defaultCompany: userModal.pharmaCompany,
                              ),
                            )
                            .toList(),
                        selectedItems: _selectedHCP
                            .map<Map<String, dynamic>>(
                              (e) => _toHcpSelectionMap(
                                Map<String, dynamic>.from(e),
                                defaultCompany: userModal.pharmaCompany,
                              ),
                            )
                            .toList(),
                        dropdownBuilder: (context, selectedItems) =>
                            _selectedHCP.isNotEmpty
                            ? SizedBox(
                                child: AppTextThemes.labelWithImportant(
                                  AppStrings.selectHcpPractitioners,
                                ),
                              )
                            : SizedBox(),
                        itemAsString: (item) {
                          return item[HCPModalKeys.hcpName] ??
                              item[HCPModalKeys.hcpName] ??
                              "";
                        },
                        compareFn: (item, selectedItem) =>
                            item[HCPModalKeys.hcpId] ==
                            selectedItem[HCPModalKeys.hcpId],
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            // labelText: _selectedHCP.isEmpty
                            //     ? "Select HCP Practitioners"
                            //     : '',\
                            label: _selectedHCP.isEmpty
                                ? AppTextThemes.labelWithImportant(
                                    AppStrings.selectHcpPractitioners,
                                  )
                                : null,
                            suffixIcon: _isLoading
                                ? Transform.scale(
                                    scale: 0.5, // shrink proportionally
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                          ),
                        ),
                        onChanged: (value) {
                          var a = FocusScope.of(context).focusedChild;

                          if (a != null) {
                            a.unfocus();
                          }

                          int noOfselecteHcps = value.length;

                          int noOfStaff = int.parse(
                            NewEventTextControllers
                                    .numberOfStaffController
                                    .text
                                    .isNotEmpty
                                ? NewEventTextControllers
                                      .numberOfStaffController
                                      .text
                                : '0',
                          );

                          setState(() {
                            _selectedHCP = value;
                            hcpContactDto = value.map(_toContactDto).toList();
                            _logSelectedHcpNpi(
                              _selectedHCP,
                              'practitioner-multiselect-change',
                            );
                          });
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? AppStrings.selectHCP
                            : null,
                      ),
                    },
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller:
                          NewEventTextControllers.numberOfStaffController,
                      decoration: InputDecoration(
                        // labelText: AppStrings.labelNumberOfStaff,
                        label: AppTextThemes.labelWithImportant(
                          AppStrings.labelNumberOfStaff,
                        ),
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return AppStrings.requiredField;
                        final parsed = int.tryParse(text);
                        if (parsed == null) return 'Enter numbers only';
                        if (parsed <= 0) {
                          return 'Number of staff must be greater than 0';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    // if (_selectedHCP.isNotEmpty &&
                    //     NewEventTextControllers
                    //         .numberOfStaffController
                    //         .text
                    //         .isNotEmpty) ...{
                    //   Text(
                    //     "Total Participants in Event: ${_selectedHCP.length + int.parse(NewEventTextControllers.numberOfStaffController.text)}",
                    //   ),
                    //   const SizedBox(height: 10),
                    // },
                    // if (_selectedHCP.isNotEmpty) ...{
                    //   Text("Total HCP's in Event: ${_selectedHCP.length}"),
                    //   const SizedBox(height: 10),
                    // },
                  ],
                ),

                /// Create Event Button
                if (!_isLoading) ...{
                  Button(onPressed: _submitForm, text: AppStrings.createEvent),
                } else ...{
                  Button(onPressed: null, text: AppStrings.createEvent),
                },
              ],
            ),
          ),
        ),
        // if (_isLoading) ...{
        //   Positioned.fill(
        //     child: Container(
        //       color: Colors.white,
        //       child: Center(child: CircularProgressIndicator()),
        //     ),
        //   ),
        // },
      ],
    );
  }
}
