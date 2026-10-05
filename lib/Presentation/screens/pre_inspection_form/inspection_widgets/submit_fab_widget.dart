import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/confirmation_dialog.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/validation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../widgets/app_ui.dart';


class SubmitFAB extends StatelessWidget {
  final InspectionFormProvider provider;

  const SubmitFAB({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final questionsWithNoButNoImage = _validateQuestionsWithNoAnswer();
    final detailsProvider = context.watch<AiInspectionDetailsProvider>();


    final label = (questionsWithNoButNoImage.isNotEmpty && !detailsProvider.isAIMode)
        ? (provider.isFullyComplete
            ? 'Report is not ready'
            : '${provider.visibleAnsweredQuestions}/${provider.visibleTotalQuestions} Answered')
        : (provider.isFullyComplete
            ? 'Submit Report'
            : '${provider.visibleAnsweredQuestions}/${provider.visibleTotalQuestions} Answered');

    // Every question answered but a failed one still lacks evidence.
    final notReady = provider.isFullyComplete &&
        questionsWithNoButNoImage.isNotEmpty &&
        !detailsProvider.isAIMode;

    final total = provider.visibleTotalQuestions;
    final progress =
        total == 0 ? 0.0 : (provider.visibleAnsweredQuestions / total).clamp(0.0, 1.0);

    // Sticky bottom action bar (kept under the original SubmitFAB name).
    return BottomActionBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!provider.isFullyComplete) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: surface2,
                valueColor: const AlwaysStoppedAnimation<Color>(appColor),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          SizedBox(
            height: AppSpacing.buttonHeight,
            child: FilledButton.icon(
              onPressed: () => _handleSubmit(context),
              style: FilledButton.styleFrom(
                backgroundColor: notReady ? warn : (provider.isFullyComplete ? pass : appColor),
              ),
              icon: Icon(
                notReady
                    ? Icons.error_outline_rounded
                    : (provider.isFullyComplete ? Icons.check_circle_rounded : Icons.send_rounded),
                size: 20,
              ),
              label: Text(
                label,
                style: const TextStyle(fontFamily: "Bold", fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final questionsWithNoButNoImage = _validateQuestionsWithNoAnswer();
    final detailsProvider = Provider.of<AiInspectionDetailsProvider>(context,listen: false);

    if(!detailsProvider.isAIMode){
    if (questionsWithNoButNoImage.isNotEmpty) {
      ValidationDialog.show(
        context: context,
        questions: questionsWithNoButNoImage,
      );
      return;
    }
    }
    // Show confirmation dialog if validation passes
    final isComplete = provider.isFullyComplete;
    //final unanswered = provider.grandTotalQuestions - provider.grandTotalAnswered;
    final unanswered = provider.visibleTotalQuestions - provider.visibleAnsweredQuestions;
    ConfirmationDialog.show(
      context: context,
      provider: provider,
      isComplete: isComplete,
      unanswered: unanswered,
    );
  }

  List<String> _validateQuestionsWithNoAnswer() {
    final questionsWithNoButNoImage = <String>[];
    for (var sectionIndex = 0; sectionIndex < provider.sections.length; sectionIndex++) {
      final section = provider.sections[sectionIndex];

      for (var categoryIndex = 0; categoryIndex < section.categories.length; categoryIndex++) {
        final category = section.categories[categoryIndex];

        for (var questionIndex = 0; questionIndex < category.questions.length; questionIndex++) {
          final question = category.questions[questionIndex];

          if (question.answer == AnswerState.Fail) {
            final hasLocalImage = question.imagePath != null;
            final hasUploadedUrl = question.uploadedImageUrl != null && question.uploadedImageUrl!.isNotEmpty;
            final hasExistingUrl = question.existingEvidenceUrl != null && question.existingEvidenceUrl!.isNotEmpty;
            if (!hasLocalImage && !hasUploadedUrl && !hasExistingUrl) {
              questionsWithNoButNoImage.add(
                  '${section.label} → ${category.title} → Q${questionIndex + 1}'
              );
            }
          }
        }
      }
    }
    return questionsWithNoButNoImage;
  }

}
