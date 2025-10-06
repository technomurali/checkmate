import 'package:checkmate/features/auth/model/openpayments_modal.dart';
import 'package:flutter/material.dart';

class OpenPaymentsDetails extends StatefulWidget {
  final OpenPaymentsModal openPayment;
  const OpenPaymentsDetails({super.key, required this.openPayment});

  @override
  State<OpenPaymentsDetails> createState() => _OpenPaymentsDetailsState();
}

class _OpenPaymentsDetailsState extends State<OpenPaymentsDetails> {
  @override
  void initState() {
    super.initState();
    // Safely convert to a map we can read from.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card (no Scaffold): name + amount + date chips
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          ("${widget.openPayment.coveredRecipientFirstName} ${widget.openPayment.coveredRecipientLastName}")
                              .toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${widget.openPayment.totalAmountOfPaymentUsDollars}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _Chip(
                            label: '${widget.openPayment.dateOfPayment}',
                            icon: Icons.event,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.openPayment.submittingApplicableManufacturerOrApplicableGpoName}",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(
                        label:
                            'Nature: ${widget.openPayment.natureOfPaymentOrTransferOfValue}',
                        icon: Icons.category_outlined,
                      ),
                      _Chip(
                        label:
                            'Form: ${widget.openPayment.formOfPaymentOrTransferOfValue}',
                        icon: Icons.card_giftcard_outlined,
                      ),
                      _Chip(
                        label: 'Program: ${widget.openPayment.programYear}',
                        icon: Icons.schedule_outlined,
                      ),
                      _Chip(
                        label:
                            'Published: ${widget.openPayment.paymentPublicationDate}',
                        icon: Icons.public_outlined,
                      ),
                      _Chip(
                        label:
                            'Dispute: ${widget.openPayment.disputeStatusForPublication}',
                        icon: Icons.gavel_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details (read-only text fields with labels related to JSON keys)
            _ReadonlyField(
              label: 'Recipient NPI',
              value: "${widget.openPayment.coveredRecipientNpi}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Recipient Name',
              value:
                  "${widget.openPayment.coveredRecipientFirstName} ${widget.openPayment.coveredRecipientLastName}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Manufacturer / GPO',
              value:
                  "${widget.openPayment.submittingApplicableManufacturerOrApplicableGpoName}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Payment Amount (USD)',
              value: "${widget.openPayment.totalAmountOfPaymentUsDollars}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Payment Date',
              value: "${widget.openPayment.dateOfPayment}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Payments Included (Count)',
              value:
                  "${widget.openPayment.numberOfPaymentsIncludedInTotalAmount}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Form of Value',
              value: "${widget.openPayment.formOfPaymentOrTransferOfValue}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Nature of Value',
              value: "${widget.openPayment.natureOfPaymentOrTransferOfValue}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Dispute Status',
              value: "${widget.openPayment.disputeStatusForPublication}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Program Year',
              value: "${widget.openPayment.programYear}",
            ),
            const SizedBox(height: 12),
            _ReadonlyField(
              label: 'Publication Date',
              value: "${widget.openPayment.paymentPublicationDate}",
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  const _ReadonlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: value,
      readOnly: true,
      enabled: false,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        label: Text(label),
        // Subtle filled background to feel like a card form field
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.15),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.75),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
