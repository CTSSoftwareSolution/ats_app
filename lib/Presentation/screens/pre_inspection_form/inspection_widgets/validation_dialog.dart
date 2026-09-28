
import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';

class ValidationDialog {
  static void show({
    required BuildContext context,
    required List<String> questions,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        actionsPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: failLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.photo_camera_outlined, color: fail, size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Evidence Required!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Following questions marked as "No" require evidence photos:',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "SemiBold",
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questions.map((q) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(Icons.error_outline_rounded, size: 16, color: fail),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q,
                              style: const TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please add photos for all failed inspections before submitting.',
              style: TextStyle(
                fontSize: 12.5,
                color: fail,
                fontFamily: "SemiBold",
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }
}
