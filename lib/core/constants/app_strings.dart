class AppStrings {
  static const String appName = "CHECKMATE";
  static const String welcome =
      'Welcome to Checkmate create an event to get started';
  static const String email = "Email";
  static const String password = "Password";
  static const String newPassword = "New Password";
  static const String confirmPassword = "Confirm Password";
  static const String forgotPassword = "Forgot password?";
  static const String signin = "Sign in";
  static const String noAccount = "Don't have an account?";
  static const String signup = "Sign up";
  static const String signInWith = "Sign in with";
  static const String enterEmailInstruction =
      "Enter your email address to receive a verification code.";
  static const String sendVerificationCode = "Send verification code";
  static const String backToSignin = "Back to Sign in";
  static const String signupTerms = "By signing up, you agree to our";
  static const String secureCompliance =
      "Secure compliance. Effortless onboarding";
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String alreadyAccount = "Have an account? Sign in";
  static const String socialMediaSignUp = " Signup with Social Media";
  static const String emailSignUp = " Signup with Email";
  static const String city = "City";
  static const String selectThePharma = "Search & Select your Company";
  static const String verifyCode = "Verify Code";
  static const String enterVerificationCode = "Enter Verification Code";
  static const String resetPassword = "Reset Password";
  static const String helloUser = "Hello";
  static const String pharmaRep = "Pharma Rep";
  static const String upcomingEvents = "Upcoming Events";
  static const String pendingReceipts = "Pending Approval";
  static const String checkIn = "Check in";
  static const String updateEvent = "Update Event";
  static const String submitCheckIn = "Submit Check-in";
  static const String cancelCheckIn = "Cancel Check-in";
  static const String seeAll = "See all";
  static const String eventHistory = "Event History";
  static const String receiptHistory = "Receipt History";
  static const String disputeHistory = "Dispute History";
  static const String fileDispute = "File Dispute";
  static const String createNewEvent = "Create New Event";
  static const String receiptForApproval = "Awaiting Approval";
  static const String numberOfStaff = "Number of staff";
  static const String hcpInEvent = "HCP's in the event";
  static const String hcoInEvent = "HCO's in the event";
  static const String labelEventName = "Event Name";
  static const String labelStartDate = "Event Date";
  static const String labelEndDate = "Event End Date";
  static const String labelNumberOfStaff = "Number of Staff";
  static const String labelHCO = "HCO";
  static const String labelHCOOfficeUser = "OFFICE USER";
  static const String labelHCP = "HCP";
  static const String createEvent = "Create Event";
  static const String requiredField = "Required";
  static const String selectHCO = "Please select HCO";
  static const String selectHCP = "Please select HCP";
  static const String eventCreated = "Event Created";
  static const String eventDeletefailed = "Event Deletion Failed";
  static const String eventCreatedFailed = "Event Creation Failed";
  static const String enterTheCompanyNameWarning =
      "Please choose or enter your company name to move forward.";
  static const String deleteEvent = 'Delete Event';
  static const String deleteEventContent =
      'Are you sure you want to delete this event?';
  static const String searchEvents = "Search events...";
  static const String amount = "Amount";
  static const String uploadReceipt = "Upload Receipt";
  static const String chooseFile = "Choose File";
  static const String labelEventStartDate = "Event Start Date";
  static const String accept = "Accept";
  static const String deny = "Deny";
  static const String termsAndConditions = "Terms and conditions";
  static const String dashboard = "Dashboard";
  static const String signOut = "Sign out";
  static const String labelEventDescription = "Event Details";
  static const String approved = "Approved";
  static const String pending = "Pending";
  static const String userProfile = "Profile";
  static const String sendRequest = "Send Approval Request";
  static const String save = "Save";
  static const String edit = "Edit";
  static const String pharmaCompany = "Pharma Company";
  static const String labelEventType = "Event Type";
  static const String selectEventType = "Please select event type";
  static const String multiDayEvent = "Multi-day Event";
  static const String disputeCategory = "Dispute Category";
  static const String disputeReasonSection = "Dispute Reason";
  static const String supportingDocumentsSection = "Supporting Documents";
  static const String hcpDetailsSection = "HCP Details";
  static const String transactionDetailsSection = "Transaction Details";
  static const String disputeReason = "Dispute Reason";
  static const String fullName = "Full Name";
  static const String npiNumber = "NPI Number";
  static const String organizationName = "Organization Name";
  static const String emailAddress = "Email Address";
  static const String phoneNumber = "Phone Number";
  static const String paymentDate = "Payment Date";
  static const String paymentAmount = "Payment Amount";
  static const String paymentType = "Payment Type";
  static const String referenceNumber = "Reference Number";
  static const String description = "Description";
  static const String eventInteraction = "Event Interaction";
  static const String uploadLabel = "Upload";
  static const String declaration =
      "I hereby declare that the information provided is accurate and I consent to the processing of this dispute.";
  static const String completeFormMessage =
      "Please complete all required fields and agree to the declaration.";
  static const String submitDispute = "Submit Dispute";
  static const String updateDispute = "Update Dispute";
}

class ErrorText {
  static const String emailReq = "Email is required";
  static const String emailError = "Enter a valid email address";
  static const String passMinError = "Minimum 6 characters";
  static const String passMisMatch = "Password does not match";
  static const String shortName = "Name too short";
  static const String nameRequired = "Name is Required";
  static const String cityRequired = "City is required";
  static const String smallCity = "City name is too short";
  static const String somethingWentWrong = "Something went wrong: ";
  static const String passwordCanNotBeEmpty = "Password cannot be empty";

  /// Pharmacies Load Error
  static const String failedToLoadPharmaCompanies =
      "Failed to load pharma companies:";

  /// Incorrect code. Please check your email and try again
  /// Wrong code entered
  static const String wrongCode =
      "Incorrect code. Please check your email and try again";
}

class UserType {
  static const String pharmaRep = "546170001";
  static const String hco = "OFFICE_USER";
  static const String hcp = "546170000";
}

class EventStatus {
  static const String upcoming = "UPCOMING";
  static const String completed = "COMPLETED";
  static const String pending = "PENDING";
  static const String approved = "APPROVED";
  static const String rejected = "REJECTED";
  static const String cancelled = "CANCELLED";
}

class SuccessStrings {
  static const String profileSaved = "Profile saved";
  static const String disputeSubmittedSuccessfully =
      "Dispute submitted successfully";
}

class EventType {
  static const String lunch = "Lunch";
  static const String dinner = "Dinner";
}
