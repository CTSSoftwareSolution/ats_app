import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
import 'package:ats_app/Presentation/provider/ai_update_result_provider.dart';
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/bottom_navigation_bar.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/utilities/new_app_theme/app_motion.dart';
import 'package:ats_app/Presentation/screens/common/vehicle_subtitle.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/new_app_ui/app_bottom_sheet.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/app_icon_tile.dart';
import '../../../widgets/new_app_ui/app_segmented_bar.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import '../../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../../widgets/new_app_ui/primary_button.dart';
import '../../../widgets/new_app_ui/secondary_button.dart';
import '../../../widgets/new_app_ui/section_header.dart';
import '../../../widgets/new_app_ui/status_badge.dart';

/// Full-screen AI result opened from the "View Result" button of the
/// vehicle test parameter flow.
class AiResultScreen extends StatefulWidget {
  const AiResultScreen({super.key});

  @override
  State<AiResultScreen> createState() => _AiResultScreenState();
}

class _AiResultScreenState extends State<AiResultScreen> {
  /// Result is fetched before this screen is pushed; this only re-fetches
  /// for pull-to-refresh and retry.
  Future<void> _loadResult() async {
    if (!mounted) return;
    final provider = context.read<AiResultProvider>();
    // Skip while a request is already running (no duplicate calls).
    if (provider.isLoading || _isRefreshing) return;
    await provider.aiResultDetails(context);
  }

  /// True while a pull-to-refresh request is in flight. The list stays on
  /// screen under the refresh indicator instead of the full-screen loader.
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    if (!mounted) return;
    final provider = context.read<AiResultProvider>();
    if (provider.isLoading || _isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await provider.aiResultDetails(context);
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool _isNavigating = false;

  /// Questions whose "Result Details" are open (by [_keyOf]).
  final Set<String> _expanded = {};

  /// Questions whose result was changed from this screen (by [_keyOf]);
  /// display only, for the "Changed by you" tag.
  final Set<String> _changed = {};

  /// Clears the inspection flow and returns to the dashboard tab.
  void _goToDashboard() {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    context.read<BottomNavigationProvider>().updateIndex(0);
    context.pushAndRemoveUntil(const BottomNavigationBarScreen());
  }

  String _keyOf(ResultData item) =>
      item.labelId?.toString() ?? item.questionText ?? '${item.id}';

  /// One record per question, in API order. When a label has several
  /// documents, the latest (highest document_id, then highest id) is used.
  List<ResultData> _currentRecords(List<ResultData> data) {
    final Map<String, ResultData> byLabel = {};
    for (final item in data) {
      final key = _keyOf(item);
      final existing = byLabel[key];
      if (existing == null || _isNewer(item, existing)) {
        byLabel[key] = item;
      }
    }
    return byLabel.values.toList();
  }

  bool _isNewer(ResultData a, ResultData b) {
    final docA = a.documentId ?? -1;
    final docB = b.documentId ?? -1;
    if (docA != docB) return docA > docB;
    return (a.id ?? -1) > (b.id ?? -1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiResultProvider>();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppTopBar(
        title: "AI Result",
        subtitle: vehicleSubtitle(context),
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        bottom: false,
        child: provider.isLoading && !_isRefreshing
            ? CustomLoader.loader(message: "Loading result…")
            : RefreshIndicator(
                color: appColor,
                backgroundColor: surface,
                onRefresh: _onRefresh,
                child: _buildBody(provider),
              ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          label: "Done",
          onPressed: _isNavigating ? null : _goToDashboard,
        ),
      ),
    );
  }

  Widget _buildBody(AiResultProvider provider) {
    final entity = provider.aiResultEntity;
    final data = entity?.data ?? [];

    if (entity == null) {
      return _ScrollableState(
        child: AppStateView.error(
          title: "Unable to load result",
          message: "Pull down or tap retry to try again.",
          onAction: _loadResult,
        ),
      );
    }

    if (data.isEmpty) {
      return _ScrollableState(
        child: AppStateView(
          icon: Icons.schedule_rounded,
          color: warn,
          title: "AI result not available",
          message: _hasText(entity.message)
              ? entity.message!.trim()
              : "The AI hasn't returned results for this vehicle yet. Pull down to check again.",
          actionLabel: 'Check again',
          onAction: _loadResult,
        ),
      );
    }

    final records = _currentRecords(data);

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xl,
      ),
      // Summary first, then one card per question.
      itemCount: records.length + 1,
      separatorBuilder: (_, index) =>
          SizedBox(height: index == 0 ? AppSpacing.lg : AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) return _ResultSummary(records: records);
        final item = records[index - 1];
        final key = _keyOf(item);
        // A single question opens with its details visible.
        final expanded = records.length == 1 || _expanded.contains(key);
        return _QuestionCard(
          item: item,
          label: records.length > 1
              ? "Inspection Question $index of ${records.length}"
              : "Inspection Question",
          changedByUser: _changed.contains(key),
          expanded: expanded,
          onToggleDetails: records.length == 1
              ? null
              : () => setState(() {
                  if (!_expanded.remove(key)) _expanded.add(key);
                }),
          // Not while refreshing: the record is about to be replaced.
          onTap: _isRefreshing
              ? null
              : () => _showChangeResultSheet(provider, item),
        );
      },
    );
  }

  /// Opens the result editor for [item] only.
  void _showChangeResultSheet(AiResultProvider provider, ResultData item) {
    showAppBottomSheet(
      context: context,
      builder: (_) => _ChangeResultSheet(
        questionId: item.labelId,
        question: item.questionText,
        current: _availableResult(item),
        currentRemark: item.aiRemark,
        currentBadge: _statusBadge(item, dense: true),
        onUpdated: (result, remark) {
          if (mounted) setState(() => _changed.add(_keyOf(item)));
          provider.updateQuestionResult(item, result, remark: remark);
        },
      ),
    );
  }
}

