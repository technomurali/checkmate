// To parse this JSON data, do
//
//     final openPaymentsModal = openPaymentsModalFromJson(jsonString);

import 'dart:convert';

OpenPaymentsModal openPaymentsModalFromJson(String str) =>
    OpenPaymentsModal.fromJson(json.decode(str));

String openPaymentsModalToJson(OpenPaymentsModal data) =>
    json.encode(data.toJson());

class OpenPaymentsModal {
  final String? coveredRecipientNpi;
  final String? coveredRecipientFirstName;
  final dynamic coveredRecipientMiddleName;
  final String? coveredRecipientLastName;
  final String? submittingApplicableManufacturerOrApplicableGpoName;
  final String? totalAmountOfPaymentUsDollars;
  final String? dateOfPayment;
  final String? numberOfPaymentsIncludedInTotalAmount;
  final String? formOfPaymentOrTransferOfValue;
  final String? natureOfPaymentOrTransferOfValue;
  final String? disputeStatusForPublication;
  final String? programYear;
  final String? paymentPublicationDate;

  OpenPaymentsModal({
    this.coveredRecipientNpi,
    this.coveredRecipientFirstName,
    this.coveredRecipientMiddleName,
    this.coveredRecipientLastName,
    this.submittingApplicableManufacturerOrApplicableGpoName,
    this.totalAmountOfPaymentUsDollars,
    this.dateOfPayment,
    this.numberOfPaymentsIncludedInTotalAmount,
    this.formOfPaymentOrTransferOfValue,
    this.natureOfPaymentOrTransferOfValue,
    this.disputeStatusForPublication,
    this.programYear,
    this.paymentPublicationDate,
  });

  factory OpenPaymentsModal.fromJson(Map<String, dynamic> json) =>
      OpenPaymentsModal(
        coveredRecipientNpi: json["covered_Recipient_NPI"],
        coveredRecipientFirstName: json["covered_Recipient_First_Name"],
        coveredRecipientMiddleName: json["covered_Recipient_Middle_Name"],
        coveredRecipientLastName: json["covered_Recipient_Last_Name"],
        submittingApplicableManufacturerOrApplicableGpoName:
            json["submitting_Applicable_Manufacturer_or_Applicable_GPO_Name"],
        totalAmountOfPaymentUsDollars:
            json["total_Amount_of_Payment_USDollars"],
        dateOfPayment: json["date_of_Payment"],
        numberOfPaymentsIncludedInTotalAmount:
            json["number_of_Payments_Included_in_Total_Amount"],
        formOfPaymentOrTransferOfValue:
            json["form_of_Payment_or_Transfer_of_Value"],
        natureOfPaymentOrTransferOfValue:
            json["nature_of_Payment_or_Transfer_of_Value"],
        disputeStatusForPublication: json["dispute_Status_for_Publication"],
        programYear: json["program_Year"],
        paymentPublicationDate: json["payment_Publication_Date"],
      );

  Map<String, dynamic> toJson() => {
    "covered_Recipient_NPI": coveredRecipientNpi,
    "covered_Recipient_First_Name": coveredRecipientFirstName,
    "covered_Recipient_Middle_Name": coveredRecipientMiddleName,
    "covered_Recipient_Last_Name": coveredRecipientLastName,
    "submitting_Applicable_Manufacturer_or_Applicable_GPO_Name":
        submittingApplicableManufacturerOrApplicableGpoName,
    "total_Amount_of_Payment_USDollars": totalAmountOfPaymentUsDollars,
    "date_of_Payment": dateOfPayment,
    "number_of_Payments_Included_in_Total_Amount":
        numberOfPaymentsIncludedInTotalAmount,
    "form_of_Payment_or_Transfer_of_Value": formOfPaymentOrTransferOfValue,
    "nature_of_Payment_or_Transfer_of_Value": natureOfPaymentOrTransferOfValue,
    "dispute_Status_for_Publication": disputeStatusForPublication,
    "program_Year": programYear,
    "payment_Publication_Date": paymentPublicationDate,
  };

  factory OpenPaymentsModal.empty() => OpenPaymentsModal(
    coveredRecipientFirstName: "",
    coveredRecipientLastName: "",
    coveredRecipientMiddleName: "",
    coveredRecipientNpi: "",
    dateOfPayment: "",
    disputeStatusForPublication: "",
    formOfPaymentOrTransferOfValue: "",
    natureOfPaymentOrTransferOfValue: "",
    numberOfPaymentsIncludedInTotalAmount: "",
    paymentPublicationDate: "",
    programYear: "",
    submittingApplicableManufacturerOrApplicableGpoName: "",
    totalAmountOfPaymentUsDollars: "",
  );
}
