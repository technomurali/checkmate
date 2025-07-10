import 'package:checkmate/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final String status;
  const FilterIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "UPCOMING":
        return upcomingIcon();
      case "COMPLETED":
        return completedIcon();
      case "TERMINATED":
        return terminatedIcon();
      case "APPROVED":
        return approvedIcon();
      case "REJECTED":
        return rejectedIcon();
      case "PENDING":
        return pendingIcon();
      case "OPEN":
        return openIcon();
      case "CLOSED":
        return closedIcon();
      default:
        return Icon(Icons.all_inclusive, color: AppColors.grey);
    }
  }
}

Container upcomingIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.accentPending,
    ),
    child: Text("U"),
  );
}

Container openIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.accentPending,
    ),
    child: Text("O"),
  );
}

Container completedIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.successGreen,
    ),
    child: Text("C"),
  );
}

Container closedIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.accentError,
    ),
    child: Text("C", style: TextStyle(color: AppColors.background)),
  );
}

Container terminatedIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.accentError,
    ),
    child: Text("T", style: TextStyle(color: AppColors.background)),
  );
}

Container approvedIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.successGreen,
    ),
    child: Text("A"),
  );
}

Container rejectedIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.accentError,
    ),
    child: Text("R", style: TextStyle(color: AppColors.background)),
  );
}

Container pendingIcon() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.pending),
    child: Text("P", style: TextStyle(color: AppColors.background)),
  );
}