/// The overall verdict across every question, first thing on the screen:
///
///   [✗]  OVERALL AI RESULT
///        FAIL
///        1 of 3 checks failed
///   ▰▰▰▰▰▰▰▰▰▰▱▱▱▱▱   ● 1 pass  ● 1 fail  ● 1 pending
///
/// FAIL when any question failed, PASS only when every question passed,
/// PENDING while the AI is still working on a question, otherwise
/// AI RESULT NOT AVAILABLE.
class _ResultSummary extends StatelessWidget {
  final List<ResultData> records;

  const _ResultSummary({required this.records});

  @override
  Widget build(BuildContext context) {
    final count = {for (final s in _AiStatus.values) s: 0};
    for (final r in records) {
      final s = _statusOf(r);
      count[s] = count[s]! + 1;
    }
    final total = records.length;
    final passCount = count[_AiStatus.pass]!;
    final failCount = count[_AiStatus.fail]!;
    final pendingCount = count[_AiStatus.pending]!;
    final missingCount =
        count[_AiStatus.notAvailable]! + count[_AiStatus.other]!;

    final (String verdict, String reason, Color color, IconData icon) =
        failCount > 0
        ? (
            'FAIL',
            '$failCount of $total ${total == 1 ? 'check' : 'checks'} failed',
            fail,
            Icons.cancel_rounded,
          )
        : passCount == total
        ? (
            'PASS',
            total == 1 ? 'The check passed' : 'All $total checks passed',
            pass,
            Icons.check_circle_rounded,
          )
        : pendingCount > 0
        ? (
            'PENDING',
            '$pendingCount of $total awaiting the AI · pull down to refresh',
            warn,
            Icons.schedule_rounded,
          )
        : (
            'AI RESULT NOT AVAILABLE',
            '$missingCount of $total ${total == 1 ? 'check has' : 'checks have'} no AI result',
            na,
            Icons.help_outline_rounded,
          );

    final segments = [
      AppSegment(value: passCount, label: 'pass', color: pass),
      AppSegment(value: failCount, label: 'fail', color: fail),
      AppSegment(value: pendingCount, label: 'pending', color: warn),
      AppSegment(
        value: missingCount,
        label: 'not available',
        color: na,
        remaining: true,
      ),
    ];

    return Semantics(
      container: true,
      label: 'Overall AI result: $verdict. $reason',
      child: AppCard(
        borderColor: color == na ? null : color.withValues(alpha: 0.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExcludeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIconTile(icon: icon, color: color),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OVERALL AI RESULT',
                          style: AppText.overline,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          verdict,
                          style: AppText.pageTitle.copyWith(
                            color: color == na ? textPrimary : color,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(reason, style: AppText.bodySecondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Proportional Pass / Fail / Pending / Not available bar.
            AppSegmentedBar(segments: segments),
            const SizedBox(height: AppSpacing.sm),
            AppSegmentLegend(segments: segments),
          ],
        ),
      ),
    );
  }
}

/// One question, in priority order: the question, the AI result, what the
/// AI found (collapsible), then manual modification (remark, "Changed by
/// you" and the Change result action).
class _QuestionCard extends StatelessWidget {
  final ResultData item;
  final String label;
  final bool expanded;

