import 'package:checkmate/features/auth/model/event_modal.dart';
import 'package:flutter/material.dart';

class ApprovalDialog extends StatelessWidget {
  final bool success;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final String? secondaryLabel;
  final EventModal event;
  final ContactDto contactDto;
  const ApprovalDialog({
    super.key,
    required this.success,
    this.secondaryLabel,
    required this.onPrimary,
    this.onSecondary,
    required this.event,
    required this.contactDto,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBg = success
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final Color iconFg = success
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);

    final String title = success
        ? 'Submission Successful'
        : 'Submission Failed';

    // 7-word corporate acknowledgment (success case)
    final String message = success
        ? 'Notified ${contactDto.firstName} ${contactDto.lastName} regarding the ${event.eventName} Event Approval'
        : 'Unable to submit currently. Please try again later.'; // formal fallback

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24,
                  color: Colors.black26,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    success
                        ? Icons.verified_rounded
                        : Icons.error_outline_rounded,
                    color: iconFg,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (onSecondary != null)
                      TextButton(
                        onPressed: onSecondary,
                        child: const Text('View Status'),
                      ),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: onPrimary, child: const Text('OK')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
