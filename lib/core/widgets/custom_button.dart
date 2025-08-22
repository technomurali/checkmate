import 'package:checkmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final bool isDisabled;
  final Function()? onPressed;
  final double height;
  final Color color;
  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.height = 48,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.textSecondary : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
