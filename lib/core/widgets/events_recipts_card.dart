import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/pending_receipt_screen.dart';
import 'package:flutter/material.dart';

class EventsReciptsCard extends StatelessWidget {
  final List<Map<String, String>> items;
  final VoidCallback onSeeAll;
  final bool showCheckIn;
  final bool isPending;
  const EventsReciptsCard({
    super.key,
    required this.items,
    required this.onSeeAll,
    this.showCheckIn = false,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("items: $items");
    return Card(
      color: isPending
          ? AppColors.pendingCardColor
          : AppColors.upcomingCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (items.isNotEmpty) ...{
              ...items.map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isPending) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PendingReceiptScreen(
                                  eventId: item["id"] ?? '',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(
                                  eventId: item["id"] ?? '',
                                ),
                              ),
                            );
                          }
                        },
                        child: Tooltip(
                          message: item["title"],
                          child: SizedBox(
                            width: AppSizes().dashboardCardTextLimiter,
                            child: Text(
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                              ),
                              overflow: showCheckIn
                                  ? TextOverflow.ellipsis
                                  : null,

                              item["title"] ?? "",
                            ),
                          ),
                        ),
                      ),
                      Text(item["date"] ?? ""),

                      // if (showCheckIn)
                      //   InkWell(
                      //     onTap: () {},
                      //     child: const Text(
                      //       AppStrings.checkIn,
                      //       style: TextStyle(color: AppColors.primary),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            },
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showCheckIn
                            ? EventHistoryScreen(fromDashboard: true)
                            : EventHistoryScreen(isPending: true),
                      ),
                    );
                  },
                  child: const Text(
                    "${AppStrings.seeAll} >",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
