import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/confirm_alert_dialog.dart';
import 'package:checkmate/core/widgets/dispute_list_item_tile.dart';
import 'package:checkmate/features/auth/controllers/dispute_controller.dart';
import 'package:checkmate/features/auth/model/dispute_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/core/utils/top_nav_provider.dart';

class DisputeHistoryScreen extends StatefulWidget {
  const DisputeHistoryScreen({super.key});

  @override
  State<DisputeHistoryScreen> createState() => _DisputeHistoryScreenState();
}

class _DisputeHistoryScreenState extends State<DisputeHistoryScreen> {
  DisputeController disputeController = DisputeController();
  List<DisputeModal> disputes = [];
  @override
  void initState() {
    super.initState();
    fetchDisputes();
  }

  fetchDisputes() {
    disputeController.fetchAllDisputes().then((value) {
      setState(() {
        disputes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (disputes.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              AppStrings.comingSoon,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (ctx, i) => historyItemBuilder(i),
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemCount: disputes.length,
            ),
          ),
      ],
    );
  }

  Widget historyItemBuilder(int i) {
    final dispute = disputes[i];
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (ctx) => ConfirmAlertDialog(
                  title: AppStrings.deleteEvent,
                  content: AppStrings.deleteEventContent,
                  onConfirm: () {},
                ),
              );
            },
            backgroundColor: AppColors.accentError,
            foregroundColor: AppColors.background,
            icon: Icons.delete,
          ),
        ],
      ),
      child: DisputeListItemTile(
        disputeId: dispute.disputeId ?? '',
        disputeReason: dispute.disputeReason?.disputeCategory ?? '',
        hcpDetails: dispute.hcpDetails?.fullName ?? '',
        pharmaCompany: dispute.transactionDetails?.pharmaCompany ?? '',
        eventInteraction: dispute.transactionDetails?.eventInteraction ?? '',
        paymentDate: dispute.transactionDetails?.paymentDate ?? '',
        paymentAmount: dispute.transactionDetails?.paymentAmount ?? '',
        paymentType: dispute.transactionDetails?.paymentType ?? '',
        referenceNumber: dispute.transactionDetails?.referenceNumber ?? '',
        status: dispute.status ?? '',
        onTap: () {
          Provider.of<TopNavProvider>(context, listen: false).navigateTo(
            TopNavScreen.disputeDetails,
            argument: dispute.disputeId,
          );
        },
      ),
    );
  }
}
