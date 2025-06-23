import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/features/auth/screens/event_details_screen.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:flutter/material.dart';

class EventsReciptsCard extends StatelessWidget {
  final List<Map<String, String>> items;
  final VoidCallback onSeeAll;
  final bool showCheckIn;
  const EventsReciptsCard({
    super.key,
    required this.items,
    required this.onSeeAll,
    this.showCheckIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ...items.map(
              (item) => Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                              eventName: item["title"] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Tooltip(
                        message: item["title"],
                        child: SizedBox(
                          width: showCheckIn ? 100 : null,
                          child: Expanded(
                            child: Text(
                              overflow: showCheckIn
                                  ? TextOverflow.ellipsis
                                  : null,

                              item["title"] ?? "",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(item["date"] ?? ""),
                    SizedBox(width: 10),
                    if (showCheckIn)
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          AppStrings.checkIn,
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showCheckIn
                            ? EventHistoryScreen()
                            : ReceiptHistoryScreen(),
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
