// import 'package:checkmate/core/constants/app_strings.dart';
// import 'package:checkmate/core/constants/modal_keys.dart';
// import 'package:checkmate/core/widgets/custom_text_field.dart';
// import 'package:checkmate/features/auth/controllers/dispute_controller.dart';
// import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
// import 'package:checkmate/features/auth/controllers/text_controllers.dart';
// import 'package:checkmate/features/auth/model/dispute_modal.dart';
// import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';

class DisputeFormScreen extends StatefulWidget {
  const DisputeFormScreen({super.key});

  @override
  _DisputeFormScreenState createState() => _DisputeFormScreenState();
}

class _DisputeFormScreenState extends State<DisputeFormScreen> {
  // final _formKey = GlobalKey<FormState>();
  // bool isConfirmed = false;
  // String? selectedDisputeCategory;
  // DisputeController disputeController = DisputeController();
  // PharmaController pharmaCompanyController = PharmaController();

  // final List<String> disputeCategories = [
  //   'Incorrect Amount',
  //   'Wrong Recipient',
  //   'Duplicate Entry',
  //   'Not Acknowledged',
  //   'Other',
  // ];
  // List<String> pharmaCompanies = [
  //   'Pharma Inc',
  //   'BioHealth',
  //   'MediCare',
  //   'Wellness Pharma',
  //   'CureAll',
  // ];
  // String? selectedPharmaCompany;

  // @override
  // initState() {
  //   super.initState();
  //   DisputeFormTextControllers.fullNameController.text =
  //       "${userModal.firstName!} ${userModal.lastName!}";
  //   DisputeFormTextControllers.npiNumberController.text =
  //       userModal.npiNumber ?? '';
  //   DisputeFormTextControllers.organizationNameController.text =
  //       "userModal.hco![0][HCOModalKeys.hcoName]";
  //   DisputeFormTextControllers.emailController.text = userModal.email!;
  //   DisputeFormTextControllers.phoneController.text = userModal.phoneNumber!;
  //   getPharmaCompany();
  // }

  // getPharmaCompany() {
  //   pharmaCompanyController.fetchPharmaCompanies().then((value) {
  //     setState(() {
  //       // pharmaCompanies = value.pharmaCompanies;
  //     });
  //   });
  // }