  /// True when the result was changed from this screen in this session.
  final bool changedByUser;

  /// Null when the details can't be collapsed (single question).
  final VoidCallback? onToggleDetails;
  final VoidCallback? onTap;

  const _QuestionCard({
    required this.item,
    required this.label,
    required this.expanded,
    required this.changedByUser,
    required this.onToggleDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = item.questionText;
    final status = _statusOf(item);
    final badge = _statusBadge(item);
    final remark = item.aiRemark;
    final Color? tint = status == _AiStatus.fail
        ? fail.withValues(alpha: 0.45)
        : status == _AiStatus.pass
        ? pass.withValues(alpha: 0.35)
        : null;

    return AppCard(
      padding: EdgeInsets.zero,
      borderColor: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question + AI result. Tapping opens the change sheet for this
          // question only.
          Semantics(
            button: true,
            label:
                '$label. ${_hasText(text) ? text!.trim() : ''}. '
                'AI result: ${badge.label}. Change result',
            excludeSemantics: true,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.card,
                  AppSpacing.card,
                  AppSpacing.card,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _SectionLabel(label)),
                        if (changedByUser) ...[
                          const SizedBox(width: AppSpacing.sm),
                          const StatusBadge(
                            label: 'Changed by you',
                            color: appColor,
                            background: accentLight,
                            icon: Icons.edit_rounded,
                            dense: true,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _hasText(text) ? text!.trim() : '—',
                      style: AppText.title.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_outlined,
                          size: AppIconSize.sm,
                          color: na,
                        ),
                        const SizedBox(width: AppSpacing.iconGap),
                        const Text('AI result', style: AppText.bodySecondary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: badge,
                          ),
                        ),
                      ],
                    ),
                    if (_hasText(remark)) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _InlineNotice(
                        icon: Icons.chat_bubble_outline_rounded,
                        text: 'Remark: ${remark!.trim()}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          // What the AI found (toggle) + content.
          InkWell(
            onTap: onToggleDetails,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSpacing.minTouchTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.card,
                ),
                child: Row(
                  children: [
                    const Expanded(child: _SectionLabel("Result Details")),
                    if (onToggleDetails != null)
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: AppMotion.standard,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: AppMotion.standard,
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                0,
                AppSpacing.card,
                AppSpacing.sm,
              ),
              child: _ResultDetails(item: item),
            ),
          ),
          const Divider(height: 1),
          // Manual modification.
          ExcludeSemantics(
            child: InkWell(
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSpacing.minTouchTarget,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.card,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: AppIconSize.sm,
                        color: onTap == null ? textMuted : appColor,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          "Change result",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.chip.copyWith(
                            color: onTap == null ? textMuted : appColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: AppIconSize.md,
                        color: onTap == null ? textMuted : appColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Overall Result" and "Analysis" rows of one question, laid out inline
/// inside its card.
class _ResultDetails extends StatelessWidget {
  final ResultData item;

  const _ResultDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    final response = item.aiResponse;
    switch (_statusOf(item)) {
      case _AiStatus.pending:
        return const _InlineNotice(
          icon: Icons.schedule_rounded,
          text: "The AI is still analysing this check. Pull down to refresh.",
        );
      case _AiStatus.notAvailable:
        return const _InlineNotice(
          icon: Icons.help_outline_rounded,
          text: "AI result not available",
        );
      case _AiStatus.pass:
      case _AiStatus.fail:
      case _AiStatus.other:
        // The result itself is shown on the card; here only what the AI
        // found.
        return _AnalysisCard(
          analysis: response?.analysis,
          message: response?.message,
        );
    }
  }
}

/// Bottom sheet to change the result of one question to Pass or Fail.
class _ChangeResultSheet extends StatefulWidget {
  final num? questionId;
  final String? question;
  final String? current;
  final String? currentRemark;

  /// Badge for the current result as shown on the card (PASS, FAIL,
  /// PENDING, not available); falls back to [current].
  final StatusBadge? currentBadge;

  /// Called with the new result and remark once the API has accepted them.
  final void Function(String result, String remark) onUpdated;

  const _ChangeResultSheet({
    this.questionId,
    this.question,
    this.current,
    this.currentRemark,
    this.currentBadge,
    required this.onUpdated,
  });

  @override
  State<_ChangeResultSheet> createState() => _ChangeResultSheetState();
}

class _ChangeResultSheetState extends State<_ChangeResultSheet> {
  late String? _selected = widget.current?.trim().toUpperCase();
  late final TextEditingController _remarkController = TextEditingController(
    text: widget.currentRemark?.trim() ?? '',
  );
  bool _isUpdating = false;

  String get _remark => _remarkController.text.trim();

  bool get _canUpdate =>
      !_isUpdating &&
      _selected != null &&
      (_selected != widget.current?.trim().toUpperCase() ||
          _remark != (widget.currentRemark?.trim() ?? ''));

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_canUpdate) return;
    FocusScope.of(context).unfocus();
    final result = _selected!;
    final remark = _remark;
    setState(() => _isUpdating = true);

    final response = await context
        .read<AiUpdateResultProvider>()
        .updateQuestionResult(
          context,
          questionId: widget.questionId,
          statusResult: result == "PASS",
          remark: remark,
        );

    if (response?.success == true) {
      widget.onUpdated(result, remark);
      CustomLoader.success(
        _hasText(response!.message)
            ? response.message!.trim()
            : "Result updated successfully",
      );
      if (mounted) Navigator.pop(context);
      return;
    }

    CustomLoader.errorMessage(
      _hasText(response?.message)
          ? response!.message!.trim()
          : "Unable to update result",
    );
    if (mounted) setState(() => _isUpdating = false);
  }

  /// The primary button says exactly what it will do.
  String get _actionLabel {
    final current = widget.current?.trim().toUpperCase();
    if (_selected == null) return "Select a result";
    if (_selected != current) return "Update to $_selected";
    if (_remark != (widget.currentRemark?.trim() ?? '')) return "Update remark";
    return "No changes to update";
  }

  void _close() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final current = widget.current?.trim().toUpperCase();
    return PopScope(
      canPop: !_isUpdating,
      child: AppBottomSheet(
        title: "Change result",
        showClose: true,
        onClose: _isUpdating ? null : _close,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The one question this sheet edits, with its current result.
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: surface2,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _hasText(widget.question) ? widget.question!.trim() : '—',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Text(
                        "Current result",
                        style: AppText.bodySecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:
                              widget.currentBadge ??
                              _resultBadge(widget.current),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SectionLabel("New result"),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _ResultOption(
                    label: "PASS",
                    icon: Icons.check_circle_rounded,
                    color: pass,
                    selected: _selected == "PASS",
                    isCurrent: current == "PASS",
                    onTap: _isUpdating
                        ? null
                        : () => setState(() => _selected = "PASS"),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ResultOption(
                    label: "FAIL",
                    icon: Icons.cancel_rounded,
                    color: fail,
                    selected: _selected == "FAIL",
                    isCurrent: current == "FAIL",
                    onTap: _isUpdating
                        ? null
                        : () => setState(() => _selected = "FAIL"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(
              'Remark',
              trailing: Text('OPTIONAL', style: AppText.overline),
            ),
            _RemarkField(
              controller: _remarkController,
              enabled: !_isUpdating,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: "Cancel",
                    onPressed: _isUpdating ? null : _close,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _actionLabel,
                    icon: _canUpdate ? Icons.check_rounded : null,
                    onPressed: _canUpdate ? _update : null,
                    loading: _isUpdating,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One choice in the "New result" pair: solid fill when selected, outlined
/// otherwise, with a "Current" note on the result the question has now.
class _ResultOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _ResultOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final fg = selected ? textWhite : color;
    return Semantics(
      button: true,
      selected: selected,
      label: isCurrent ? '$label, current result' : label,
      excludeSemantics: true,
      child: Material(
        color: selected ? color : surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            constraints: const BoxConstraints(
              minHeight: AppSpacing.buttonHeight,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: selected ? color : borderDark),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: AppIconSize.md, color: fg),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.button.copyWith(color: fg),
                      ),
                    ),
                  ],
                ),
                if (isCurrent)
                  Text(
                    'Current',
                    style: AppText.caption.copyWith(
                      color: selected ? textWhite : textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Optional multiline remark sent along with the changed result.
class _RemarkField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _RemarkField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  static const _maxLength = 250;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outline(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      minLines: 3,
      maxLines: 5,
      maxLength: _maxLength,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: appColor,
      style: AppText.body,
      decoration: InputDecoration(
        hintText: "Add a remark (optional)",
        hintStyle: AppText.hint,
        counterStyle: AppText.caption,
        filled: true,
        fillColor: surface,
        isDense: true,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: outline(border),
        enabledBorder: outline(border),
        disabledBorder: outline(border),
        focusedBorder: outline(appColor, 1.5),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final dynamic analysis;
  final String? message;

  const _AnalysisCard({required this.analysis, this.message});

  /// Analysis keys that are kept in the model but not shown to the user:
  /// timings, request/model identifiers, timestamps, storage locations.
  static const _hiddenKeys = {
    'processing_time_sec',
    'processing_time',
    'request_id',
    'id',
    'model',
    'model_name',
    'model_version',
    'version',
    'timestamp',
    'created_at',
    'updated_at',
    'latency',
    'latency_ms',
    'inference_time',
    'debug',
  };

  /// Keys that look technical by name (paths, URLs, *_ms / *_sec timings).
  static bool _isTechnical(String key) {
    final k = key.toLowerCase();
    return _hiddenKeys.contains(k) ||
        k.endsWith('_ms') ||
        k.endsWith('_sec') ||
        k.endsWith('_url') ||
        k.endsWith('_path') ||
        k.endsWith('_id');
  }

  @override
  Widget build(BuildContext context) {
    final analysis = this.analysis is Map
        ? Map.fromEntries(
            (this.analysis as Map).entries.where(
              (e) => !_isTechnical(e.key.toString()),
            ),
          )
        : this.analysis;

    if (_isEmptyValue(analysis)) {
      return _InlineNotice(
        icon: Icons.info_outline_rounded,
        text: _hasText(message)
            ? message!.trim()
            : "No further details from the AI for this check.",
      );
    }

    final rows = <Widget>[];
    if (analysis is Map) {
      analysis.forEach((key, value) {
        rows.add(
          _DetailRow(
            label: _humanize(key.toString()),
            child: _valueBadge(value),
          ),
        );
      });
    } else if (analysis is List) {
      for (var i = 0; i < analysis.length; i++) {
        rows.add(
          _DetailRow(label: 'Item ${i + 1}', child: _valueBadge(analysis[i])),
        );
      }
    } else {
      rows.add(_DetailRow(label: 'Analysis', child: _valueBadge(analysis)));
    }

    return _KeyValueCard(rows: rows);
  }
}

/// Key-value rows separated by hairline dividers, laid out
/// inline (it sits inside the question card).
class _KeyValueCard extends StatelessWidget {
  final List<Widget> rows;

  const _KeyValueCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(height: 1, thickness: 1, color: border),
          rows[i],
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailRow({required this.label, required this.child});

  static const _labelStyle = AppText.bodySecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _labelStyle)),
          const SizedBox(width: AppSpacing.lg),
          Flexible(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: AppText.overline);
  }
}

/// Subtle muted notice shown inside a card (e.g. missing AI data).
class _InlineNotice extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InlineNotice({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: naLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: na),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppText.bodySecondary)),
        ],
      ),
    );
  }
}

/// Keeps pull-to-refresh working for the non-list states.
class _ScrollableState extends StatelessWidget {
  final Widget child;

