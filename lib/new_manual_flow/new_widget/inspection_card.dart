import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_motion.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../new_model/inspection_model.dart';
import 'media_picker_widget.dart';

class InspectionCard extends StatefulWidget {
  final String vehicleId;
  final InspectionSection section;
  final InspectionItem item;
  final VoidCallback? onDone; // called when result set, parent can scroll next
  const InspectionCard({
    super.key,
    required this.vehicleId,
    required this.section,
    required this.item,
    this.onDone,
  });
  @override
  State<InspectionCard> createState() => _State();
}

class _State extends State<InspectionCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late TextEditingController _obs;
  late AnimationController _anim;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _obs = TextEditingController(text: widget.item.observation);
    _anim = AnimationController(vsync: this, duration: AppMotion.standard);
    _rotate = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _anim, curve: AppMotion.curve));
  }

  @override
  void dispose() {
    _obs.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _anim.forward() : _anim.reverse();
  }

  InspectionItem get _live {
    try {
      final prov = context.read<AppProvider>();
      final v = prov.vehicles.firstWhere((e) => e.id == widget.vehicleId);
      return v.sections
          .expand((s) => s.items)
          .firstWhere((i) => i.ref == widget.item.ref);
    } catch (_) {
      return widget.item;
    }
  }

  void _setResult(InspectionResult r) {
    HapticFeedback.mediumImpact();
    final prov = context.read<AppProvider>();
    final v = prov.vehicles.firstWhere((e) => e.id == widget.vehicleId);
    prov.setResult(v, widget.section, _live, r);
    if (r == InspectionResult.fail && !_expanded) {
      setState(() => _expanded = true);
      _anim.forward();
    }
    // Notify parent to scroll to next card
    Future.delayed(const Duration(milliseconds: 150), () {
      widget.onDone?.call();
    });
  }

  Color _ac(InspectionResult r) {
    switch (r) {
      case InspectionResult.pass:
        return pass;
      case InspectionResult.fail:
        return fail;
      case InspectionResult.na:
        return na;
      case InspectionResult.none:
        return border;
    }
  }

  IconData _icon(InspectionResult r) {
    switch (r) {
      case InspectionResult.pass:
        return Icons.check_circle_rounded;
      case InspectionResult.fail:
        return Icons.cancel_rounded;
      case InspectionResult.na:
        return Icons.remove_circle_rounded;
      case InspectionResult.none:
        return Icons.circle_outlined;
    }
  }

  Color _complexityColor(String c) {
    switch (c.toLowerCase()) {
      case 'high':
        return fail;
      case 'medium':
        return warn;
      default:
        return pass;
    }
  }

  Color _complexityBg(String c) {
    switch (c.toLowerCase()) {
      case 'high':
        return failLight;
      case 'medium':
        return warnLight;
      default:
        return passLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppProvider>();
    final item = _live;
    final isDone = item.result != InspectionResult.none;
    final ac = _ac(item.result);
    final radius = BorderRadius.circular(AppRadius.lg);

    // Flat card; the result is shown by a tinted hairline border.
    return AnimatedContainer(
      duration: AppMotion.fast,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: Border.all(
          color: isDone ? ac.withValues(alpha: 0.45) : border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ────────────────────────────────────────────────
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(AppRadius.lg - 1),
              bottom: Radius.circular(_expanded ? 0 : AppRadius.lg - 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  // Status icon
                  Icon(
                    _icon(item.result),
                    color: isDone ? ac : textMuted,
                    size: AppIconSize.md + 2,
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),

                  // Question text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppText.chip.copyWith(height: 1.3),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            _tag('#${item.ref}', textSecondary, surface2),
                            if (item.complexity.isNotEmpty)
                              _tag(
                                item.complexity,
                                _complexityColor(item.complexity),
                                _complexityBg(item.complexity),
                              ),
                            if (item.media.isNotEmpty)
                              _tag(
                                '📎 ${item.media.length}',
                                appColor,
                                accentLight,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // ── P / F / N in one row ──────────────────────────────
                  _PFNRow(current: item.result, onTap: _setResult),
                  const SizedBox(width: AppSpacing.xs),

                  // Expand arrow
                  RotationTransition(
                    turns: _rotate,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: textSecondary,
                      size: AppIconSize.md,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded panel ────────────────────────────────────────────
          AnimatedCrossFade(
            duration: AppMotion.standard,
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _ExpandedPanel(
              item: item,
              obs: _obs,
              vehicleId: widget.vehicleId,
              onObsChanged: (val) =>
                  context.read<AppProvider>().setObservation(item, val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String t, Color c, Color bg) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs + 2,
      vertical: 1,
    ),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.xs),
    ),
    child: Text(t, style: AppText.badgeDense.copyWith(color: c)),
  );
}

// ── P / F / N single-row ──────────────────────────────────────────────────────
class _PFNRow extends StatelessWidget {
  final InspectionResult current;
  final ValueChanged<InspectionResult> onTap;
  const _PFNRow({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _Pill('P', InspectionResult.pass, pass, current, onTap),
      const SizedBox(width: AppSpacing.xs),
      _Pill('F', InspectionResult.fail, fail, current, onTap),
      const SizedBox(width: AppSpacing.xs),
      _Pill('N', InspectionResult.na, na, current, onTap),
    ],
  );
}

class _Pill extends StatelessWidget {
  final String label;
  final InspectionResult value, current;
  final Color color;
  final ValueChanged<InspectionResult> onTap;
  const _Pill(this.label, this.value, this.color, this.current, this.onTap);

  bool get _sel => current == value;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onTap(value),
    child: AnimatedContainer(
      duration: AppMotion.fast,
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _sel ? color : surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: _sel ? color : color.withValues(alpha: 0.35),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: AppText.badgeDense.copyWith(
            color: _sel ? textWhite : color,
          ),
        ),
      ),
    ),
  );
}

// ── Expanded detail panel ─────────────────────────────────────────────────────
class _ExpandedPanel extends StatelessWidget {
  final InspectionItem item;
  final TextEditingController obs;
  final String vehicleId;
  final ValueChanged<String> onObsChanged;
  const _ExpandedPanel({
    required this.item,
    required this.obs,
    required this.vehicleId,
    required this.onObsChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(height: 1),

      // Checklist params
      if (item.params.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: item.params
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: na,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            p,
                            style: AppText.caption.copyWith(
                              color: textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),

      // Rule ref
      if (item.ruleRef.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: accentLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            children: [
              const Icon(Icons.gavel_rounded, color: secondaryDark, size: 13),
              const SizedBox(width: AppSpacing.xs + 2),
              Expanded(
                child: Text(
                  item.ruleRef,
                  style: AppText.caption.copyWith(fontSize: 11, color: secondaryDark),
                ),
              ),
            ],
          ),
        ),

      // Observation on fail
      if (item.result == InspectionResult.fail)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: TextField(
            controller: obs,
            onChanged: onObsChanged,
            style: AppText.body,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Describe the issue...',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + 2,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: fail.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: fail, width: 1.5),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),

      // Media
      const Divider(height: 1),
      MediaPickerSection(vehicleId: vehicleId, item: item),
    ],
  );
}
