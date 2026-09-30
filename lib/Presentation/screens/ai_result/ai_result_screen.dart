import 'package:ats_app/Data/model/response_model/ai_result_response.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
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
    );
  }

  Widget _buildBody(AiResultProvider provider) {
    final entity = provider.aiResultEntity;
    final data = entity?.data ?? [];

    if (entity == null) {
      return _ScrollableState(
        child: _StateCard(
          icon: Icons.error_outline_rounded,
          color: fail,
          title: "Unable to load result",
          message: "Pull down or tap retry to try again.",
          onRetry: _loadResult,
        ),
      );
    }

    if (data.isEmpty) {
      return _ScrollableState(
        child: _StateCard(
          icon: Icons.schedule_rounded,
          color: warn,
          title: "Result Pending",
          message: _hasText(entity.message)
              ? entity.message!.trim()
              : "Processing pending. Please check again shortly.",
          onRetry: _loadResult,
        ),
      );
    }

    final records = _currentRecords(data);

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
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
}

class _QuestionCard extends StatelessWidget {
  final String? text;
  final String label;

  const _QuestionCard({this.text, required this.label});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label),
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

  bool get _isAiResponseEmpty {
    final r = item.aiResponse;
    if (r == null) return true;
    return r.status == null &&
        r.overallResult == null &&
        r.manualCheck == null &&
        !_hasText(r.message) &&
        _isEmptyValue(r.analysis);
  }

  @override
  Widget build(BuildContext context) {
    final response = item.aiResponse;
    final overall = response?.overallResult ?? item.aiResult;
    final overallBadge = _hasText(overall)
        ? StatusBadge.fromResult(overall, dense: true)
        : const StatusBadge.pending(label: 'Result Pending', dense: true);

    if (_isAiResponseEmpty) {
      return _KeyValueCard(
        rows: [
          _DetailRow(label: "Overall Result", child: overallBadge),
        ],
        footer: const _InlineNotice(
          icon: Icons.info_outline_rounded,
          text: "AI result not available",
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KeyValueCard(
          rows: [
            _DetailRow(label: "Overall Result", child: overallBadge),
            _DetailRow(
              label: "Manual Check",
              child: _valueBadge(response!.manualCheck),
            ),
            _DetailRow(
              label: "AI Status",
              child: response.status == null
                  ? const StatusBadge.pending(dense: true)
                  : response.status!
                      ? const StatusBadge.pass(label: 'Success', dense: true)
                      : const StatusBadge.fail(label: 'Failed', dense: true),
            ),
            if (_hasText(response.message))
              _DetailRow.stacked(
                label: "Message",
                child: Text(
                  response.message!.trim(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "SemiBold",
                    color: textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _AnalysisCard(analysis: response.analysis, message: response.message),
      ],
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final dynamic analysis;
  final String? message;

  const _AnalysisCard({required this.analysis, this.message});

  @override
  Widget build(BuildContext context) {
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
      (analysis as Map).forEach((key, value) {
        rows.add(_DetailRow(label: _humanize(key.toString()), child: _valueBadge(value)));
      });
    } else if (analysis is List) {
      final list = analysis as List;
      for (var i = 0; i < list.length; i++) {
        rows.add(_DetailRow(label: 'Item ${i + 1}', child: _valueBadge(list[i])));
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
  final bool stacked;

  const _DetailRow({required this.label, required this.child}) : stacked = false;

  /// Label above the value, for long text such as the AI message.
  const _DetailRow.stacked({required this.label, required this.child}) : stacked = true;

  static const _labelStyle = TextStyle(fontSize: 13.5, color: textSecondary);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _labelStyle),
                const SizedBox(height: 4),
                child,
              ],
            )
          : Row(
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
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontFamily: "Bold",
        color: textMuted,
        letterSpacing: 0.8,
      ),
    );
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

/// Full-screen state for load errors and missing results.
class _StateCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final Future<void> Function()? onRetry;

  const _StateCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "Bold", fontSize: 16, color: textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, color: textSecondary, height: 1.4),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: appColor,
                side: const BorderSide(color: border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Retry"),
            ),
          ],
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
      padding: const EdgeInsets.all(16),
      children: [const SizedBox(height: 40), child],
    );
  }
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

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
