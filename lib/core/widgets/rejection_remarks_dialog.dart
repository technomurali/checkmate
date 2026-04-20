import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/constants/app_text_themes.dart';
import 'package:flutter/material.dart';

Future<String?> showRejectionRemarksDialog(
  BuildContext context, {
  String title = 'Confirm Rejection',
  String message = AppStrings.rejectMessage,
}) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              height: 220,
              child: Column(
                children: [
                  Text(message),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      label: AppTextThemes.labelWithImportant(AppStrings.remarks),
                    ),
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: controller.text.trim().isNotEmpty
                    ? () => Navigator.of(dialogContext).pop(
                        controller.text.trim(),
                      )
                    : null,
                child: const Text('Reject'),
              ),
            ],
          );
        },
      );
    },
  );
  controller.dispose();
  return result;
}