  // createDispute() {
  //   disputeController
  //       .submitDispute(
  //         DisputeModal(
  //           status: "OPEN",
  //           declarationConfirmed: isConfirmed,
  //           disputeReason: DisputeReason(
  //             disputeCategory: selectedDisputeCategory,
  //             description:
  //                 DisputeFormTextControllers.descriptionController.text,
  //           ),
  //           hcpDetails: HcpDetails(
  //             fullName: DisputeFormTextControllers.fullNameController.text,
  //             npiNumber: DisputeFormTextControllers.npiNumberController.text,
  //             organizationName:
  //                 DisputeFormTextControllers.organizationNameController.text,
  //             email: DisputeFormTextControllers.emailController.text,
  //             phone: DisputeFormTextControllers.phoneController.text,
  //           ),
  //           submittedAt: DateTime.now(),
  //           supportingDocuments: [
  //             SupportingDocument(
  //               fileName: "test.pdf",
  //               fileUrl: "https://www.google.com",
  //             ),
  //           ],
  //           transactionDetails: TransactionDetails(
  //             pharmaCompany:
  //                 DisputeFormTextControllers.pharmaCompanyController.text,
  //             eventInteraction:
  //                 DisputeFormTextControllers.eventInteractionController.text,
  //             paymentDate:
  //                 DisputeFormTextControllers.paymentDateController.text,
  //             paymentAmount:
  //                 DisputeFormTextControllers.paymentAmountController.text,
  //             paymentType:
  //                 DisputeFormTextControllers.paymentTypeController.text,
  //             referenceNumber:
  //                 DisputeFormTextControllers.referenceNumberController.text,
  //           ),
  //         ),
  //       )
  //       .then((value) {
  //         if (value) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(SuccessStrings.disputeSubmittedSuccessfully),
  //             ),
  //           );
  //           // DisputeFormTextControllers.fullNameController.clear();
  //           // DisputeFormTextControllers.npiNumberController.clear();
  //           // DisputeFormTextControllers.organizationNameController.clear();
  //           DisputeFormTextControllers.emailController.clear();
  //           DisputeFormTextControllers.phoneController.clear();
  //           DisputeFormTextControllers.pharmaCompanyController.clear();
  //           DisputeFormTextControllers.eventInteractionController.clear();
  //           DisputeFormTextControllers.paymentDateController.clear();
  //           DisputeFormTextControllers.paymentAmountController.clear();
  //           DisputeFormTextControllers.paymentTypeController.clear();
  //           DisputeFormTextControllers.referenceNumberController.clear();
  //           DisputeFormTextControllers.descriptionController.clear();
  //           selectedDisputeCategory = null;
  //           selectedPharmaCompany = null;
  //           isConfirmed = false;
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text(ErrorText.somethingWentWrong)),
  //           );
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Dispute Form Screen - Under Construction')),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     padding: EdgeInsets.all(16),
  //     child: Form(
  //       key: _formKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // 1. HCP Details
  //           Text(
  //             AppStrings.hcpDetailsSection,
  //             style: Theme.of(context).textTheme.titleSmall,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             readOnly: true,
  //             label: AppStrings.fullName,
  //             controller: DisputeFormTextControllers.fullNameController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             readOnly: true,
  //             label: AppStrings.npiNumber,
  //             controller: DisputeFormTextControllers.npiNumberController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             readOnly: true,
  //             label: AppStrings.organizationName,
  //             controller: DisputeFormTextControllers.organizationNameController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.emailAddress,
  //             keyboardType: TextInputType.emailAddress,
  //             controller: DisputeFormTextControllers.emailController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.phoneNumber,
  //             keyboardType: TextInputType.phone,
  //             controller: DisputeFormTextControllers.phoneController,
  //           ),
  //           SizedBox(height: 20),

  //           // 2. Transaction Details
  //           Text(
  //             AppStrings.transactionDetailsSection,
  //             style: Theme.of(context).textTheme.titleSmall,
  //           ),
  //           SizedBox(height: 10),
  //           Autocomplete<String>(
  //             optionsBuilder: (TextEditingValue textEditingValue) {
  //               if (textEditingValue.text == '') {
  //                 return const Iterable<String>.empty();
  //               }
  //               return pharmaCompanies.where((String option) {
  //                 return option.toLowerCase().contains(
  //                   textEditingValue.text.toLowerCase(),
  //                 );
  //               });
  //             },
  //             onSelected: (String selection) {
  //               setState(() {
  //                 selectedPharmaCompany = selection;
  //                 DisputeFormTextControllers.pharmaCompanyController.text =
  //                     selection;
  //               });
  //             },
  //             fieldViewBuilder:
  //                 (context, controller, focusNode, onFieldSubmitted) {
  //                   controller.text =
  //                       DisputeFormTextControllers.pharmaCompanyController.text;
  //                   return TextField(
  //                     controller: controller,
  //                     focusNode: focusNode,
  //                     decoration: InputDecoration(
  //                       labelText: AppStrings.selectThePharma,
  //                       suffixIcon: Icon(Icons.search),
  //                     ),

  //                     onChanged: (val) {
  //                       DisputeFormTextControllers
  //                               .pharmaCompanyController
  //                               .text =
  //                           val;
  //                     },
  //                   );
  //                 },
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.eventInteraction,
  //             controller: DisputeFormTextControllers.eventInteractionController,
  //           ),
  //           SizedBox(height: 10),
  //           TextFormField(
  //             decoration: InputDecoration(labelText: AppStrings.paymentDate),
  //             keyboardType: TextInputType.datetime,
  //             controller: DisputeFormTextControllers.paymentDateController,
  //             readOnly: true,
  //             onTap: () async {
  //               FocusScope.of(context).requestFocus(FocusNode());
  //               final DateTime? picked = await showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime.now(),
  //                 firstDate: DateTime(2000),
  //                 lastDate: DateTime.now(),
  //               );
  //               if (picked != null) {
  //                 DisputeFormTextControllers.paymentDateController.text =
  //                     "${picked.day}/${picked.month}/${picked.year}";
  //               }
  //             },
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.paymentAmount,
  //             keyboardType: TextInputType.number,
  //             controller: DisputeFormTextControllers.paymentAmountController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.paymentType,
  //             controller: DisputeFormTextControllers.paymentTypeController,
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.referenceNumber,
  //             controller: DisputeFormTextControllers.referenceNumberController,
  //           ),
  //           SizedBox(height: 20),

  //           // 3. Dispute Reason
  //           Text(
  //             AppStrings.disputeReasonSection,
  //             style: Theme.of(context).textTheme.titleSmall,
  //           ),
  //           DropdownButtonFormField<String>(
  //             decoration: InputDecoration(
  //               labelText: AppStrings.disputeCategory,
  //             ),
  //             value: selectedDisputeCategory,
  //             items: disputeCategories
  //                 .map(
  //                   (item) => DropdownMenuItem(value: item, child: Text(item)),
  //                 )
  //                 .toList(),
  //             onChanged: (value) =>
  //                 setState(() => selectedDisputeCategory = value),
  //           ),
  //           SizedBox(height: 10),
  //           CustomTextField(
  //             label: AppStrings.description,
  //             controller: DisputeFormTextControllers.descriptionController,
  //           ),
  //           SizedBox(height: 20),

  //           // 4. File Upload
  //           Text(
  //             AppStrings.supportingDocumentsSection,
  //             style: Theme.of(context).textTheme.titleSmall,
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               
  //             },
  //             child: Text(AppStrings.uploadLabel),
  //           ),
  //           SizedBox(height: 20),

  //           // 5. Consent and Submission
  //           Row(
  //             children: [
  //               Checkbox(
  //                 value: isConfirmed,
  //                 onChanged: (value) =>
  //                     setState(() => isConfirmed = value ?? false),
  //               ),
  //               Expanded(child: Text(AppStrings.declaration)),
  //             ],
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (_formKey.currentState!.validate() && isConfirmed) {
  //                 createDispute();
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text(AppStrings.completeFormMessage)),
  //                 );
  //               }
  //             },
  //             child: Text(AppStrings.submitDispute),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
