import 'package:ats_app/new_manual_flow/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utilities/color_data.dart';
import '../app_provider.dart';
import '../debug_log_overlay.dart';

import '../new_model/inspection_model.dart';
import '../new_services/inspection_result_service.dart';
import '../new_services/inspection_validator.dart';
import '../new_services/upload_service.dart';
import '../new_widget/inspection_card.dart';
import '../new_widget/upload_progress_dialog.dart';


class InspectionFlowScreen extends StatefulWidget {
  final String vehicleId;
  final InspectionPhase phase;

  const InspectionFlowScreen({
    super.key,
    required this.vehicleId,
    required this.phase,
  });

  @override
  State<InspectionFlowScreen> createState() => _InspectionFlowScreenState();
}

class _InspectionFlowScreenState extends State<InspectionFlowScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prov = context.read<AppProvider>();

      await prov.loadSections();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (_, prov, __) {
      final v = prov.vehicles.firstWhere((e) => e.regNo == widget.vehicleId);
      final sections = widget.phase == InspectionPhase.pre
          ? v.preSections : v.postSections;
      final doneCount = widget.phase == InspectionPhase.pre
          ? v.preDoneCount : v.postDoneCount;
      final totalItems = widget.phase == InspectionPhase.pre
          ? v.preTotalItems : v.postTotalItems;
      final phaseLabel = widget.phase == InspectionPhase.pre
          ? 'PRE-INSPECTION' : 'POST-INSPECTION';
      final phaseColor = widget.phase == InspectionPhase.pre
          ? navyAccent : pass;

      return DefaultTabController(
        length: sections.length,
        child: DebugFabWrapper(child: Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: navy, elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context)),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: phaseColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(4)),
                  child: Text(phaseLabel, style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 9,
                      fontWeight: FontWeight.w800, letterSpacing: 0.5))),
                const SizedBox(width: 8),
                Text(v.displayName, style: GoogleFonts.inter(
                    color: Colors.white, fontSize: 13,
                    fontWeight: FontWeight.w700)),
              ]),
              Text('$doneCount/$totalItems checks done',
                  style: GoogleFonts.inter(
                      color: textWhiteSub, fontSize: 10)),
            ]),
            actions: [
              Consumer<AppProvider>(
                builder: (_, p, __) {
                  final s = widget.phase == InspectionPhase.pre
                      ? p.vehicles.firstWhere((e) => e.regNo == widget.vehicleId).preSections
                      : p.vehicles.firstWhere((e) => e.regNo == widget.vehicleId).postSections;
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: surface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: border)),
                    onSelected: (val) {
                      final v2 = p.vehicles.firstWhere((e) => e.regNo == widget.vehicleId);
                      if (val == 'pass_all') {
                        for (final sec in s) p.markAllPass(v2, sec);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'pass_all',
                        child: Row(children: [
                          const Icon(Icons.check_circle_rounded,
                              color: pass, size: 16),
                          const SizedBox(width: 10),
                          Text('Mark All Pass', style: GoogleFonts.inter(
                              color: pass, fontSize: 13,
                              fontWeight: FontWeight.w600)),
                        ])),
                    ],
                  );
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: phaseColor,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                labelStyle: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
                tabs: sections.map((s) => Tab(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(s.icon),
                    const SizedBox(width: 5),
                    Text(s.title.split(' ').first),
                    const SizedBox(width: 4),
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: s.hasFailure ? fail
                            : s.allDone ? const Color(0xFF4ADE80)
                            : Colors.transparent)),
                  ]),
                )).toList(),
              ),
            ),
          ),
          body: TabBarView(
            children: sections.map((section) =>
                _SectionTab(vehicleId: widget.vehicleId, section: section)).toList(),
          ),
          bottomNavigationBar: _BottomBar(
              vehicleId: widget.vehicleId, phase: widget.phase, phaseColor: phaseColor),
        )),
      );
    });
  }
}

