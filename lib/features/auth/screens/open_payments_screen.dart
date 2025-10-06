import 'dart:convert';

import 'package:checkmate/core/utils/top_nav_provider.dart';
import 'package:checkmate/core/widgets/payment_card.dart';
import 'package:checkmate/features/auth/controllers/open_payemts_controller.dart';
import 'package:checkmate/features/auth/model/openpayments_modal.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenPaymentsScreen extends StatefulWidget {
  const OpenPaymentsScreen({super.key});

  @override
  State<OpenPaymentsScreen> createState() => _OpenPaymentsScreenState();
}

class _OpenPaymentsScreenState extends State<OpenPaymentsScreen> {
  OpenPayemtsController _openPayemtsController = OpenPayemtsController();
  List<OpenPaymentsModal> openPayments = [];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    if (userModal.npiNumber != null) {
      try {
        final value = await _openPayemtsController.getOpenPaymentsList(
          userModal.npiNumber ?? '',
        );
        if (!mounted) return;
        setState(() {
          openPayments = value;
          if (openPayments.isNotEmpty) {
            debugPrint(
              "Open Payments :: ${jsonEncode(openPayments.first.toJson())}",
            );
          }
          _loading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _loading = false;
        });
      }
    } else {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => await fetchData(),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading && openPayments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (openPayments.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: const Center(child: Text('No payments yet')),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView.separated(
        primary: true,
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: openPayments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final p = openPayments[index];
          return InkWell(
            onTap: () {
             Provider.of<TopNavProvider>(
                          context,
                          listen: false,
                        ).navigateTo(TopNavScreen.openPaymentDetails,argument: p);
            },
            child: PaymentCard(
              personName:
                  "${p.coveredRecipientFirstName} ${p.coveredRecipientMiddleName} ${p.coveredRecipientLastName}",
              company: "${p.submittingApplicableManufacturerOrApplicableGpoName}",
              category: "${p.natureOfPaymentOrTransferOfValue}",
              date: "${p.dateOfPayment}",
              amount: "${p.totalAmountOfPaymentUsDollars}",
              currencySymbol: r'$', // set to '₹' if needed
            ),
          );
        },
      ),
    );
  }
}
