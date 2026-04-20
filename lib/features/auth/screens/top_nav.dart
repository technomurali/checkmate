import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/top_nav_tile.dart';
import 'package:checkmate/features/auth/model/openpayments_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_form_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/new_event_screen.dart';
import 'package:checkmate/features/auth/screens/open_payments_details.dart';
import 'package:checkmate/features/auth/screens/open_payments_screen.dart';
import 'package:checkmate/features/auth/screens/profile_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/features/auth/screens/pharma_rep_dashboard.dart';
import 'package:checkmate/features/auth/screens/office_user_dashboard_screen.dart';
import 'package:checkmate/features/auth/screens/hcp_dashboard.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_details_screen.dart';
import 'package:checkmate/features/auth/screens/pending_receipt_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:provider/provider.dart';

class TopNav extends StatelessWidget {
  const TopNav({super.key});
  static const bool _isDisputeFormEnabled = false;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<TopNavProvider>(context);
    final TopNavScreen currentScreen = navProvider.currentScreen;
    final Object? argument = navProvider.argument;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        final navProvider = Provider.of<TopNavProvider>(context, listen: false);
        // Try to pop in-app history first
        final handled = navProvider.goBack();
        if (handled) {
          return false; // consumed by in-app back
        }
        // No history left; allow the framework to pop the route (may exit screen/app)
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top > 0
                  ? AppSizes().headerHeight +
                        MediaQuery.of(context).padding.top +
                        6
                  : AppSizes().headerHeight + 6,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top > 10
                    ? MediaQuery.of(context).padding.top - 10
                    : 0,
                left: 10,
              ),
              alignment: Alignment.center,
              width: double.infinity,
              color: AppColors.topNavColor,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              navProvider.navigateTo(TopNavScreen.dashboard),
                          child: TopNavTile(
                            icon: Icon(
                              Icons.dashboard,
                              size: AppSizes().headerIconSize,
                            ),
                            label: "Home",
                          ),
                        ),
                        Container(
                          height: 5,
                          width: 60,
                          color: currentScreen == TopNavScreen.dashboard
                              ? AppColors.topNavTileColor
                              : Colors.transparent,
                          child: const Text(""),
                        ),
                      ],
                    ),
                    if (userModal.role == UserType.pharmaRep ||
                        userModal.role == UserType.hco)
                      Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                navProvider.navigateTo(TopNavScreen.newEvent),
                            child: TopNavTile(
                              icon: Icon(
                                Icons.event_available_outlined,
                                size: AppSizes().headerIconSize,
                              ),
                              label: AppStrings.createEvent,
                            ),
                          ),
                          Container(
                            height: 5,
                            width: 100,
                            color: currentScreen == TopNavScreen.newEvent
                                ? AppColors.topNavTileColor
                                : Colors.transparent,
                            child: const Text(""),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () =>
                              navProvider.navigateTo(TopNavScreen.eventHistory),
                          child: TopNavTile(
                            icon: Icon(
                              Icons.event_repeat_outlined,
                              size: AppSizes().headerIconSize,
                            ),
                            label: AppStrings.eventHistory,
                          ),
                        ),
                        Container(
                          height: 5,
                          width: 100,
                          color: currentScreen == TopNavScreen.eventHistory
                              ? AppColors.topNavTileColor
                              : Colors.transparent,
                          child: const Text(""),
                        ),
                      ],
                    ),
                    if (userModal.role != UserType.pharmaRep &&
                        _isDisputeFormEnabled)
                      Column(
                        children: [
                          InkWell(
                            onTap: () => navProvider.navigateTo(
                              TopNavScreen.fileDispute,
                            ),
                            child: TopNavTile(
                              icon: Icon(
                                Icons.report_problem,
                                size: AppSizes().headerIconSize,
                              ),
                              label: AppStrings.fileDispute,
                            ),
                          ),
                          Container(
                            height: 5,
                            width: 100,
                            color: currentScreen == TopNavScreen.fileDispute
                                ? AppColors.topNavTileColor
                                : Colors.transparent,
                            child: const Text(""),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () => navProvider.navigateTo(
                            TopNavScreen.disputeHistory,
                          ),
                          child: TopNavTile(
                            icon: Icon(
                              Icons.history,
                              size: AppSizes().headerIconSize,
                            ),
                            label: AppStrings.disputeHistory,
                          ),
                        ),
                        Container(
                          height: 5,
                          width: 100,
                          color: currentScreen == TopNavScreen.disputeHistory
                              ? AppColors.topNavTileColor
                              : Colors.transparent,
                          child: const Text(""),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () =>
                              navProvider.navigateTo(TopNavScreen.profile),
                          child: TopNavTile(
                            icon: Icon(
                              Icons.person,
                              size: AppSizes().headerIconSize,
                            ),
                            label: AppStrings.userProfile,
                          ),
                        ),
                        Container(
                          height: 5,
                          width: 80,
                          color: currentScreen == TopNavScreen.profile
                              ? AppColors.topNavTileColor
                              : Colors.transparent,
                          child: const Text(""),
                        ),
                      ],
                    ),
                    if (userModal.role != UserType.pharmaRep)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => navProvider.navigateTo(
                              TopNavScreen.openPayemtsScreen,
                            ),
                            child: TopNavTile(
                              icon: Icon(
                                Icons.report_problem,
                                size: AppSizes().headerIconSize,
                              ),
                              label: AppStrings.openPayemts,
                            ),
                          ),
                          Container(
                            height: 5,
                            width: 100,
                            color:
                                currentScreen == TopNavScreen.openPayemtsScreen
                                ? AppColors.topNavTileColor
                                : Colors.transparent,
                            child: const Text(""),
                          ),
                        ],
                      ),

                    InkWell(
                      onTap: () {
                        userModal = UserModal.empty();
                        navProvider.reset();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const SigninScreen(),
                          ),
                        );
                      },
                      child: TopNavTile(
                        icon: Icon(
                          Icons.power_settings_new_sharp,
                          size: AppSizes().headerIconSize,
                        ),
                        label: AppStrings.signOut,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: _getScreen(currentScreen, argument),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreen(TopNavScreen screen, Object? argument) {
    switch (screen) {
      case TopNavScreen.dashboard:
        if (userModal.role == UserType.pharmaRep) {
          return PharmaRepDashboard(user: userModal);
        } else if (userModal.role == UserType.hco) {
          return OfficeUserDashboardScreen(user: userModal);
        } else {
          return HCPDashboard(user: userModal);
        }
      case TopNavScreen.newEvent:
        return NewEventScreen();
      case TopNavScreen.eventHistory:
        final args = (argument as Map<String, dynamic>?) ?? const {};

        if (args['fromDashboard'] ?? false) {
          return EventHistoryScreen(
            fromDashboard: (args['fromDashboard'] as bool?) ?? false,
          );
        } else {
          return EventHistoryScreen(
            isPending: (args['isPending'] as bool?) ?? false,
          );
        }
      case TopNavScreen.fileDispute:
        return _isDisputeFormEnabled
            ? DisputeFormScreen()
            : DisputeHistoryScreen();
      case TopNavScreen.disputeHistory:
        return DisputeHistoryScreen();
      case TopNavScreen.profile:
        return UserProfileScreen();
      case TopNavScreen.eventDetails:
        if (argument is String) {
          return EventDetailsScreen(eventId: argument);
        } else if (argument is Map<String, dynamic>) {
          final String eventId = (argument['eventId'] ?? '') as String;
          final String? eventType = argument['eventType'] as String?;
          return EventDetailsScreen(eventId: eventId, eventType: eventType);
        } else {
          return EventDetailsScreen(eventId: '');
        }
      case TopNavScreen.disputeDetails:
        return DisputeDetailsScreen(disputeId: argument as String);
      case TopNavScreen.pendingReceipt:
        return PendingReceiptScreen(eventId: argument as String);
      case TopNavScreen.receiptHistory:
        return ReceiptHistoryScreen();
      case TopNavScreen.openPayemtsScreen:
        return OpenPaymentsScreen();
        case TopNavScreen.openPaymentDetails:
        return OpenPaymentsDetails(openPayment: argument as OpenPaymentsModal);
    }
  }
}
