import 'package:checkmate/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class EventHistoryScreen extends StatelessWidget {
  const EventHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(AppStrings.eventHistory)));
  }
}
