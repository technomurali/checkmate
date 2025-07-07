import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/filter_icon.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventListItemTile extends StatelessWidget {
  final String eventName;
  final String startDate;
  final String endDate;
  final String pharmaRep;
  final String id;
  final String status;
  final String approvalStatus;

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
      margin: EdgeInsets.only(bottom: 10),
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.listTileColor,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            right: -1,
            top: 0,
            child: Tooltip(
              message: status,
              child: FilterIcon(status: status),
            ),
          ),

          if (status[0].toLowerCase() != "u") ...{
            if (status[1].toLowerCase() == "o") ...{
              Positioned(
                right: 50,
                top: 0,
                child: Tooltip(
                  message: approvalStatus,
                  child: FilterIcon(status: approvalStatus),
                ),
              ),
            },
          },
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(height: 16),
              if (endDate.isEmpty)
                Text("${AppStrings.labelStartDate}: $startDate"),
              if (endDate.isNotEmpty)
                Text("From : $startDate       To : $endDate"),
              //Text("Pharma Rep:  $pharmaRep"),
            ],
          ),
        ],
      ),
    );
  }
}
