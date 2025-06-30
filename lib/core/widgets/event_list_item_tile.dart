import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventListItemTile extends StatelessWidget {
  final String eventName;
  final String startDate;
  final String endDate;
  final String pharmaRep;
  final String id;
  final String status;
  final bool approvalStatus;

  const EventListItemTile({
    super.key,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.pharmaRep,
    required this.id,
    required this.status,
    required this.approvalStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            right: -1,
            top: 0,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status[0].toLowerCase() == "u"
                    ? AppColors.accentPending
                    : AppColors.successGreen,
              ),
              child: Text(status[0]),
            ),
          ),

          Positioned(
            right: 50,
            top: 0,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !approvalStatus
                    ? AppColors.accentPending
                    : AppColors.successGreen,
              ),
              child: Text(approvalStatus ? "A" : "P"),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsScreen(eventId: id),
                    ),
                  );
                },
                child: Text(
                  eventName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text("From: $startDate    To: $endDate"),
              //Text("Pharma Rep:  $pharmaRep"),
            ],
          ),
        ],
      ),
    );
  }
}
