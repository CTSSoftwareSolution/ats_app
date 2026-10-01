import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
import 'package:ats_app/Presentation/provider/ai_update_result_provider.dart';
import 'package:ats_app/Presentation/provider/bottom_navigation_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/bottom_navigation_bar.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';

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
    await context.read<AiResultProvider>().aiResultDetails(context);
  }

  bool _isNavigating = false;

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
      backgroundColor: background,
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          text: "AI Result",
          fontSize: 18,
          fontFamily: "SemiBold",
          textColor: whiteColor,
        ),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: ImageIcon(
            AssetImage(backArrowIcon),
            color: whiteColor,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? Center(child: CustomLoader.loader())
            : RefreshIndicator(
                color: appColor,
                onRefresh: _loadResult,
                child: _buildBody(provider),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: _isNavigating ? null : _goToDashboard,
            style: FilledButton.styleFrom(
              backgroundColor: appColor,
              foregroundColor: whiteColor,
              elevation: 6,
              shadowColor: navy.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              textStyle: const TextStyle(fontFamily: "SemiBold", fontSize: 16),
            ),
            child: const Text("Done"),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AiResultProvider provider) {
    final entity = provider.aiResultEntity;
    final data = entity?.data ?? [];

    if (entity == null) {
      return _ScrollableState(
        child: AppStateView(
          icon: Icons.error_outline_rounded,
          color: fail,
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
          title: "Result Pending",
          message: _hasText(entity.message)
              ? entity.message!.trim()
              : "Processing pending. Please check again shortly.",
          onAction: _loadResult,
        ),
      );
    }

    final records = _currentRecords(data);

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, _fabClearance),
      itemCount: records.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Divider(height: 1, thickness: 1, color: borderDark),
      ),
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _QuestionCard(
            text: records[index].questionText,
            label: records.length > 1
                ? "Inspection Question ${index + 1} of ${records.length}"
                : "Inspection Question",
            result: _availableResult(records[index]),
            onTap: () => _showChangeResultSheet(provider, records[index]),
          ),
          const SizedBox(height: 16),
          const Text(
            "Result Details",
            style: TextStyle(fontFamily: "Bold", fontSize: 16, color: textPrimary),
          ),
          const SizedBox(height: 12),
          _ResultDetails(item: records[index]),
        ],
      ),
    );
  }

  /// Opens the result editor for [item] only.
  void _showChangeResultSheet(AiResultProvider provider, ResultData item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangeResultSheet(
        questionId: item.labelId,
        question: item.questionText,
        current: _availableResult(item),
        onUpdated: (result) => provider.updateQuestionResult(item, result),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String? text;
  final String label;
  final String? result;
  final VoidCallback onTap;

  const _QuestionCard({this.text, required this.label, this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _SectionLabel(label)),
              const SizedBox(width: 8),
              _resultBadge(result),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, size: 20, color: textMuted),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _hasText(text) ? text!.trim() : '—',
            style: const TextStyle(
              fontFamily: "SemiBold",
              fontSize: 15,
              color: textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDetails extends StatelessWidget {
  final ResultData item;

  const _ResultDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    final response = item.aiResponse;
    final overall = _availableResult(item);

    // No overall result yet (missing or pending): show only the notice.
    if (response == null || overall == null) {
      return const _InlineNotice(
        icon: Icons.info_outline_rounded,
        text: "AI Result Not Available",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KeyValueCard(
          rows: [
            _DetailRow(
              label: "Overall Result",
              child: StatusBadge.fromResult(overall, dense: true),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _AnalysisCard(analysis: response.analysis, message: response.message),
      ],
    );
  }
}

/// Bottom sheet to change the result of one question to Pass or Fail.
class _ChangeResultSheet extends StatefulWidget {
  final num? questionId;
  final String? question;
  final String? current;

  /// Called with the new result once the API has accepted it.
  final ValueChanged<String> onUpdated;

  const _ChangeResultSheet({
    this.questionId,
    this.question,
    this.current,
    required this.onUpdated,
  });

  @override
  State<_ChangeResultSheet> createState() => _ChangeResultSheetState();
}

class _ChangeResultSheetState extends State<_ChangeResultSheet> {
  late String? _selected = widget.current?.trim().toUpperCase();
  bool _isUpdating = false;

  bool get _canUpdate =>
      !_isUpdating && _selected != null && _selected != widget.current?.trim().toUpperCase();

  Future<void> _update() async {
    if (!_canUpdate) return;
    final result = _selected!;
    setState(() => _isUpdating = true);

    final response = await context.read<AiUpdateResultProvider>().updateQuestionResult(
          context,
          questionId: widget.questionId,
          statusResult: result == "PASS",
        );

    if (response?.success == true) {
      widget.onUpdated(result);
      CustomLoader.message(
        _hasText(response!.message) ? response.message!.trim() : "Result updated successfully",
      );
      if (mounted) Navigator.pop(context);
      return;
    }

    CustomLoader.errorMessage(
      _hasText(response?.message) ? response!.message!.trim() : "Unable to update result",
    );
    if (mounted) setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isUpdating,
      child: AppBottomSheet(
        title: "Change Result",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionLabel("Inspection Question"),
            const SizedBox(height: 6),
            Text(
              _hasText(widget.question) ? widget.question!.trim() : '—',
              style: const TextStyle(
                fontFamily: "SemiBold",
                fontSize: 15,
                color: textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            _DetailRow(label: "Current Result", child: _resultBadge(widget.current)),
            const Divider(height: 1, thickness: 1, color: border),
            const SizedBox(height: 16),
            const _SectionLabel("Change To"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ResultOption(
                    label: "PASS",
                    icon: Icons.check_circle_rounded,
                    color: pass,
                    background: passLight,
                    selected: _selected == "PASS",
                    onTap: _isUpdating ? null : () => setState(() => _selected = "PASS"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ResultOption(
                    label: "FAIL",
                    icon: Icons.cancel_rounded,
                    color: fail,
                    background: failLight,
                    selected: _selected == "FAIL",
                    onTap: _isUpdating ? null : () => setState(() => _selected = "FAIL"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _canUpdate ? _update : null,
                style: FilledButton.styleFrom(
                  backgroundColor: appColor,
                  disabledBackgroundColor: border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: whiteColor),
                      )
                    : const Text(
                        "Update",
                        style: TextStyle(fontFamily: "SemiBold", fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final bool selected;
  final VoidCallback? onTap;

  const _ResultOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    return Material(
      color: selected ? background : surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: selected ? color : border, width: selected ? 1.5 : 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontFamily: "Bold", fontSize: 14, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final dynamic analysis;
  final String? message;

  const _AnalysisCard({required this.analysis, this.message});

  /// Analysis keys that are kept in the model but not shown to the user.
  static const _hiddenKeys = {'processing_time_sec'};

  @override
  Widget build(BuildContext context) {
    final analysis = this.analysis is Map
        ? Map.fromEntries((this.analysis as Map)
            .entries
            .where((e) => !_hiddenKeys.contains(e.key.toString())))
        : this.analysis;

    if (_isEmptyValue(analysis)) {
      return _KeyValueCard(
        title: "Analysis",
        rows: const [],
        footer: _InlineNotice(
          icon: Icons.info_outline_rounded,
          text: _hasText(message) ? message!.trim() : "No analysis data returned.",
        ),
      );
    }

    final rows = <Widget>[];
    if (analysis is Map) {
      analysis.forEach((key, value) {
        rows.add(_DetailRow(label: _humanize(key.toString()), child: _valueBadge(value)));
      });
    } else if (analysis is List) {
      for (var i = 0; i < analysis.length; i++) {
        rows.add(_DetailRow(label: 'Item ${i + 1}', child: _valueBadge(analysis[i])));
      }
    } else {
      rows.add(_DetailRow(label: 'Analysis', child: _valueBadge(analysis)));
    }

    return _KeyValueCard(title: "Analysis", rows: rows);
  }
}

/// Card of key-value rows separated by hairline dividers.
class _KeyValueCard extends StatelessWidget {
  final String? title;
  final List<Widget> rows;
  final Widget? footer;

  const _KeyValueCard({this.title, required this.rows, this.footer});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (title != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: _SectionLabel(title!),
      ));
    }
    for (var i = 0; i < rows.length; i++) {
      if (i > 0) children.add(const Divider(height: 1, thickness: 1, color: border));
      children.add(rows[i]);
    }
    if (footer != null) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 8));
      children.add(footer!);
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: title != null
            ? [const SizedBox(height: 8), ...children, const SizedBox(height: 4)]
            : children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DetailRow({required this.label, required this.child});

  static const _labelStyle = TextStyle(fontSize: 13.5, color: textSecondary);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _labelStyle)),
          const SizedBox(width: 16),
          Flexible(child: Align(alignment: Alignment.centerRight, child: child)),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: naLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: na),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, color: textSecondary, height: 1.4),
            ),
          ),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, _fabClearance),
      children: [const SizedBox(height: 40), child],
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

/// The question's overall result, or null when it is missing or still pending.
String? _availableResult(ResultData item) {
  final overall = item.aiResponse?.overallResult;
  if (!_hasText(overall) || overall!.trim().toLowerCase() == 'pending') return null;
  return overall;
}

Widget _resultBadge(String? result) => result == null
    ? const StatusBadge.neutral(label: 'Not Available', dense: true)
    : StatusBadge.fromResult(result, dense: true);

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
    return const Text('—', style: TextStyle(fontSize: 14, color: textMuted));
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
      ? value.entries.map((e) => '${_humanize(e.key.toString())}: ${e.value}').join('\n')
      : value is List
          ? value.join(', ')
          : value.toString();
  return Text(
    text,
    textAlign: TextAlign.right,
    style: const TextStyle(fontSize: 14, fontFamily: "SemiBold", color: textPrimary),
  );
}

/// Bottom list padding so the floating Done button never covers content.
const double _fabClearance = 96;