class _SectionTab extends StatelessWidget {
  final String vehicleId;
  final InspectionSection section;
  const _SectionTab({required this.vehicleId, required this.section});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (_, prov, __) {
      final v = prov.vehicles.firstWhere((e) => e.regNo == vehicleId);
      final s = v.sections.firstWhere((s) {
        debugPrint("s.id = ${s.id}");
        debugPrint("section.id = ${section.id}");
        return s.id == section.id;
      });
      return Column(children: [
        LinearProgressIndicator(
          value: s.items.isEmpty ? 0 : s.doneCount / s.items.length,
          minHeight: 3, backgroundColor: border,
          valueColor: AlwaysStoppedAnimation<Color>(
              s.hasFailure ? fail : pass)),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          physics: const BouncingScrollPhysics(),
          itemCount: s.items.length,
          itemBuilder: (ctx, i) {
            // Each item gets a stable GlobalKey based on section+index
            final itemKey = GlobalObjectKey('${s.id}_$i');
            return InspectionCard(
              key: itemKey,
              vehicleId: vehicleId,
              section: s,
              item: s.items[i],
              onDone: () {
                // Find next unanswered item and scroll to it
                final nextIdx = s.items.indexWhere(
                    (item) => item.result == InspectionResult.none,
                    i + 1);
                if (nextIdx < 0) return;
                final nextKey = GlobalObjectKey('${s.id}_$nextIdx');
                final nextCtx = nextKey.currentContext;
                if (nextCtx != null) {
                  Scrollable.ensureVisible(
                    nextCtx,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    alignment: 0.1,
                  );
                }
              },
            );
          },
        )),
      ]);
    });
  }
}