  const _ScrollableState({required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.page),
      children: [const SizedBox(height: AppSpacing.xxl), child],
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

/// The question's overall result, or null when it is missing or still pending.
String? _availableResult(ResultData item) {
  final overall = item.aiResponse?.overallResult;
  if (!_hasText(overall) || overall!.trim().toLowerCase() == 'pending') {
    return null;
  }
  return overall;
}

/// What the AI returned for a question, as shown to the inspector.
enum _AiStatus { pass, fail, pending, notAvailable, other }

/// Reads `ai_response.overall_result`: Pass / Fail / Pending, missing →
/// not available, anything else is shown as returned.
_AiStatus _statusOf(ResultData item) {
  final overall = item.aiResponse?.overallResult?.trim().toLowerCase() ?? '';
  return switch (overall) {
    'pass' => _AiStatus.pass,
    'fail' => _AiStatus.fail,
    'pending' => _AiStatus.pending,
    '' || 'null' => _AiStatus.notAvailable,
    _ => _AiStatus.other,
  };
}

/// PASS / FAIL / PENDING / "AI result not available" badge for [item].
StatusBadge _statusBadge(ResultData item, {bool dense = false}) {
  switch (_statusOf(item)) {
    case _AiStatus.pass:
      return StatusBadge.pass(label: 'PASS', dense: dense);
    case _AiStatus.fail:
      return StatusBadge.fail(label: 'FAIL', dense: dense);
    case _AiStatus.pending:
      return StatusBadge.pending(label: 'PENDING', dense: dense);
    case _AiStatus.notAvailable:
      return StatusBadge.neutral(
        label: 'AI result not available',
        icon: Icons.help_outline_rounded,
        dense: dense,
      );
    case _AiStatus.other:
      return StatusBadge.neutral(
        label: item.aiResponse!.overallResult!.trim().toUpperCase(),
        icon: Icons.info_outline_rounded,
        dense: dense,
      );
  }
}

Widget _resultBadge(String? result) => result == null
    ? const StatusBadge.neutral(
        label: 'AI result not available',
        icon: Icons.help_outline_rounded,
        dense: true,
      )
    : StatusBadge.fromResult(result.trim().toUpperCase(), dense: true);

bool _isEmptyValue(dynamic value) {
  if (value == null) return true;
  if (value is Map) return value.isEmpty;
  if (value is List) return value.isEmpty;
  if (value is String) return value.trim().isEmpty;
  return false;
}

/// "headlights_detected" / "numberOfHeadlights" -> "Headlights detected" / "Number of headlights".
String _humanize(String key) {
  final spaced = key
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .trim()
      .toLowerCase();
  if (spaced.isEmpty) return key;
  return spaced[0].toUpperCase() + spaced.substring(1);
}

/// Renders an API value: booleans and pass/fail strings as status badges,
/// everything else as plain text.
Widget _valueBadge(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) {
    return Text('—', style: AppText.body.copyWith(color: na));
  }
  if (value is bool) {
    return value
        ? const StatusBadge.pass(label: 'Yes', dense: true)
        : const StatusBadge.fail(label: 'No', dense: true);
  }
  if (value is String) {
    final lower = value.trim().toLowerCase();
    if (lower == 'pass' || lower == 'fail') {
      return StatusBadge.fromResult(value, dense: true);
    }
  }
  final text = value is Map
      ? value.entries
            .map((e) => '${_humanize(e.key.toString())}: ${e.value}')
            .join('\n')
      : value is List
      ? value.join(', ')
      : value.toString();
  return Text(
    text,
    textAlign: TextAlign.right,
    style: AppText.label,
  );
}
