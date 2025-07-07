import 'package:checkmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TopNavTile extends StatelessWidget {
  final Icon icon;
  final String label;

  const TopNavTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon.icon, color: AppColors.topNavTileColor, size: icon.size),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.topNavTileColor,
            ),
          ),
        ],
      ),
    );
  }
}
