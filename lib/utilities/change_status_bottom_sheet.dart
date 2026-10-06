import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Presentation/provider/ai_inspection_details_provider.dart';
import '../Presentation/provider/ai_update_result_provider.dart';
import '../widgets/new_app_ui/app_bottom_sheet.dart';
import '../widgets/new_app_ui/primary_button.dart';
import '../widgets/new_app_ui/secondary_button.dart';
import '../widgets/new_app_ui/section_header.dart';
import '../widgets/new_app_ui/status_badge.dart';
import 'color_data.dart';
import 'new_app_theme/app_radius.dart';
import 'new_app_theme/app_spacing.dart';
import 'new_app_theme/app_text.dart';

// ── Bottom Sheet ─────────────────────────────────────────────
class ChangeStatusSheet extends StatefulWidget {
  final bool isPass;
  final void Function(bool) onSubmit;
  const ChangeStatusSheet({
    super.key,
    required this.isPass,
    required this.onSubmit,
  });

  @override
  State<ChangeStatusSheet> createState() => _ChangeStatusSheetState();
}

class _ChangeStatusSheetState extends State<ChangeStatusSheet> {
  @override
  void initState() {
    super.initState();
    final updateResultProvider = Provider.of<AiUpdateResultProvider>(
      context,
      listen: false,
    );
    final detailsProvider = Provider.of<AiInspectionDetailsProvider>(
      context,
      listen: false,
    );
    debugPrint("Status : ${widget.isPass}");
    debugPrint("selectedQuestionId : ${detailsProvider.selectedQueId}");
    updateResultProvider.toPass = false;
    updateResultProvider.ctrl.addListener(
      () => setState(
        () =>
            updateResultProvider.chars = updateResultProvider.ctrl.text.length,
      ),
    );
  }

  // @override
  // void dispose() {
  //   final updateResultProvider = Provider.of<AiUpdateResultProvider>(context,listen: false);
  //   updateResultProvider.ctrl.dispose(); super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final updateResultProvider = context.watch<AiUpdateResultProvider>();
    final detailsProvider = context.watch<AiInspectionDetailsProvider>();
    final status = widget.isPass ? "Fail" : "Pass";
    final isLoading = updateResultProvider.isLoading;
    return AppBottomSheet(
      title: 'Change Status',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status cards
          Row(
            children: [
              Expanded(
                child: _StatusCard(label: 'System status', pass: widget.isPass),
              ),
              const SizedBox(width: AppSpacing.md),
              // Previews the status that will be saved with the toggle as set.
              Expanded(
                child: _StatusCard(
                  label: 'After change',
                  pass: updateResultProvider.toPass
                      ? !widget.isPass
                      : widget.isPass,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Toggle row
          const SectionHeader('CHANGE TO'),
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: updateResultProvider.toPass ? appColor : border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Change to $status', style: AppText.title),
                ),
                Switch(
                  value: updateResultProvider.toPass,
                  activeTrackColor: appColor,
                  onChanged: (v) {
                    updateResultProvider.toPass = v;
                    // final bool changedStatus =
                    // v ? !widget.isPass : widget.isPass;

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     duration: const Duration(seconds: 1),
                    //     content: Text(
                    //       'Selected: ${changedStatus ? "Pass" : "Fail"}',
                    //       style: const TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //     backgroundColor: changedStatus
                    //         ? const Color(0xFF27AE60)
                    //         : const Color(0xFFE74C3C),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Reason field
          const SectionHeader('REASON'),
          TextField(
            controller: updateResultProvider.ctrl,
            minLines: 3,
            maxLines: 3,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            buildCounter:
                (_, {required currentLength, required isFocused, maxLength}) =>
                    const SizedBox.shrink(),
            style: AppText.body,
            decoration: const InputDecoration(
              hintText: 'Reason for this change…',
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${updateResultProvider.chars} / 200',
              style: AppText.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Cancel',
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Submit',
                  loading: isLoading,
                  onPressed: () async {
                    final bool finalStatus = updateResultProvider.toPass
                        ? !widget.isPass
                        : widget.isPass;
                    updateResultProvider.aiUpdateResult(context, finalStatus);

                    // updateResultProvider.ctrl.clear();
                    // updateResultProvider.toPass = false;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Status Card ───────────────────────────────────────────────
class _StatusCard extends StatelessWidget {
  final String label;
  final bool pass;
  const _StatusCard({required this.label, required this.pass});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: surface2,
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppText.overline),
        const SizedBox(height: AppSpacing.sm),
        pass ? const StatusBadge.pass() : const StatusBadge.fail(),
      ],
    ),
  );
}
