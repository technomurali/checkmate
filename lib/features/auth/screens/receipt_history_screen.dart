import 'package:checkmate/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class ReceiptHistoryScreen extends StatelessWidget {
  const ReceiptHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text(AppStrings.receiptHistory)));
  }
}
