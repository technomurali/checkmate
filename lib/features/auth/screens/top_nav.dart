import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/top_nav_tile.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_form_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/new_event_screen.dart';
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
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/top_nav_provider.dart';
import 'package:provider/provider.dart';

class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<TopNavProvider>(context);
    final TopNavScreen currentScreen = navProvider.currentScreen;
    final Object? argument = navProvider.argument;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height:
                AppSizes().headerHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top - 10,
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
                  InkWell(
                    onTap: () => navProvider.navigateTo(TopNavScreen.dashboard),
                    child: TopNavTile(
                      icon: Icon(
                        Icons.dashboard,
                        size: AppSizes().headerIconSize,
                      ),
                      label: "Home",
                    ),
                  ),
                  if (userModal.role == UserType.pharmaRep)
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
                  if (userModal.role != UserType.pharmaRep)
                    InkWell(
                      onTap: () =>
                          navProvider.navigateTo(TopNavScreen.fileDispute),
                      child: TopNavTile(
                        icon: Icon(
                          Icons.report_problem,
                          size: AppSizes().headerIconSize,
                        ),
                        label: AppStrings.fileDispute,
                      ),
                    ),
                  InkWell(
                    onTap: () =>
                        navProvider.navigateTo(TopNavScreen.disputeHistory),
                    child: TopNavTile(
                      icon: Icon(
                        Icons.history,
                        size: AppSizes().headerIconSize,
                      ),
                      label: AppStrings.disputeHistory,
                    ),
                  ),
                  InkWell(
                    onTap: () => navProvider.navigateTo(TopNavScreen.profile),
                    child: TopNavTile(
                      icon: Icon(Icons.person, size: AppSizes().headerIconSize),
                      label: AppStrings.userProfile,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      userModal = UserModal.empty();
                      navProvider.reset();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SigninScreen()),
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
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _getScreen(currentScreen, argument),
            ),
          ),
        ],
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
        return EventHistoryScreen();
      case TopNavScreen.fileDispute:
        return DisputeFormScreen();
      case TopNavScreen.disputeHistory:
        return DisputeHistoryScreen();
      case TopNavScreen.profile:
        return UserProfileScreen();
      case TopNavScreen.eventDetails:
        return EventDetailsScreen(eventId: argument as String);
      case TopNavScreen.disputeDetails:
        return DisputeDetailsScreen(disputeId: argument as String);
      case TopNavScreen.pendingReceipt:
        return PendingReceiptScreen(eventId: argument as String);
      case TopNavScreen.receiptHistory:
        return ReceiptHistoryScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
