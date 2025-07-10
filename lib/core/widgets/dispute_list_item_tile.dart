import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/filter_icon.dart';
import 'package:checkmate/features/auth/screens/dispute_details_screen.dart';
import 'package:flutter/material.dart';

class DisputeListItemTile extends StatelessWidget {
  final String disputeId;
  final String disputeReason;
  final String hcpDetails;
  final String pharmaCompany;
  final String eventInteraction;
  final String paymentDate;
  final String paymentAmount;
  final String paymentType;
  final String referenceNumber;
  final String status;
  const DisputeListItemTile({
    super.key,
    required this.disputeId,
    required this.disputeReason,
    required this.hcpDetails,
    required this.pharmaCompany,
    required this.eventInteraction,
    required this.paymentDate,
    required this.paymentAmount,
    required this.paymentType,
    required this.referenceNumber,
    required this.status,
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
          // Positioned(
          //   right: -1,
          //   top: 0,
          //   child: Tooltip(
          //     message: status,
          //     child: FilterIcon(status: status),
          //   ),
          // ),

          // if (status[0].toLowerCase() != "u") ...{
          Positioned(
            right: 50,
            top: 0,
            child: Tooltip(
              message: status,
              child: FilterIcon(status: status),
            ),
          ),

          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  print("disputeId : $disputeId");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisputeDetailsScreen(disputeId: disputeId),
                    ),
                  );
                },
                child: Text(
                  disputeReason,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("Payment Date: $paymentDate"),
              Text("Payment Amount: $paymentAmount"),
              Text("Payment Type: $paymentType"),
              Text("Reference Number: $referenceNumber"),

              //Text("Pharma Rep:  $pharmaRep"),
            ],
          ),
        ],
      ),
    );
  }
}
