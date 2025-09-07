import 'package:checkmate/core/constants/app_api.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/filter_icon.dart';
import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItemTile extends StatelessWidget {
  final EventModal event;
  final VoidCallback? onTap;

  const EventListItemTile({super.key, this.onTap, required this.event});
  Map<String, String> codeForTextOutput(String status) {
    debugPrint("Here is The Status Filter $status");
    // Now check the status using statusIds instead of status strings
    if (status == BasicCodesFromCrm.approval) {
      return {
        'status': 'APPROVED',
        'code': 'A',
        'statusId': BasicCodesFromCrm.approval,
      };
    } else if (status == BasicCodesFromCrm.upcoming) {
      return {
        'status': 'UPCOMING',
        'code': 'B',
        'statusId': BasicCodesFromCrm.upcoming,
      };
    } else if (status == BasicCodesFromCrm.completed) {
      return {
        'status': 'PAST',
        'code': 'B',
        'statusId': BasicCodesFromCrm.completed,
      };
    } else if (status == BasicCodesFromCrm.terminated) {
      return {
        'status': 'TERMINATED',
        'code': 'B',
        'statusId': BasicCodesFromCrm.terminated,
      };
    } else if (status == BasicCodesFromCrm.pending) {
      return {
        'status': 'IN REVIEW',
        'code': 'A',
        'statusId': BasicCodesFromCrm.pending,
      };
    } else if (status == BasicCodesFromCrm.rejected) {
      return {
        'status': 'REJECTED',
        'code': 'A',
        'statusId': BasicCodesFromCrm.rejected,
      };
    } else if (status == '1') {
      return {
        'status': 'DISPUTED',
        'code': 'A',
        'statusId': BasicCodesFromCrm.disputed,
      };
    } else {
      return {
        'status': 'UPCOMING',
        'code': 'B',
        'statusId': BasicCodesFromCrm.upcoming,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(
              context,
              RouteName.eventDetails,
              arguments: event.eventId,
            );
          },
      child: Container(
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
                message: codeForTextOutput(
                  event.eventStatus.toString(),
                )['status'],
                child: FilterIcon(
                  status:
                      codeForTextOutput(
                        event.eventStatus.toString(),
                      )['status'] ??
                      '',
                ),
              ),
            ),

            // if (event.eventStatus.toString().isNotEmpty &&
            //     codeForTextOutput(event.eventStatus.toString())['statusId'] !=
            //         BasicCodesFromCrm.upcoming) ...{
            //   //  if (status['status']?.toLowerCase() == "o") ...{
            //   Positioned(
            //     right: 50,
            //     top: 0,
            //     child: Tooltip(
            //       message: codeForTextOutput(
            //         event.eventApproval.toString(),
            //       )['status'],
            //       child: FilterIcon(
            //         status: codeForTextOutput(
            //           event.eventApproval.toString(),
            //         )['status']!,
            //       ),
            //     ),
            //   ),
            // },
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: Text(
                    event.eventName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 15),

                        SizedBox(width: 5),
                        if (event.isMultiDay) ...{
                          Text(
                            "${DateFormat("dd MMM").format(event.startDate!.toLocal())} - ${DateFormat("dd MMM yyyy").format(event.endDate!.toLocal())}",
                          ),
                        } else ...{
                          Text(
                            DateFormat(
                              "dd MMM yyyy",
                            ).format(event.startDate!.toLocal()),
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        },
                      ],
                    ),
                    Icon(Icons.more_horiz),
                  ],
                ),
                //Text("Pharma Rep:  $pharmaRep"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
