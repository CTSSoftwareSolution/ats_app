import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  @override State<InspectionCard> createState() => _State();
}

class _State extends State<InspectionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late TextEditingController _obs;
  late AnimationController _anim;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _obs  = TextEditingController(text: widget.item.observation);
    _anim = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 200));
    _rotate = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _obs.dispose(); _anim.dispose(); super.dispose(); }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _anim.forward() : _anim.reverse();
  }

  InspectionItem get _live {
    try {
      final prov = context.read<AppProvider>();
      final v = prov.vehicles.firstWhere((e) => e.id == widget.vehicleId);
      return v.sections.expand((s) => s.items)
          .firstWhere((i) => i.ref == widget.item.ref);
    } catch (_) { return widget.item; }
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
      case InspectionResult.pass: return pass;
      case InspectionResult.fail: return fail;
      case InspectionResult.na:   return na;
      case InspectionResult.none: return border;
    }
  }

  Color _bg(InspectionResult r) {
    switch (r) {
      case InspectionResult.pass: return passLight;
      case InspectionResult.fail: return failLight;
      case InspectionResult.na:   return naLight;
      case InspectionResult.none: return surface;
    }
  }

  IconData _icon(InspectionResult r) {
    switch (r) {
      case InspectionResult.pass: return Icons.check_circle_rounded;
      case InspectionResult.fail: return Icons.cancel_rounded;
      case InspectionResult.na:   return Icons.remove_circle_rounded;
      case InspectionResult.none: return Icons.circle_outlined;
    }
  }

  Color _complexityColor(String c) {
    switch (c.toLowerCase()) {
      case 'high':   return fail;
      case 'medium': return warn;
      default:       return pass;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppProvider>();
    final item  = _live;
    final isDone = item.result != InspectionResult.none;
    final ac     = _ac(item.result);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDone ? ac.withOpacity(0.45) :border,
            width: isDone ? 1.5 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Colour strip ──────────────────────────────────────────────
        if (isDone)
          Container(height: 3, decoration: BoxDecoration(
              color: ac,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11)))),

        // ── Header row ────────────────────────────────────────────────
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isDone ? 0 : 11),
            bottom: Radius.circular(_expanded ? 0 : 11)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            child: Row(children: [

              // Status icon
              Icon(_icon(item.result),
                  color: isDone ? ac : textMuted, size: 22),
              const SizedBox(width: 10),

              // Question text
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: GoogleFonts.inter(
                      color: textPrimary, fontSize: 13,
                      fontWeight: FontWeight.w600, height: 1.3)),
                  const SizedBox(height: 3),
                  Row(children: [
                    _tag('#${item.ref}', textMuted,
                        surface2, mono: true),
                    if (item.complexity.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      _tag(item.complexity,
                          _complexityColor(item.complexity),
                          _complexityColor(item.complexity).withOpacity(0.1)),
                    ],
                    if (item.media.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      _tag('📎 ${item.media.length}',
                          navyAccent,
                          accentLight),
                    ],
                  ]),
                ],
              )),
              const SizedBox(width: 8),

              // ── P / F / N in one row ──────────────────────────────
              _PFNRow(
                current: item.result,
                onTap: _setResult,
              ),
              const SizedBox(width: 4),

              // Expand arrow
              RotationTransition(
                turns: _rotate,
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: textMuted, size: 18)),
            ]),
          ),
        ),

        // ── Expanded panel ────────────────────────────────────────────
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
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
      ]),
    );
  }

  Widget _tag(String t, Color c, Color bg, {bool mono = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(4)),
        child: Text(t,
            style: mono
                ? GoogleFonts.robotoMono(color: c, fontSize: 8)
                : GoogleFonts.inter(color: c, fontSize: 8,
                    fontWeight: FontWeight.w700)),
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
      const SizedBox(width: 4),
      _Pill('F', InspectionResult.fail, fail, current, onTap),
      const SizedBox(width: 4),
      _Pill('N', InspectionResult.na,   na,   current, onTap),
    ],
  );
}

class _Pill extends StatelessWidget {
  final String label;
  final InspectionResult value, current;
  final Color color;
  final ValueChanged<InspectionResult> onTap;
  const _Pill(this.label, this.value, this.color,
      this.current, this.onTap);

  bool get _sel => current == value;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onTap(value),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: _sel ? color : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: _sel ? color : color.withOpacity(0.35),
            width: _sel ? 1.5 : 1),
      ),
      child: Center(child: Text(label,
          style: GoogleFonts.inter(
              color: _sel ? Colors.white : color,
              fontSize: 11, fontWeight: FontWeight.w800))),
    ),
  );
}

// ── Expanded detail panel ─────────────────────────────────────────────────────
class _ExpandedPanel extends StatelessWidget {
  final InspectionItem item;
  final TextEditingController obs;
  final String vehicleId;
  final ValueChanged<String> onObsChanged;
  const _ExpandedPanel({required this.item, required this.obs,
      required this.vehicleId, required this.onObsChanged});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(height: 1, color: border),

      // Checklist params
      if (item.params.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: item.params.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 4, height: 4,
                  decoration: BoxDecoration(
                    color:navyAccent.withOpacity(0.4),
                    shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(p, style: GoogleFonts.inter(
                    color: textSecondary,
                    fontSize: 12, height: 1.4))),
              ]),
            )).toList(),
          ),
        ),

      // Rule ref
      if (item.ruleRef.isNotEmpty)
        Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: accentLight,
            borderRadius: BorderRadius.circular(6)),
          child: Row(children: [
            const Icon(Icons.gavel_rounded,
                color: navyAccent, size: 11),
            const SizedBox(width: 5),
            Expanded(child: Text(item.ruleRef,
                style: GoogleFonts.robotoMono(
                    color: navyAccent, fontSize: 9))),
          ]),
        ),

      // Observation on fail
      if (item.result == InspectionResult.fail)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            controller: obs,
            onChanged: onObsChanged,
            style: GoogleFonts.inter(
                color: textPrimary, fontSize: 12),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Describe the issue...',
              hintStyle: GoogleFonts.inter(
                  color: textMuted, fontSize: 12),
              filled: true, fillColor: bg,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: fail.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: fail, width: 1.5),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),

      // Media
      const Divider(height: 1, color: border),
      MediaPickerSection(vehicleId: vehicleId, item: item),
    ],
  );
}
