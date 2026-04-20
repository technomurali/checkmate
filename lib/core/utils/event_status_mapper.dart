import 'package:checkmate/core/constants/app_api.dart';

class EventStatusMapper {
  static String statusLabel(String statusCode) {
    if (statusCode == BasicCodesFromCrm.upcoming) return "UPCOMING";
    if (statusCode == BasicCodesFromCrm.terminated) return "TERMINATED";
    if (statusCode == BasicCodesFromCrm.completed) return "COMPLETED";
    if (statusCode == BasicCodesFromCrm.disputed) return "DISPUTED";
    return "";
  }

  static String approvalLabel(
    String statusCode, {
    String pendingLabel = "Pending",
  }) {
    if (statusCode == BasicCodesFromCrm.approval) return "Approved";
    if (statusCode == BasicCodesFromCrm.pending) return pendingLabel;
    if (statusCode == BasicCodesFromCrm.rejected) return "Rejected";
    return "Unknown";
  }

  static String eventHeaderLabel({
    required String eventStatusCode,
    required String eventApprovalCode,
    required String? statusText,
    required bool hasEventCheckIn,
  }) {
    if (eventStatusCode == BasicCodesFromCrm.completed) {
      final approval = approvalLabel(
        eventApprovalCode,
        pendingLabel: "In Review",
      ).toUpperCase();
      return "${statusLabel(eventStatusCode)} & $approval EVENT";
    }
    if (statusText != null &&
        !hasEventCheckIn &&
        statusText.toUpperCase() == "PAST" &&
        (eventStatusCode == BasicCodesFromCrm.upcoming ||
            eventStatusCode.isEmpty)) {
      return "IN-COMPLETE EVENT";
    }
    return "${statusLabel(eventStatusCode)} EVENT";
  }
}
