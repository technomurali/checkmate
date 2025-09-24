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
    setState(() {
      _isLoading = true;
    });
    await _newEventController.getEventTypes().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _isLoading = false;
          eventTypes = value;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void fetchHCOs() async {
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

      await _eventController
          .getCompanyName(userModal.pharmaCompany ?? "")
          .then(
            (v) => {
              setState(() {
                _hcos = [
                  {"id": userModal.pharmaCompany, "accountName": v},
                ];

                _selectedHCOId = userModal.pharmaCompany;

                _selectedHCOName = v;

                hcoNameController.text = v;

                _isLoading = false;
              }),
              fetchHCPbyHCO(_selectedHCOId),
            },
          );
    } else {
      final result = await _newEventController.getHCO();

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
    setState(() {
      _isLoading = true;
    });
    _newEventController.getHCPbyHCO(id).then((result) {
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
        _isLoading = false;
      });
    });
  }

  void fetchHCPs() async {
    setState(() {
      _isLoading = true;
    });
    await _newEventController
        .getHCP()
        .then((value) {
          if (value['success'] == true && value['data'] != null) {
            setState(() {
              _hcpPractitioners = List<Map<String, dynamic>>.from(
                value['data'],
              );
            });
          } else {
            setState(() {
              _hcpPractitioners = [];
            });
          }
          setState(() {
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  List<Map<String, dynamic>> hcpContactDto = [];

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      var testData = {
        "eventName": NewEventTextControllers.eventNameController.text,
        "startDate": startDatePicked.toIso8601String(),
        "endDate": isMultiDay
            ? endDatePicked.toIso8601String()
            : startDatePicked.toIso8601String(),
        "numberOfStaff": int.parse(
          NewEventTextControllers.numberOfStaffController.text,
        ),
        "amount": 0,
        "eventCostByPerson": 0,
        "hco": "/accounts($_selectedHCOId)",
        "contactDtos": hcpContactDto,
        "eventType": int.parse(_selectedEventType!),
        "eventStatus": int.parse(BasicCodesFromCrm.upcoming),
        "eventDescription":
            NewEventTextControllers.eventDescriptionController.text,
        "eventApproval": int.parse(BasicCodesFromCrm.pending),
        "userName": "/contacts(${userModal.kiosk})",
        "isMultiDay": isMultiDay,
      };

      _newEventController.createEvent(testData).then((value) {
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
                      icon: _isLoading
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
                                    hcp["name"],
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
                                    suffixIcon: _isLoading
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
                              (hcp) => hcp['id'] == selection['id'],
                            )) {
                              setState(() {
                                _selectedHCP.add({
                                  "id": selection['id'],
                                  "name":
                                      "${selection['firstName']} ${selection['lastName']}",
                                });
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
                                  (e) => {
                                    HCPModalKeys.hcpId: (e['id']).toString(),
                                    HCPModalKeys.hcpName:
                                        "${e['firstName']}  ${e['lastName']}",
                                  },
                                )
                                .toList();
                          },
                          selectedItems: _selectedHCP
                              .map<Map<String, dynamic>>(
                                (e) => {
                                  HCPModalKeys.hcpId: (e[HCPModalKeys.hcpId])
                                      .toString(),
                                  HCPModalKeys.hcpName: e[HCPModalKeys.hcpName],
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

                              hcpContactDto = value.map((e) {
                                return {
                                  HCPModalKeys.hcpId: e[HCPModalKeys.hcpId],
                                  "": "",
                                };
                              }).toList();
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
                              (e) => {
                                HCPModalKeys.hcpId: (e[HCPModalKeys.hcpId])
                                    .toString(),
                                HCPModalKeys.hcpName:
                                    "${e['firstName']}  ${e['lastName']}",
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
                            hcpContactDto = value.map((e) {
                              return {
                                HCPModalKeys.hcpId: e[HCPModalKeys.hcpId],
                              };
                            }).toList();
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
                      controller:
                          NewEventTextControllers.numberOfStaffController,
                      decoration: InputDecoration(
                        // labelText: AppStrings.labelNumberOfStaff,
                        label: AppTextThemes.labelWithImportant(
                          AppStrings.labelNumberOfStaff,
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? AppStrings.requiredField
                          : null,
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
