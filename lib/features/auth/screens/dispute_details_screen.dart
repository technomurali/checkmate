import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/dispute_controller.dart';
import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/dispute_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DisputeDetailsScreen extends StatefulWidget {
  const DisputeDetailsScreen({super.key, required this.disputeId});
  final String disputeId;

  @override
  _DisputeDetailsScreenState createState() => _DisputeDetailsScreenState();
}

class _DisputeDetailsScreenState extends State<DisputeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool isLoading = false;
  String? selectedDisputeCategory;
  DisputeController disputeController = DisputeController();
  PharmaController pharmaCompanyController = PharmaController();
  DisputeModal disputeDetails = DisputeModal().empty();
  final List<String> disputeCategories = [
    'Incorrect Amount',
    'Wrong Recipient',
    'Duplicate Entry',
    'Not Acknowledged',
    'Other',
  ];
  List<String> pharmaCompanies = [
    'Pharma Inc',
    'BioHealth',
    'MediCare',
    'Wellness Pharma',
    'CureAll',
  ];
  String? selectedPharmaCompany;

  @override
  initState() {
    super.initState();
    getPharmaCompany();
    getDisputeDetails();
  }

  String _resolveOrganizationName() {
    final hco = userModal.hco;
    if (hco == null || hco.isEmpty) return '';
    final first = hco.first;
    if (first is Map && first[HCOModalKeys.hcoName] != null) {
      return first[HCOModalKeys.hcoName].toString();
    }
    return '';
  }

  getPharmaCompany() {
    pharmaCompanyController.fetchPharmaCompanies().then((value) {
      if (!mounted) return;
      setState(() {
        pharmaCompanies = value.pharmaCompanies
            .map<String>((e) => (e['accountName'] ?? '').toString())
            .where((name) => name.isNotEmpty)
            .toList();
      });
    });
  }

  getDisputeDetails() {
    setState(() {
      isLoading = true;
    });
    disputeController.fetchDisputeDetails(disputeId: widget.disputeId).then((
      value,
    ) {
      if (!mounted) return;
      setState(() {
        disputeDetails = value;
        DisputeFormTextControllers.fullNameController.text =
            "${userModal.firstName ?? ''} ${userModal.lastName ?? ''}".trim();
        DisputeFormTextControllers.npiNumberController.text =
            userModal.npiNumber ?? '';
        DisputeFormTextControllers.organizationNameController.text =
            _resolveOrganizationName();
        DisputeFormTextControllers.emailController.text = userModal.email ?? '';
        DisputeFormTextControllers.phoneController.text =
            userModal.phoneNumber ?? '';
        DisputeFormTextControllers.pharmaCompanyController.text =
            disputeDetails.transactionDetails?.pharmaCompany ?? '';
        DisputeFormTextControllers.eventInteractionController.text =
            disputeDetails.transactionDetails?.eventInteraction ?? '';
        DisputeFormTextControllers.paymentDateController.text =
            disputeDetails.transactionDetails?.paymentDate ?? '';
        DisputeFormTextControllers.paymentAmountController.text =
            disputeDetails.transactionDetails?.paymentAmount ?? '';
        DisputeFormTextControllers.paymentTypeController.text =
            disputeDetails.transactionDetails?.paymentType ?? '';
        DisputeFormTextControllers.referenceNumberController.text =
            disputeDetails.transactionDetails?.referenceNumber ?? '';
        DisputeFormTextControllers.descriptionController.text =
            disputeDetails.disputeReason?.description ?? '';
        selectedDisputeCategory = disputeDetails.disputeReason?.disputeCategory;
        selectedPharmaCompany =
            disputeDetails.transactionDetails?.pharmaCompany;
        isLoading = false;
      });
    }).catchError((_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  updateDispute() {
    disputeController
        .submitDispute(
          DisputeModal(
            disputeId: widget.disputeId,
            status: "OPEN",
            disputeReason: DisputeReason(
              disputeCategory: selectedDisputeCategory,
              description:
                  DisputeFormTextControllers.descriptionController.text,
            ),
            hcpDetails: HcpDetails(
              fullName: DisputeFormTextControllers.fullNameController.text,
              npiNumber: DisputeFormTextControllers.npiNumberController.text,
              organizationName:
                  DisputeFormTextControllers.organizationNameController.text,
              email: DisputeFormTextControllers.emailController.text,
              phone: DisputeFormTextControllers.phoneController.text,
            ),
            submittedAt: DateTime.now(),
            supportingDocuments: [
              SupportingDocument(
                fileName: "test.pdf",
                fileUrl: "https://www.google.com",
              ),
            ],
            transactionDetails: TransactionDetails(
              pharmaCompany:
                  DisputeFormTextControllers.pharmaCompanyController.text,
              eventInteraction:
                  DisputeFormTextControllers.eventInteractionController.text,
              paymentDate:
                  DisputeFormTextControllers.paymentDateController.text,
              paymentAmount:
                  DisputeFormTextControllers.paymentAmountController.text,
              paymentType:
                  DisputeFormTextControllers.paymentTypeController.text,
              referenceNumber:
                  DisputeFormTextControllers.referenceNumberController.text,
            ),
          ),
        )
        .then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(SuccessStrings.disputeSubmittedSuccessfully),
              ),
            );
            DisputeFormTextControllers.fullNameController.clear();
            DisputeFormTextControllers.npiNumberController.clear();
            DisputeFormTextControllers.organizationNameController.clear();
            DisputeFormTextControllers.emailController.clear();
            DisputeFormTextControllers.phoneController.clear();
            DisputeFormTextControllers.pharmaCompanyController.clear();
            DisputeFormTextControllers.eventInteractionController.clear();
            DisputeFormTextControllers.paymentDateController.clear();
            DisputeFormTextControllers.paymentAmountController.clear();
            DisputeFormTextControllers.paymentTypeController.clear();
            DisputeFormTextControllers.referenceNumberController.clear();
            DisputeFormTextControllers.descriptionController.clear();
            selectedDisputeCategory = null;
            selectedPharmaCompany = null;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(ErrorText.somethingWentWrong)),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: const Icon(Icons.edit, color: AppColors.blue),
                  onTap: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
                SizedBox(width: 10),
                InkWell(
                  child: Icon(Icons.delete, color: AppColors.accentError),
                ),
              ],
            ),
            // 1. HCP Details
            Text(
              AppStrings.hcpDetailsSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: true,
              label: AppStrings.fullName,
              controller: DisputeFormTextControllers.fullNameController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: true,
              label: AppStrings.npiNumber,
              controller: DisputeFormTextControllers.npiNumberController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: true,
              label: AppStrings.organizationName,
              controller: DisputeFormTextControllers.organizationNameController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.emailAddress,
              keyboardType: TextInputType.emailAddress,
              controller: DisputeFormTextControllers.emailController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.phoneNumber,
              keyboardType: TextInputType.phone,
              controller: DisputeFormTextControllers.phoneController,
            ),
            SizedBox(height: 20),

            // 2. Transaction Details
            Text(
              AppStrings.transactionDetailsSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 10),
            isEdit
                ? Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return pharmaCompanies.where((String option) {
                        return option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                      });
                    },
                    onSelected: (String selection) {
                      setState(() {
                        selectedPharmaCompany = selection;
                        DisputeFormTextControllers
                                .pharmaCompanyController
                                .text =
                            selection;
                      });
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                          controller.text = DisputeFormTextControllers
                              .pharmaCompanyController
                              .text;
                          return TextField(
                            enabled: true,
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: AppStrings.selectThePharma,
                              suffixIcon: Icon(Icons.search),
                            ),
                            onChanged: (val) {
                              DisputeFormTextControllers
                                      .pharmaCompanyController
                                      .text =
                                  val;
                            },
                          );
                        },
                  )
                : TextField(
                    enabled: false,
                    controller:
                        DisputeFormTextControllers.pharmaCompanyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: AppStrings.selectThePharma,
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.eventInteraction,
              controller: DisputeFormTextControllers.eventInteractionController,
            ),
            SizedBox(height: 10),
            TextFormField(
              enabled: isEdit,
              decoration: InputDecoration(labelText: AppStrings.paymentDate),
              keyboardType: TextInputType.datetime,
              controller: DisputeFormTextControllers.paymentDateController,
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  DisputeFormTextControllers.paymentDateController.text =
                      "${picked.day}/${picked.month}/${picked.year}";
                }
              },
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.paymentAmount,
              keyboardType: TextInputType.number,
              controller: DisputeFormTextControllers.paymentAmountController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.paymentType,
              controller: DisputeFormTextControllers.paymentTypeController,
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.referenceNumber,
              controller: DisputeFormTextControllers.referenceNumberController,
            ),
            SizedBox(height: 20),

            // 3. Dispute Reason
            Text(
              AppStrings.disputeReasonSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: AppStrings.disputeCategory,
              ),
              value: selectedDisputeCategory,
              items: disputeCategories
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedDisputeCategory = value),
            ),
            SizedBox(height: 10),
            CustomTextField(
              readOnly: !isEdit,
              label: AppStrings.description,
              controller: DisputeFormTextControllers.descriptionController,
            ),
            SizedBox(height: 20),

            // 4. File Upload
            Text(
              AppStrings.supportingDocumentsSection,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (!isEdit)
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                    );

                    if (!mounted) return;

                    if (result != null && result.files.isNotEmpty) {
                      final count = result.files.length;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            count == 1
                                ? '1 file selected: ${result.files.first.name}'
                                : '$count files selected',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No file selected')),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File pick failed: $e')),
                    );
                  }
                },
                child: Text(AppStrings.uploadLabel),
              ),
            SizedBox(height: 20),

            // 5. Consent and Submission
            SizedBox(height: 10),
            if (isEdit)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateDispute();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.completeFormMessage)),
                    );
                  }
                },
                child: Text(AppStrings.updateDispute),
              ),
          ],
        ),
      ),
    );
  }
}
