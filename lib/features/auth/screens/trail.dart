import 'package:flutter/material.dart';

class VerficationTrailScreen extends StatelessWidget {
  final String message;
  const VerficationTrailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(message)),
    );
  }
}
