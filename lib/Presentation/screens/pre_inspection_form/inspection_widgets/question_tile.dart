
import 'dart:io';

import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (picked != null) {
        provider.setQuestionImage(
          sectionIndex: sectionIndex,
          categoryIndex: categoryIndex,
          questionIndex: questionIndex,
          image: File(picked.path),
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

  void _showImageSourceSheet(
      BuildContext context, InspectionFormProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Evidence Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Upload a photo to document this issue',
                style:
                TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ImageSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: const Color(0xFF1A3C6E),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, provider, ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ImageSourceOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: const Color(0xFF0D7377),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, provider, ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

              // ── Yes / No Buttons ──
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

              // ── Image Picker (shown only when No selected) ──
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
                    onReplace: () => _showImageSourceSheet(context, provider),
                  )
                      : ImagePickerPrompt(
                    onTap: () =>
                        _showImageSourceSheet(context, provider),
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