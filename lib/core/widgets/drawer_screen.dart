import 'package:checkmate/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:checkmate/features/auth/screens/file_dispute_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/features/auth/screens/pharma_rep_dashboard.dart';
import 'package:checkmate/features/auth/screens/office_user_dashboard_screen.dart';
import 'package:checkmate/features/auth/screens/hcp_dashboard.dart';

class DrawerScreen extends StatelessWidget {
  final bool inDashboard;
  const DrawerScreen({super.key, this.inDashboard = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.background,
              child: FaIcon(
                FontAwesomeIcons.user,
                color: AppColors.textSecondary,
                size: 32,
              ),
            ),
            accountName: Text(
              "${userModal.firstName} ${userModal.lastName ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              userModal.email ?? '',
              style: TextStyle(fontSize: 14, color: AppColors.border),
            ),
          ),

          ListTile(
            leading: Icon(Icons.event, color: AppColors.primary),
            title: Text(AppStrings.dashboard),
            onTap: () {
              if (userModal.role == UserType.pharmaRep) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmaRepDashboard(user: userModal),
                  ),
                );
              } else if (userModal.role == UserType.hco) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OfficeUserDashboardScreen(user: userModal),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HCPDashboard(user: userModal),
                  ),
                );
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.event, color: AppColors.primary),
            title: Text(AppStrings.eventHistory),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventHistoryScreen()),
              );
            },
          ),
          if (userModal.role != UserType.pharmaRep) ...{
            ListTile(
              leading: Icon(Icons.report_problem, color: AppColors.primary),
              title: Text(AppStrings.fileDispute),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileDisputeScreen()),
                );
              },
            ),
          },
          ListTile(
            leading: Icon(Icons.history, color: AppColors.primary),
            title: Text(AppStrings.disputeHistory),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisputeHistoryScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.accentError),
            title: Text(AppStrings.signOut),
            onTap: () {
              userModal = UserModal.empty();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SigninScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
