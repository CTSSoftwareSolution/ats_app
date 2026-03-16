import 'dart:io';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/answer_button.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Core/network/services.dart';
import '../../../../aws_images/aws_signedurl_provider.dart';
import '../../../../image_processing/MediaPicker/file_provider.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../camera_page/camera_screen.dart';
import 'image_picker_prompt.dart';
import 'image_preview.dart';


class QuestionTile extends StatefulWidget {
  final int sectionIndex;
  final int categoryIndex;
  final int questionIndex;
  final Color accentColor;
  final bool isLast;

  const QuestionTile({
    super.key,
    required this.sectionIndex,
    required this.categoryIndex,
    required this.questionIndex,
    required this.accentColor,
    required this.isLast,
  });

  @override
  State<QuestionTile> createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {

  // Each tile registers this key in the provider so other tiles can scroll to it
  final GlobalKey _tileKey = GlobalKey();
  TextEditingController controller = TextEditingController();

  // ── Auto-scroll ───────────────────────────────
  // Called after answering Yes. Finds the next unanswered question via the
  // provider's key registry and smoothly scrolls to it.
  void _scrollToNext(
      InspectionFormProvider provider,
      int origSec,
      int origCat,
      int origQue,
      ) {
    // Small delay so notifyListeners() rebuild completes before we scroll
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      final key = provider.nextUnansweredKey(origSec, origCat, origQue);
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.15, // bring question near the top with a little padding
        );
      }
    });
  }

  // ── Image Picker ──────────────────────────────
  Future<void> _pickImage(
      BuildContext context,
      InspectionFormProvider provider,
      ImageSource source,
      int origSec,
      int origCat,
      int origQue,
      ) async {
    final awsProvider = Provider.of<AwsSignedUrlProvider>(context, listen: false);
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    await context.push(CameraScreen());
    try {
      if (fileProvider.overlayImage != null) {
        final file = File(fileProvider.overlayImage!.path);
        final imagePath = file.path.split(Platform.pathSeparator).last;
        await awsProvider.awsUploadedFile(imagePath, file, context);
        final fileImagePath = awsImagePathUrl + awsProvider.stringRandomNumber + imagePath;
        provider.setQuestionImage(
          sectionIndex: origSec,
          categoryIndex: origCat,
          questionIndex: origQue,
          image: file,
          uploadedUrl: fileImagePath,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      context.showErrorSnackBar('Could not pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final origSec = provider.originalSectionIndex(widget.sectionIndex);
        final origCat = provider.originalCategoryIndex(widget.sectionIndex, widget.categoryIndex);
        final origQue = provider.originalQuestionIndex(widget.sectionIndex, widget.categoryIndex, widget.questionIndex);
        final question = provider
            .sections[origSec]
            .categories[origCat]
            .questions[origQue];

        // Register this tile's key so the provider can find it for scrolling
        provider.registerQuestionKey(origSec, origCat, origQue, _tileKey);

        final isNo = question.answer == AnswerState.Fail;
        final isYes = question.answer == AnswerState.Pass;

        return AnimatedContainer(
          key: _tileKey,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isNo ? Colors.red.shade50 : isYes ? Colors.green.shade50 : Colors.transparent,
            border: widget.isLast
                ? null
                : Border(
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1, right: 10),
                    width: 26,
                    height: 22,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'Q${widget.questionIndex + 1}',
                        style: TextStyle(
                          color: widget.accentColor,
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
                    selected: isYes,
                    selectedColor: Colors.green,
                    onTap: () {
                      provider.answerQuestion(
                        sectionIndex: origSec,
                        categoryIndex: origCat,
                        questionIndex: origQue,
                        answer: AnswerState.Pass,
                      );
                      // Auto-scroll to next unanswered question
                      _scrollToNext(provider, origSec, origCat, origQue);
                    },
                  ),
                  const SizedBox(width: 8),
                  AnswerButton(
                    label: '✗  No',
                    selected: isNo,
                    selectedColor: Colors.red,
                    onTap: () {
                      provider.answerQuestion(
                        sectionIndex: origSec,
                        categoryIndex: origCat,
                        questionIndex: origQue,
                        answer: AnswerState.Fail,
                      );
                      // No auto-scroll on Fail — user must fill remark/image
                    },
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState:
                isNo || isYes ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                          () {
                        final hasLocalImage = question.imagePath != null;
                        final hasExistingUrl = question.existingEvidenceUrl != null &&
                            question.existingEvidenceUrl!.isNotEmpty;
                        if (hasLocalImage) {
                          return ImagePreview(
                            imageFile: question.imagePath,
                            onRemove: () => provider.removeQuestionImage(
                              sectionIndex: origSec,
                              categoryIndex: origCat,
                              questionIndex: origQue,
                            ),
                            onReplace: () => _pickImage(
                              context,
                              provider,
                              ImageSource.camera,
                              origSec,
                              origCat,
                              origQue,
                            ),
                          );
                        } else if (hasExistingUrl) {
                          return ImagePreview(
                            imageUrl: question.existingEvidenceUrl,
                            onRemove: () => provider.removeQuestionImage(
                              sectionIndex: origSec,
                              categoryIndex: origCat,
                              questionIndex: origQue,
                            ),
                            onReplace: () => _pickImage(
                              context,
                              provider,
                              ImageSource.camera,
                              origSec,
                              origCat,
                              origQue,
                            ),
                          );
                        } else {
                          return ImagePickerPrompt(
                            boxColor: isNo ?Colors.red.shade50 : Colors.green.shade50,
                            borderColor: isNo ? Colors.red.shade200 : Colors.green.shade200,
                            iconColor: isNo ? Colors.red.shade400 : Colors.green.shade400,
                            titleColor: isNo ? Colors.red.shade500 : Colors.green.shade500,
                            subtitleColor: isNo ?Colors.red.shade300 : Colors.green.shade300,
                            onTap: () => _pickImage(
                              context,
                              provider,
                              ImageSource.camera,
                              origSec,
                              origCat,
                              origQue,
                            ),
                          );
                        }
                      }(),
                      const SizedBox(height: 12),
                      CustomTextField(
                        cursorColor: isNo ? redColor : Colors.green,
                        contentPadding: const EdgeInsets.only(left: 10.0),
                        borderColor: isNo ? Colors.red.shade200 : Colors.green.shade200,
                        borderWidth: 1.5,
                        fillColor: isNo ? Colors.red.shade50 : Colors.green.shade50,
                        hint: "Remark here...",
                        controller: controller,
                        onChanged: (value) {
                          provider.setQuestionRemark(
                            sectionIndex: origSec,
                            categoryIndex: origCat,
                            questionIndex: origQue,
                            remark: value,
                          );
                        },
                        hintStyle: TextStyle(
                          color: isNo ? Colors.red.shade300 : Colors.green.shade300,
                          fontSize: 11,
                        ),
                        readOnly: false,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
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