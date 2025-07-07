import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';

class DisputeHistoryScreen extends StatelessWidget {
  const DisputeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TopNav(body: Center(child: Text(AppStrings.disputeHistory)));
  }
}