class _BottomBar extends StatelessWidget {
  final String vehicleId;
  final InspectionPhase phase;
  final Color phaseColor;
  const _BottomBar({required this.vehicleId, required this.phase,
      required this.phaseColor});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (_, prov, __) {
      final v = prov.vehicles.firstWhere((e) => e.regNo == vehicleId);
      final passIns = phase == InspectionPhase.pre
          ? v.preSections.fold(0, (s, sec) => s + sec.passCount)
          : v.postSections.fold(0, (s, sec) => s + sec.passCount);
      final failIns = phase == InspectionPhase.pre
          ? v.preSections.fold(0, (s, sec) => s + sec.failCount)
          : v.postSections.fold(0, (s, sec) => s + sec.failCount);
      final naIns = phase == InspectionPhase.pre
          ? v.preSections.fold(0, (s, sec) => s + sec.naCount)
          : v.postSections.fold(0, (s, sec) => s + sec.naCount);
      final left = phase == InspectionPhase.pre
          ? v.preTotalItems - v.preDoneCount
          : v.postTotalItems - v.postDoneCount;
      final allDone = left == 0 && (phase == InspectionPhase.pre
          ? v.preTotalItems > 0 : v.postTotalItems > 0);

      return Container(
        padding: EdgeInsets.fromLTRB(16,
            allDone ? 10 : 10, 16,
            MediaQuery.of(context).padding.bottom + 10),
        decoration: const BoxDecoration(
          color: surface,
          border: Border(top: BorderSide(color: border))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Stats row
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _Stat('Pass', passIns, pass, passLight,
                Icons.check_circle_rounded),
            _Div(),
            _Stat('Fail', failIns, fail, failLight,
                Icons.cancel_rounded),
            _Div(),
            _Stat('N/A', naIns, na, naLight,
                Icons.remove_circle_rounded),
            _Div(),
            _Stat('Left', left, warn, warnLight,
                Icons.hourglass_bottom_rounded),
          ]),
          // Submit button when all done
          if (allDone) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity, height: 46,
              child: ElevatedButton.icon(
                onPressed: () => _submitAndUpload(context, v),
                icon: const Icon(Icons.cloud_upload_rounded, size: 16),
                label: Text(
                  phase == InspectionPhase.pre
                      ? 'Submit Pre-Inspection & Upload'
                      : 'Submit Post-Inspection & Upload',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: phaseColor,
                  foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ]),
      );
    });
  }

  Future<void> _submitAndUpload(BuildContext context, dynamic v) async {
    final auth = context.read<AuthProvider>();
    final sections = phase == InspectionPhase.pre
        ? v.preSections as List<InspectionSection>
        : v.postSections as List<InspectionSection>;

    // ── Check unanswered ─────────────────────────────────────────────
    final pending = InspectionValidator.unanswered(sections);
    if (pending.isNotEmpty && context.mounted) {
      final ok = await _confirmPending(context, pending.length);
      if (!ok) return;
    }

    // ── Validate rules ───────────────────────────────────────────────
    final errors = InspectionValidator.validate(sections, auth.config);
    if (errors.isNotEmpty && context.mounted) {
      await _showErrors(context, errors);
      return;
    }

    // ── Submit each item: result + observation + media in ONE request ──────────
    final answeredItems = sections
        .expand((s) => s.items)
        .where((i) => i.result != InspectionResult.none)
        .toList();

    final appointmentId = int.tryParse(v.appointmentId) ?? 0;

    if (answeredItems.isNotEmpty && appointmentId > 0) {
      final dlgTitle = phase == InspectionPhase.pre
          ? 'Saving Pre-Inspection'
          : 'Saving Post-Inspection';

      await showUploadDialog(
        context: context,
        title: dlgTitle,
        uploadFn: (onProgress) async {
          int done = 0, failed = 0;
          final total = answeredItems.length;

          for (final item in answeredItems) {
            final mediaCount = item.media.length;
            onProgress(UploadProgress(
              total: total, done: done, failed: failed,
              currentFile: 'Q${item.ref} — ${item.resultLabel}'
                  '${mediaCount > 0 ? " + $mediaCount file(s)" : ""}',
              status: UploadStatus.uploading,
            ));

            final ok = await InspectionResultService.submitItem(
              config:        auth.config,
              vehicleId:     v.regNo,
              appointmentId: appointmentId,
              item:          item,
            );
            if (ok) done++; else failed++;
          }

          final status = failed == 0
              ? UploadStatus.success : UploadStatus.failed;
          final p = UploadProgress(
              total: total, done: done, failed: failed, status: status);
          onProgress(p);
          return p;
        },
      );
    }

    if (context.mounted) Navigator.pop(context);
  }

  // Warn about unanswered items
  Future<bool> _confirmPending(BuildContext ctx, int count) async {
    final result = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded,
              color: warn, size: 22),
          const SizedBox(width: 8),
          Text('$count unanswered',
              style: GoogleFonts.inter(
                  color: textPrimary, fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ]),
        content: Text(
          '$count item(s) have not been marked Pass/Fail/N/A. '
          'Submit anyway?',
          style: GoogleFonts.inter(
              color: textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Go Back',
                style: GoogleFonts.inter(color: textSecondary))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: warn,
                foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text('Submit Anyway',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700))),
        ],
      ),
    );
    return result == true;
  }

  // Show validation errors
  Future<void> _showErrors(
      BuildContext ctx, List<ValidationError> errors) async {
    await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(children: [
          const Icon(Icons.error_outline_rounded,
              color: fail, size: 22),
          const SizedBox(width: 8),
          Text('Cannot Submit',
              style: GoogleFonts.inter(
                  color: textPrimary, fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Fix the following before submitting:',
                style: GoogleFonts.inter(
                    color: textMuted, fontSize: 12)),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: errors.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1, color: border),
                itemBuilder: (_, i) {
                  final e = errors[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: failLight,
                            borderRadius: BorderRadius.circular(4)),
                          child: Text('#${e.itemRef}',
                              style: GoogleFonts.robotoMono(
                                  color: fail, fontSize: 9,
                                  fontWeight: FontWeight.w700))),
                        const SizedBox(width: 8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.itemName,
                                style: GoogleFonts.inter(
                                    color: textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(e.message,
                                style: GoogleFonts.inter(
                                    color: fail,
                                    fontSize: 11)),
                          ],
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text('Fix Issues',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String l; final int c;
  final Color col, bg; final IconData i;
  const _Stat(this.l, this.c, this.col, this.bg, this.i);
  @override build(BuildContext ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 30, height: 30,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(i, color: col, size: 15)),
    const SizedBox(height: 2),
    Text('$c', style: GoogleFonts.inter(
        color: textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
    Text(l, style: GoogleFonts.inter(color: textMuted, fontSize: 9)),
  ]);
}

class _Div extends StatelessWidget {
  @override build(BuildContext ctx) =>
      Container(width: 1, height: 32, color: border);
}
