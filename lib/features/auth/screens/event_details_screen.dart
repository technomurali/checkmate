import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventName;
  const EventDetailsScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(eventName)));
  }
}
