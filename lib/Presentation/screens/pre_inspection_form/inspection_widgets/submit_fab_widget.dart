import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/confirmation_dialog.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/validation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/inspection_form_provider.dart';


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


    return FloatingActionButton.extended(
      onPressed: () => _handleSubmit(context),
      backgroundColor:
      provider.isFullyComplete ? Colors.green : const Color(0xFF1A3C6E),
      elevation: 6,
      icon: Icon(
        provider.isFullyComplete ? Icons.check_circle : Icons.send_rounded,
        color: Colors.white,
      ),
      label: (questionsWithNoButNoImage.isNotEmpty && !detailsProvider.isAIMode) ?
      Text(
        provider.isFullyComplete
            ? 'Report is not ready'
            : '${provider.visibleAnsweredQuestions}/${provider.visibleTotalQuestions} Answered',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ):
      Text(
        provider.isFullyComplete
            ? 'Submit Report'
            : '${provider.visibleAnsweredQuestions}/${provider.visibleTotalQuestions} Answered',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
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
