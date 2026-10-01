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
import '../../../../utilities/change_status_bottom_sheet.dart';
import '../../../../utilities/app_theme.dart';
import '../../../provider/ai_inspection_details_provider.dart';
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
    //await fileProvider.initCamera();
    fileProvider.clearOverlayImage();

    fileProvider.setVideo(false);
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
    final aiDetailsProvider = context.watch<AiInspectionDetailsProvider>();
    final isReadOnly = context.watch<AiInspectionDetailsProvider>().isAIModeOn;
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
        var isYes = question.answer == AnswerState.Pass;
        final items = question.carData.items ?? const [];

        return Container(
          key: _tileKey,
          decoration: BoxDecoration(
            color: surface,
            border: widget.isLast
                ? null
                : const Border(
              bottom: BorderSide(color: border),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Question text ──
              ...List.generate(items.length, (index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == items.length - 1 ? 0 : AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (items.length > 1) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: borderDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: Text(
                          item.itemText ?? '',
                          style: AppText.title.copyWith(fontSize: 14.5),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // ── Answer selector ──
              Row(
                children: [
                  Expanded(
                    child: AnswerButton(
                      label: 'Yes',
                      icon: Icons.check_rounded,
                      selected: isYes,
                      selectedColor: isReadOnly ? na : pass,
                      selectedBackground: isReadOnly ? naLight : passLight,
                      onTap: isReadOnly ? null :
                          () {
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
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AnswerButton(
                      label: 'No',
                      icon: Icons.close_rounded,
                      selected: isNo,
                      selectedColor: isReadOnly ? na : fail,
                      selectedBackground: isReadOnly ? naLight : failLight,
                      onTap: isReadOnly ? null :
                          () {
                        provider.answerQuestion(
                          sectionIndex: origSec,
                          categoryIndex: origCat,
                          questionIndex: origQue,
                          answer: AnswerState.Fail,
                        );
                        // No auto-scroll on Fail — user must fill remark/image
                      },
                    ),
                  ),
                ],
              ),

              if (aiDetailsProvider.isAIModeOn) ...[
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () {
                    aiDetailsProvider.setSelectedQueId(int.parse(question.carData.questionId.toString()));
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ChangeStatusSheet(
                        isPass: isYes,
                        onSubmit: (v) => setState(() => isYes = v),
                      ),
                    );
                  },
                  icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                  label: const Text("Change Status"),
                ),
              ],

              // ── Evidence + remark (Fail only, manual mode) ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState:
               // isNo || isYes ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                (!aiDetailsProvider.isAIModeOn && isNo) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('EVIDENCE', style: AppText.overline),
                      const SizedBox(height: AppSpacing.sm),
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
                            boxColor: isNo ? failLight : passLight,
                            borderColor: isNo
                                ? fail.withValues(alpha: 0.35)
                                : pass.withValues(alpha: 0.35),
                            iconColor: isNo ? fail : pass,
                            titleColor: isNo ? fail : pass,
                            subtitleColor: textSecondary,
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
                      const SizedBox(height: AppSpacing.md),
                      const Text('REMARK', style: AppText.overline),
                      const SizedBox(height: AppSpacing.sm),
                      CustomTextField(
                        cursorColor: appColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        fillColor: surface,
                        hint: "Add a remark",
                        controller: controller,
                        minLines: 1,
                        maxLines: 4,
                        onChanged: (value) {
                          provider.setQuestionRemark(
                            sectionIndex: origSec,
                            categoryIndex: origCat,
                            questionIndex: origQue,
                            remark: value,
                          );
                        },
                        hintStyle: const TextStyle(
                          color: textMuted,
                          fontSize: 14,
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