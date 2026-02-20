import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen.dart';
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
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Row(
                children: [
                  Icon(
                    isComplete ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: isComplete ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Text(isComplete ? 'Submit Inspection?' : 'Incomplete!',style: TextStyle(fontSize: 20,fontFamily: "Medium"),),
                ],
              ),
                const SizedBox(height: 15),
          Text(
              isComplete
                  ? 'All ${provider.grandTotalQuestions} questions answered. Ready to submit?'
                  : '$unanswered question(s) still unanswered.',
            style: TextStyle(fontSize: 16,fontFamily: "Regular"),
            ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: unanswered==0? Text("Cancel",style: TextStyle(fontSize: 14,fontFamily: "Bold"),):Text("Got it",style: TextStyle(fontSize: 16,fontFamily: "Bold"),),
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
                )
              ],
            ),
          ),
        ),
        // title: Row(
        //   children: [
        //     Icon(
        //       isComplete ? Icons.check_circle : Icons.warning_amber_rounded,
        //       color: isComplete ? Colors.green : Colors.orange,
        //     ),
        //     const SizedBox(width: 10),
        //     Text(isComplete ? 'Submit Inspection?' : 'Incomplete!'),
        //   ],
        // ),
        // content: Text(
        //   isComplete
        //       ? 'All ${provider.grandTotalQuestions} questions answered. Ready to submit?'
        //       : '$unanswered question(s) still unanswered.',
        // ),
        // actions: [
        //   TextButton(
        //     onPressed: () => Navigator.pop(context),
        //     child: unanswered==0? Text("Cancel"):Text("Got it"),
        //   ),
        //   unanswered==0?
        //   ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: isComplete ? Colors.green : const Color(0xFF1A3C6E),
        //       foregroundColor: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //     onPressed: () async {
        //       final typeProvider = Provider.of<PreInspectionResultProvider>(context,listen: false);
        //       Navigator.pop(context);
        //       if (isComplete) {
        //         await typeProvider.saveResultApi(context);
        //       }
        //       // _submitInspection(context, provider);
        //     },
        //     child: const Text('Submit'),
        //   ):SizedBox.shrink(),
        // ],
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