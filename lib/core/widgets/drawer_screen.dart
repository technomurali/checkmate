import 'package:flutter/material.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:checkmate/features/auth/screens/file_dispute_screen.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

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
            title: Text('Event History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventHistoryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long, color: AppColors.primary),
            title: Text('Receipt History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReceiptHistoryScreen()),
              );
            },
          ),
          if (userModal.role != "PHARMA_REP") ...{
            ListTile(
              leading: Icon(Icons.report_problem, color: AppColors.primary),
              title: Text('File Dispute'),
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
            title: Text('Dispute History'),
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
            title: Text('Logout'),
            onTap: () {
              userModal = UserModal.empty();
              // TODO: Implement logout logic
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
