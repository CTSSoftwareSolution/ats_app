import 'dart:io';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/answer_button.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/utilities/new_app_theme/app_motion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../Core/network/services.dart';
import '../../../../aws_images/aws_signedurl_provider.dart';
import '../../../../image_processing/MediaPicker/file_provider.dart';
import '../../../../utilities/change_status_bottom_sheet.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../provider/ai_inspection_details_provider.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../camera_page/camera_screen.dart';
import 'image_picker_prompt.dart';
import 'image_preview.dart';
import '../../../../widgets/new_app_ui/section_header.dart';
import '../../../../widgets/new_app_ui/app_bottom_sheet.dart';
import '../../../../widgets/new_app_ui/status_badge.dart';
import 'inspection_view_rules.dart';

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

  /// Whether [controller] has been filled from the question's saved remark.
  /// Done once, so a remark typed earlier (or loaded for a retest) shows up
  /// again after this tile is rebuilt, without overwriting later edits.
  bool _remarkSeeded = false;

  /// True while the evidence photo taken for this question is uploading
  /// (display only: shown on the evidence prompt).
  bool _uploadingEvidence = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
    final awsProvider = Provider.of<AwsSignedUrlProvider>(
      context,
      listen: false,
    );
    final fileProvider = Provider.of<FileProvider>(context, listen: false);
    //await fileProvider.initCamera();
    fileProvider.clearOverlayImage();

    fileProvider.setVideo(false);
    await context.push(CameraScreen());
    try {
      if (fileProvider.overlayImage != null) {
        final file = File(fileProvider.overlayImage!.path);
        final imagePath = file.path.split(Platform.pathSeparator).last;
        if (mounted) setState(() => _uploadingEvidence = true);
        try {
          await awsProvider.awsUploadedFile(imagePath, file, context);
        } finally {
          if (mounted) setState(() => _uploadingEvidence = false);
        }
        final fileImagePath =
            awsImagePathUrl + awsProvider.stringRandomNumber + imagePath;
        provider.setQuestionImage(
          sectionIndex: origSec,
          categoryIndex: origCat,
          questionIndex: origQue,
          image: file,
          uploadedUrl: fileImagePath,
        );
      }
    } catch (e) {
      debugPrint('[EVIDENCE] Could not attach photo: $e');
      if (!context.mounted) return;
      CustomLoader.showCustomErrorSnackBar(
        "Couldn't attach the photo. Check your connection and try again.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiDetailsProvider = context.watch<AiInspectionDetailsProvider>();
    final isReadOnly = context.watch<AiInspectionDetailsProvider>().isAIModeOn;
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final origSec = provider.originalSectionIndex(widget.sectionIndex);
        final origCat = provider.originalCategoryIndex(
          widget.sectionIndex,
          widget.categoryIndex,
        );
        final origQue = provider.originalQuestionIndex(
          widget.sectionIndex,
          widget.categoryIndex,
          widget.questionIndex,
        );
        final question =
            provider.sections[origSec].categories[origCat].questions[origQue];

        // Register this tile's key so the provider can find it for scrolling
        provider.registerQuestionKey(origSec, origCat, origQue, _tileKey);

        if (!_remarkSeeded) {
          _remarkSeeded = true;
          final savedRemark = question.remark ?? '';
          if (savedRemark.isNotEmpty) controller.text = savedRemark;
        }

        final isNo = question.answer == AnswerState.Fail;
        var isYes = question.answer == AnswerState.Pass;
        final items = question.carData.items ?? const [];

        // Left rail: green once passed, red once failed, none while open.
        final Color? railColor = isReadOnly
            ? null
            : isYes
            ? pass
            : isNo
            ? fail
            : null;

        return Container(
          key: _tileKey,
          decoration: BoxDecoration(
            // A faint red wash makes failed questions easy to spot when
            // scrolling back through a long category.
            color: isNo && !isReadOnly ? fail.withValues(alpha: 0.03) : surface,
            border: Border(
              left: BorderSide(
                color: railColor ?? Colors.transparent,
                width: 3,
              ),
              bottom: widget.isLast
                  ? BorderSide.none
                  : const BorderSide(color: border),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg - 3,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Number / result + question text ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuestionMarker(
                    number: widget.questionIndex + 1,
                    answer: isReadOnly
                        ? AnswerState.unanswered
                        : question.answer,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      // Optically centre the first line on the 28dp marker.
                      padding: const EdgeInsets.only(top: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0; index < items.length; index++)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: index == items.length - 1
                                    ? 0
                                    : AppSpacing.sm,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (items.length > 1) ...[
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: AppSpacing.sm,
                                      ),
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
                                      items[index].itemText ?? '',
                                      style: AppText.title,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Answer selector ──
              Row(
                children: [
                  Expanded(
                    child: AnswerButton(
                      label: 'Yes',
                      hint: 'Pass',
                      icon: Icons.check_rounded,
                      selected: isYes,
                      selectedColor: isReadOnly ? na : pass,
                      selectedBackground: isReadOnly ? naLight : passLight,
                      onTap: isReadOnly
                          ? null
                          : () {
                              provider.answerQuestion(
                                sectionIndex: origSec,
                                categoryIndex: origCat,
                                questionIndex: origQue,
                                answer: AnswerState.Pass,
                              );
                              // Auto-scroll to next unanswered question
                              _scrollToNext(
                                provider,
                                origSec,
                                origCat,
                                origQue,
                              );
                            },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AnswerButton(
                      label: 'No',
                      hint: 'Fail',
                      icon: Icons.close_rounded,
                      selected: isNo,
                      selectedColor: isReadOnly ? na : fail,
                      selectedBackground: isReadOnly ? naLight : failLight,
                      onTap: isReadOnly
                          ? null
                          : () {
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
                    aiDetailsProvider.setSelectedQueId(
                      int.parse(question.carData.questionId.toString()),
                    );
                    showAppBottomSheet(
                      context: context,
                      builder: (_) => ChangeStatusSheet(
                        isPass: isYes,
                        onSubmit: (v) => setState(() => isYes = v),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.swap_horiz_rounded,
                    size: AppIconSize.md,
                  ),
                  label: const Text("Change Status"),
                ),
              ],

              // ── Evidence + remark (Fail only, manual mode) ──
              AnimatedCrossFade(
                duration: AppMotion.standard,
                crossFadeState:
                    // isNo || isYes ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    (!aiDetailsProvider.isAIModeOn && isNo)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  // Everything a failed check needs, grouped in one panel.
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: fail.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Wraps so the severity badge drops below the title
                      // on narrow phones with large text.
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.report_problem_outlined,
                                size: AppIconSize.sm,
                                color: fail,
                              ),
                              const SizedBox(width: AppSpacing.iconGap),
                              Flexible(
                                child: Text(
                                  'Defect details',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.label.copyWith(color: fail),
                                ),
                              ),
                            ],
                          ),
                          if (severityLabel(question.answer) != null)
                            StatusBadge(
                              label: severityLabel(question.answer)!,
                              color: fail,
                              background: failLight,
                              icon: Icons.priority_high_rounded,
                              dense: true,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SectionHeader(
                        'Evidence photo',
                        trailing: Text(
                          'REQUIRED',
                          style: AppText.overline.copyWith(color: fail),
                        ),
                      ),
                      () {
                        final hasLocalImage = question.imagePath != null;
                        final hasExistingUrl =
                            question.existingEvidenceUrl != null &&
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
                            uploading: _uploadingEvidence,
                            boxColor: failLight,
                            borderColor: fail.withValues(alpha: 0.35),
                            iconColor: fail,
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
                      const SectionHeader(
                        'Remark',
                        trailing: Text('OPTIONAL', style: AppText.overline),
                      ),
                      CustomTextField(
                        cursorColor: appColor,
                        contentPadding: const EdgeInsets.all(
                          AppSpacing.inputPadding,
                        ),
                        fillColor: surface,
                        hint: "Describe the defect (optional)",
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
                        hintStyle: AppText.hint,
                        readOnly: false,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
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

/// Question number that becomes the result once answered: a neutral "3",
/// a green tick for Yes (pass) or a red cross for No (fail).
class _QuestionMarker extends StatelessWidget {
  final int number;
  final AnswerState answer;

  const _QuestionMarker({required this.number, required this.answer});

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Widget child, String label) = switch (answer) {
      AnswerState.Pass => (
        pass,
        const Icon(Icons.check_rounded, size: AppIconSize.sm, color: textWhite),
        'Question $number, passed',
      ),
      AnswerState.Fail => (
        fail,
        const Icon(Icons.close_rounded, size: AppIconSize.sm, color: textWhite),
        'Question $number, failed',
      ),
      AnswerState.unanswered => (
        surface2,
        Text(
          '$number',
          style: AppText.badge.copyWith(
            color: textSecondary,
            fontFeatures: AppText.tabular,
          ),
        ),
        'Question $number, not answered',
      ),
    };
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: FittedBox(fit: BoxFit.scaleDown, child: child),
      ),
    );
  }
}
