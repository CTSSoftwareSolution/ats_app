
// ─────────────────────────────────────────────
//  FILE: lib/widgets/confirmation_dialog.dart
// ─────────────────────────────────────────────

import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/inspection_form_provider.dart';
import '../../../provider/pre_inspection_result_provider.dart';

class ConfirmationDialog {
  static void show({
    required BuildContext context,
    required InspectionFormProvider provider,
    required bool isComplete,
    required int unanswered,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.warning_amber_rounded,
              color: isComplete ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(isComplete ? 'Submit Inspection?' : 'Incomplete!'),
          ],
        ),
        content: Text(
          isComplete
              ? 'All ${provider.grandTotalQuestions} questions answered. Ready to submit?'
              : '$unanswered question(s) still unanswered. Submit anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: unanswered==0? Text("Cancel"):Text("Got it"),
          ),
          unanswered==0?
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isComplete ? Colors.green : const Color(0xFF1A3C6E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final typeProvider = Provider.of<PreInspectionResultProvider>(context,listen: false);
              Navigator.pop(context);
              if (isComplete) {
                await typeProvider.saveResultApi(context);
              }
              // _submitInspection(context, provider);
            },
            child: const Text('Submit'),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }

  static void _submitInspection(BuildContext context, InspectionFormProvider provider) {
    final answers = provider.collectAnswers();
    debugPrint('Submitting: $answers');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Inspection submitted successfully!'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}