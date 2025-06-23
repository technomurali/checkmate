import 'package:checkmate/core/constants/app_strings.dart';
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
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item["title"] ?? "")),
                    Text(item["date"] ?? ""),
                    if (showCheckIn)
                      TextButton(
                        onPressed: () {},
                        child: const Text(AppStrings.checkIn),
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text("${AppStrings.seeAll} >"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
