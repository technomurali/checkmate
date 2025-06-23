import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/action_button.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/events_recipts_card.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  final UserModal user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {},
        ),
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
                {"title": AppStrings.cardiovascularInnovation},
                {"title": AppStrings.neurologyAdvances},
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
              children: const [
                ActionButton(title: AppStrings.eventHistory),
                ActionButton(title: AppStrings.receiptHistory),
                ActionButton(title: AppStrings.disputeHistory),
                ActionButton(title: AppStrings.fileDispute),
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
