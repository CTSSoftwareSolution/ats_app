
import 'dart:io';

import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../Core/network/services.dart';
import '../../../../aws_images/aws_signedurl_provider.dart';
import '../../../provider/inspection_form_provider.dart';
import 'image_picker_prompt.dart';
import 'image_preview.dart';
import 'image_source_option.dart';

class QuestionTile extends StatelessWidget {
  final int sectionIndex;
  final int categoryIndex;
  final int questionIndex;
  final Color accentColor;
  final bool isLast;

  const QuestionTile({super.key,
    required this.sectionIndex,
    required this.categoryIndex,
    required this.questionIndex,
    required this.accentColor,
    required this.isLast,
  });

  Future<void> _pickImage(BuildContext context, InspectionFormProvider provider,
      ImageSource source) async {
    final awsProvider =
    Provider.of<AwsSignedUrlProvider>(context, listen: false);

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (picked != null) {
        final file = File(picked.path);

        final imagePath = file.path.split(Platform.pathSeparator).last;

        await awsProvider.awsUploadedFile(imagePath, file, context,);

        final fileImagePath = awsImagePathUrl + awsProvider.stringRandomNumber + imagePath;

        provider.setQuestionImage(
          sectionIndex: sectionIndex,
          categoryIndex: categoryIndex,
          questionIndex: questionIndex,
          image: file,
            uploadedUrl: fileImagePath
        );

      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final question = provider
            .sections[sectionIndex]
            .categories[categoryIndex]
            .questions[questionIndex];

        final isNo = question.answer == AnswerState.Fail;
        final hasImage = question.imagePath != null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isNo ? Colors.red.shade50 : Colors.transparent,
            border: isLast
                ? null
                : Border(
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Question label + text ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1, right: 10),
                    width: 26,
                    height: 22,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'Q${questionIndex + 1}',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.carData.questionText ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AnswerButton(
                    label: '✓  Yes',
                    selected: question.answer == AnswerState.Pass,
                    selectedColor: Colors.green,
                    onTap: () => provider.answerQuestion(
                      sectionIndex: sectionIndex,
                      categoryIndex: categoryIndex,
                      questionIndex: questionIndex,
                      answer: AnswerState.Pass,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnswerButton(
                    label: '✗  No',
                    selected: isNo,
                    selectedColor: Colors.red,
                    onTap: () => provider.answerQuestion(
                      sectionIndex: sectionIndex,
                      categoryIndex: categoryIndex,
                      questionIndex: questionIndex,
                      answer: AnswerState.Fail,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isNo
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: hasImage
                      ? ImagePreview(
                    imageFile: question.imagePath!,
                    onRemove: () => provider.removeQuestionImage(
                      sectionIndex: sectionIndex,
                      categoryIndex: categoryIndex,
                      questionIndex: questionIndex,
                    ),
                    onReplace: () =>_pickImage(context, provider, ImageSource.camera),
                  )
                      : ImagePickerPrompt(
                    onTap: () =>
                        _pickImage(context, provider, ImageSource.camera),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}