import 'package:checkmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextThemes {
  static const TextStyle labelTextStyle = TextStyle(
    color: Color(0xB3000000),
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
 static RichText labelWithImportant(String labelText) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: labelText, style: AppTextThemes.labelTextStyle),
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.accentError),
          ),
        ],
      ),
    );
  }
}
