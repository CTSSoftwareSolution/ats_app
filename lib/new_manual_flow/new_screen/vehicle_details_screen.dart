import 'package:ats_app/new_manual_flow/new_screen/report_screen.dart';
import 'package:ats_app/new_manual_flow/new_screen/vehicle_photos_screen.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../app_provider.dart';
import '../auth_provider.dart';
import '../debug_log_overlay.dart';
import '../new_model/inspection_model.dart';
import '../new_model/vehicle_entry.dart';
import '../new_widget/logout_dialog.dart';
import 'inspection_flow_screen.dart';



class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (_, prov, __) {
      debugPrint("testId: $vehicleId");
      debugPrint("testList: ${prov.vehicles}");
      final v = prov.vehicles.firstWhere((e) => e.regNo == vehicleId);

      return DebugFabWrapper(
        child: Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: navy, elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context)),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.displayName, style: GoogleFonts.inter(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              Text('Inspection Workflow', style: GoogleFonts.inter(
                  color: textWhiteSub, fontSize: 10)),
            ]),
            actions: [
              IconButton(
                  icon: const Icon(Icons.logout_rounded,
                      color: Colors.white70, size: 20),
                  onPressed: () => confirmLogout(context)),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _VehicleInfoCard(vehicle: v),
              const SizedBox(height: 16),

              // PRE-INSPECTION
              _PhaseHeader(
                  phase: 'PRE-INSPECTION',
                  subtitle: 'Visual checks before vehicle enters test lane',
                  icon: Icons.checklist_rounded,
                  color: navyAccent,
                  isDone: v.preAllDone),
              const SizedBox(height: 10),

              _StepCard(
                step: 1,
                icon: Icons.camera_alt_rounded,
                title: '8 Vehicle Photos',
                subtitle: v.photosComplete
                    ? 'All 8 angles captured ✓'
                    : '${v.photoCount}/8 — front, rear, sides, engine...',
                isDone: v.photosComplete,
                progress: v.photoCount / 8,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => VehiclePhotosScreen(vehicleId: vehicleId,))),
              ),
              const SizedBox(height: 8),

              _StepCard(
                step: 2,
                icon: Icons.assignment_rounded,
                title: 'Pre-Inspection Checks',
                subtitle: v.preAllDone
                    ? 'All ${v.preTotalItems} checks completed ✓'
                    : '${v.preDoneCount}/${v.preTotalItems} — lamps, safety, body, tyres...',
                isDone: v.preAllDone,
                progress: v.preTotalItems > 0 ? v.preDoneCount / v.preTotalItems : 0,
                locked: context.watch<AuthProvider>().config.requirePhotosForPre && !v.photosComplete,
                onTap: context.read<AuthProvider>().config.requirePhotosForPre && !v.photosComplete
                    ? () => _snack(context, 'Complete 8 vehicle photos first')
                    : () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => InspectionFlowScreen(
                        vehicleId: vehicleId, phase: InspectionPhase.pre))),
              ),
              const SizedBox(height: 20),

              // POST-INSPECTION
              _PhaseHeader(
                  phase: 'POST-INSPECTION',
                  subtitle: 'Checks after automated tests in the lane',
                  icon: Icons.fact_check_rounded,
                  color: pass,
                  isDone: v.postAllDone),
              const SizedBox(height: 10),

              _StepCard(
                step: 3,
                icon: Icons.assignment_turned_in_rounded,
                title: 'Post-Inspection Checks',
                subtitle: v.postAllDone
                    ? 'All ${v.postTotalItems} checks completed ✓'
                    : '${v.postDoneCount}/${v.postTotalItems} — brakes, emission, protection...',
                isDone: v.postAllDone,
                progress: v.postTotalItems > 0 ? v.postDoneCount / v.postTotalItems : 0,
                locked: context.watch<AuthProvider>().config.requirePreForPost && !v.preAllDone,
                onTap: context.read<AuthProvider>().config.requirePreForPost && !v.preAllDone
                    ? () => _snack(context, 'Complete pre-inspection checks first')
                    : () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => InspectionFlowScreen(
                        vehicleId: vehicleId, phase: InspectionPhase.post))),
              ),
              const SizedBox(height: 24),

              if (v.doneCount > 0)
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ReportScreen(vehicleId: vehicleId))),
                    icon: const Icon(Icons.summarize_rounded, size: 18),
                    label: Text('View Inspection Report',
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white, elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      );
    });
  }

  void _snack(BuildContext ctx, String msg) =>
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(msg, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
}

