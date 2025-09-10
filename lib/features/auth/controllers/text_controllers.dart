import 'package:flutter/widgets.dart';

class TextControllers {
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController confirmPassword = TextEditingController();
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController city = TextEditingController();
  static TextEditingController pharma = TextEditingController();
  static TextEditingController verificationCode = TextEditingController();
  static TextEditingController companyId = TextEditingController();
  static TextEditingController userRoleId = TextEditingController();
  static final FocusNode passwordFocusNode = FocusNode();
}
class SigninTextControllers {
  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
}
class EventTextControllers {
  static TextEditingController eventNameController = TextEditingController();
  static TextEditingController startDateController = TextEditingController();
  static TextEditingController endDateController = TextEditingController();
  static TextEditingController numberOfStaffController =
      TextEditingController();
  static TextEditingController amountController = TextEditingController();
  static TextEditingController pharmaRepController = TextEditingController();
  static TextEditingController hcoController = TextEditingController();
  static TextEditingController eventDescriptionController =
      TextEditingController();
}

class NewEventTextControllers {
  static TextEditingController eventNameController = TextEditingController();
  static TextEditingController startDateController = TextEditingController();
  static TextEditingController endDateController = TextEditingController();
  static TextEditingController numberOfStaffController =
      TextEditingController();
  static TextEditingController amountController = TextEditingController();
  static TextEditingController pharmaRepController = TextEditingController();
  static TextEditingController hcoController = TextEditingController();
  static TextEditingController eventDescriptionController =
      TextEditingController();
}

class UserProfileTextControllers {
  static TextEditingController profileUrlController = TextEditingController();
  static TextEditingController fullNameController = TextEditingController();
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneNumberController = TextEditingController();
  static TextEditingController cityController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController countryController = TextEditingController();
  static TextEditingController zipCodeController = TextEditingController();
  static TextEditingController companyController = TextEditingController();
  static TextEditingController companyIdController = TextEditingController();
  static TextEditingController roleController = TextEditingController();
}

class DisputeFormTextControllers {
  // 1. HCP Details
  static TextEditingController fullNameController = TextEditingController();
  static TextEditingController npiNumberController = TextEditingController();
  static TextEditingController organizationNameController =
      TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();

  // 2. Transaction Details
  static TextEditingController pharmaCompanyController =
      TextEditingController();
  static TextEditingController eventInteractionController =
      TextEditingController();
  static TextEditingController paymentDateController = TextEditingController();
  static TextEditingController paymentAmountController =
      TextEditingController();
  static TextEditingController paymentTypeController = TextEditingController();
  static TextEditingController referenceNumberController =
      TextEditingController();

  // 3. Dispute Reason
  static TextEditingController descriptionController = TextEditingController();
}

class ReceiptRejectionTextController {
  static TextEditingController remarksController = TextEditingController();
}