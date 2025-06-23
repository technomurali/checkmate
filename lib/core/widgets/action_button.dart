import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String title;
  const ActionButton({required this.title});

  @override
  Widget build(BuildContext context) {
    return Button(text: title, onPressed: () {});
  }
}
