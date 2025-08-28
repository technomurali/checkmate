import 'package:checkmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final String status;
  const FilterIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "UPCOMING":
        return container(
          color: AppColors.upcomingStatusBadge,
          textColor: AppColors.upcomingStatusBadgeTextColor,
        );
      case "PAST" || "APPROVED":
        return container(
          color: AppColors.pastStatusBadge,
          textColor: AppColors.pastStatusBadgeTextColor,
        );

      case "IN REVIEW" || "DISPUTED" || "TERMINATED" || "REJECTED":
        return container(
          color: AppColors.inReviewStatusBadge,
          textColor: AppColors.inReviewStatusBadgeTextColor,
        );
      // case "OPEN":
      //   return openIcon();
      // case "CLOSED":
      //   return closedIcon();
      // case "DISPUTED":
      //   return container(color: AppColors.accentError);
      default:
        return container(
          color: AppColors.filterStatusBadge,
          textColor: AppColors.filterStatusBadgeTextColor,
        );
    }
  }

  Container container({
    required Color color,
    Color textColor = AppColors.upcomingStatusBadgeTextColor,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(13),
          right: Radius.circular(13),
        ),
        //shape: BoxShape.circle,
        color: color,
      ),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