// ── Phase header ──────────────────────────────────────────────────────────────
class _PhaseHeader extends StatelessWidget {
  final String phase, subtitle; final IconData icon;
  final Color color; final bool isDone;
  const _PhaseHeader({required this.phase, required this.subtitle,
    required this.icon, required this.color, required this.isDone});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: isDone ? 0.5 : 0.2))),
    child: Row(children: [
      Container(width: 36, height: 36,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: isDone
              ? Icon(Icons.check_circle_rounded, color: color, size: 22)
              : Icon(icon, color: color, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(phase, style: GoogleFonts.inter(
            color: color, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        Text(subtitle, style: GoogleFonts.inter(
            color: textMuted, fontSize: 11)),
      ])),
      if (isDone) Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text('DONE', style: GoogleFonts.inter(
              color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1))),
    ]),
  );
}

// ── Vehicle info card ─────────────────────────────────────────────────────────
class _VehicleInfoCard extends StatelessWidget {
  final VehicleEntry vehicle;
  const _VehicleInfoCard({required this.vehicle});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 44, height: 44,
            decoration: BoxDecoration(
                color: navyAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.directions_car_rounded,
                color: navyAccent, size: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(vehicle.displayName, style: GoogleFonts.inter(
              color: textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          if (vehicle.customerName.isNotEmpty)
            Text(vehicle.customerName, style: GoogleFonts.inter(
                color: textMuted, fontSize: 11)),
        ])),
        if (vehicle.vehicleClass.isNotEmpty)
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: accentLight, borderRadius: BorderRadius.circular(8)),
              child: Text(vehicle.vehicleClass, style: GoogleFonts.inter(
                  color: navyAccent, fontSize: 10, fontWeight: FontWeight.w700))),
      ]),
      const SizedBox(height: 12),
      Divider(height: 1, color: border),
      const SizedBox(height: 10),
      Wrap(spacing: 16, runSpacing: 6, children: [
        _kv('Fuel', vehicle.fuelType),
        _kv('Make/Model', '${vehicle.make} ${vehicle.model}'.trim()),
        _kv('Lane', vehicle.laneName),
        _kv('Booking', vehicle.bookingId),
        _kv('Fitness', vehicle.fitnessExpiry),
        _kv('Test Date', vehicle.testDate),
        if (vehicle.customerContact.isNotEmpty)
          _kv('Contact', vehicle.customerContact),
      ]),
    ]),
  );

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return RichText(text: TextSpan(children: [
      TextSpan(text: '$k: ', style: GoogleFonts.inter(
          color: textMuted, fontSize: 11)),
      TextSpan(text: v, style: GoogleFonts.inter(
          color: textPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
    ]));
  }
}

// ── Step card ─────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int step; final IconData icon;
  final String title, subtitle;
  final bool isDone, locked;
  final double? progress;
  final VoidCallback onTap;
  const _StepCard({required this.step, required this.icon, required this.title,
    required this.subtitle, required this.isDone,
    this.locked = false, this.progress, required this.onTap});

  Color get _c => locked ? textMuted
      : isDone ? pass : navyAccent;
  Color get _bg => locked ? naLight
      : isDone ? passLight : accentLight;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: surface, borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDone ? pass.withValues(alpha: 0.4)
                  : locked ? border
                  : navyAccent.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(width: 44, height: 44,
            decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(10)),
            child: locked
                ? const Icon(Icons.lock_outline_rounded, color: textMuted, size: 20)
                : isDone
                ? const Icon(Icons.check_circle_rounded, color: pass, size: 26)
                : Icon(icon, color: _c, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 20, height: 20,
                decoration: BoxDecoration(
                    color: locked ? naLight : _bg, shape: BoxShape.circle),
                child: Center(child: Text('$step',
                    style: GoogleFonts.inter(color: _c, fontSize: 10, fontWeight: FontWeight.w800)))),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: GoogleFonts.inter(
                color: locked ? textMuted : textPrimary,
                fontSize: 13, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 3),
          Text(subtitle, style: GoogleFonts.inter(color: textMuted, fontSize: 11)),
          if (progress != null && progress! > 0 && !isDone) ...[
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                    value: progress, minHeight: 4,
                    backgroundColor: border,
                    valueColor: AlwaysStoppedAnimation<Color>(_c))),
          ],
        ])),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right_rounded,
            color: locked ? border : textMuted, size: 20),
      ]),
    ),
  );
}
