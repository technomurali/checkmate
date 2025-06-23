import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/dispute_history_screen.dart';
import 'package:checkmate/features/auth/screens/event_history_screen.dart';
import 'package:checkmate/features/auth/screens/file_dispute_screen.dart';
import 'package:checkmate/features/auth/screens/receipt_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmaRepDashboard extends StatelessWidget {
  final UserModal user;
  const PharmaRepDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: AppColors.background,

        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.border,
              child: FaIcon(
                FontAwesomeIcons.user,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppStrings.helloUser} ${user.firstName}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(AppStrings.pharmaRep, style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            Text(
              AppStrings.upcomingEvents,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            EventsReciptsCard(
              items: const [
                {
                  "title": AppStrings.cardiovascularInnovation,
                  "date": "26/JUNE/2024",
                },
                {"title": AppStrings.neurologyAdvances, "date": "26/JUNE/2024"},
              ],
              showCheckIn: true,
              onSeeAll: () {},
            ),

            const SizedBox(height: 16),
            Text(
              AppStrings.pendingReceipts,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            EventsReciptsCard(
              items: const [
                {"title": AppStrings.diabetesCareSolutions},
                {"title": AppStrings.respiratoryTherapy},
              ],
              onSeeAll: () {},
            ),

            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.7,
              children: [
                Button(
                  text: AppStrings.eventHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventHistoryScreen(),
                      ),
                    );
                  },
                ),
                Button(
                  text: AppStrings.receiptHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptHistoryScreen(),
                      ),
                    );
                  },
                ),
                Button(
                  text: AppStrings.disputeHistory,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisputeHistoryScreen(),
                      ),
                    );
                  },
                ),
                Button(
                  text: AppStrings.fileDispute,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FileDisputeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Button(text: AppStrings.createNewEvent, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
