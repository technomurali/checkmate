import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_details_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_form_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/forgot_password_screen.dart';
import 'package:checkmate/features/auth/screens/hcp_dashboard.dart';
import 'package:checkmate/features/auth/screens/new_event_screen.dart';
import 'package:checkmate/features/auth/screens/office_user_dashboard_screen.dart';
import 'package:checkmate/features/auth/screens/password_reset_screen.dart';
import 'package:checkmate/features/auth/screens/pending_receipt_screen.dart';
import 'package:checkmate/features/auth/screens/pharma_rep_dashboard.dart';
import 'package:checkmate/features/auth/screens/profile_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/features/auth/screens/signup_screen.dart';
import 'package:checkmate/features/auth/screens/terms_and_conditions_screen.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // If authenticated, always return TopNav
    if (userModal.id != '0') {
      return MaterialPageRoute(
        builder: (context) => const TopNav(),
        settings: settings,
      );
    }
    // Unauthenticated: normal routing
    Widget screen = Scaffold(body: Center(child: Text('No route defined')));
    switch (settings.name) {
      case RouteName.disputeDetails:
        if (settings.arguments is String) {
          screen = DisputeDetailsScreen(
            disputeId: settings.arguments as String,
          );
        }
        break;
      case RouteName.disputeHistory:
        screen = DisputeHistoryScreen();
        break;
      case RouteName.fileDispute:
        screen = DisputeFormScreen();
        break;
      case RouteName.eventDetails:
        screen = EventDetailsScreen(eventId: settings.arguments as String);
        break;
      case RouteName.newEvent:
        screen = NewEventScreen();
        break;
      case RouteName.eventHistory:
        if (settings.arguments is bool && settings.arguments == true) {
          screen = EventHistoryScreen(fromDashboard: true);
        } else if (settings.arguments is bool && settings.arguments == false) {
          screen = EventHistoryScreen(isPending: true);
        } else {
          screen = EventHistoryScreen();
        }
        break;
      case RouteName.forgotPassword:
        screen = ForgotPasswordScreen();
        break;
      case RouteName.hcpDashboard:
        screen = HCPDashboard(user: userModal);
        break;
      case RouteName.officeUserDashboard:
        screen = OfficeUserDashboardScreen(user: userModal);
        break;
      case RouteName.pharmaRepDashboard:
        screen = PharmaRepDashboard(user: userModal);
        break;
      case RouteName.resetPassword:
        screen = PasswordResetScreen(email: settings.arguments as String);
        break;
      case RouteName.signup:
        screen = SignupScreen();
        break;
      case RouteName.termsAndConditions:
        screen = TermsAndConditionsScreen();
        break;
      case RouteName.profile:
        screen = UserProfileScreen();
        break;
      case RouteName.signIn:
        screen = SigninScreen();
        break;
      case RouteName.pendingReceipt:
      debugPrint("Is the ${RouteName.pendingReceipt}");
        screen = PendingReceiptScreen(eventId: settings.arguments as String);
        break;
      case RouteName.receiptHistory:
        screen = ReceiptHistoryScreen();
        break;
      default:
        screen = Scaffold(body: Center(child: Text('No route defined')));
        break;
    }
    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}
