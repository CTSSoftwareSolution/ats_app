import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utilities/color_data.dart';
import '../app_provider.dart';
import '../new_model/inspection_model.dart';



class ReportScreen extends StatelessWidget {
  final String vehicleId;
  const ReportScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final v = prov.vehicles.firstWhere((e) => e.id == vehicleId);

    final isFit = v.overallResult == 'FIT';
    final isPending = v.overallResult == 'PENDING';
    final rColor = isFit ? pass : isPending ? warn : fail;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: navy, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context)),
        title: Text('Inspection Report', style: GoogleFonts.inter(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          // Verdict banner
          Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 32),
            color: rColor,
            child: Column(children: [
              Icon(isFit ? Icons.verified_rounded : isPending
                  ? Icons.hourglass_top_rounded : Icons.dangerous_rounded,
                  color: Colors.white, size: 52),
              const SizedBox(height: 10),
              Text(v.overallResult, style: GoogleFonts.inter(
                  color: Colors.white, fontSize: 32,
                  fontWeight: FontWeight.w800, letterSpacing: 2)),
              const SizedBox(height: 4),
              Text(isFit ? 'All visual checks passed'
                  : isPending ? '${v.pendingCount} items pending'
                  : '${v.failCount} item(s) failed',
                  style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.85), fontSize: 13)),
            ]),
          ),

          Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats
              Row(children: [
                _ST('Passed', v.passCount, pass, passLight, Icons.check_circle_rounded),
                const SizedBox(width: 8),
                _ST('Failed', v.failCount, fail, failLight, Icons.cancel_rounded),
                const SizedBox(width: 8),
                _ST('N/A', v.naCount, na, naLight, Icons.remove_circle_rounded),
                const SizedBox(width: 8),
                _ST('Pending', v.pendingCount, warn, warnLight, Icons.hourglass_bottom_rounded),
              ]),
              const SizedBox(height: 20),

              // Vehicle details
              _CardSection('Vehicle Details', Icons.directions_car_rounded,
                Column(children: [
                  _IR('Registration', v.regNo.isEmpty ? '—' : v.regNo, first: true),
                  _IR('Class', v.vehicleClass.isEmpty ? '—' : v.vehicleClass),
                  _IR('Make / Model', '${v.make} ${v.model}'.trim().isEmpty ? '—' : '${v.make} ${v.model}'.trim()),
                  _IR('Fuel', v.fuelType.isEmpty ? '—' : v.fuelType),
                  _IR('Emission', v.emissionNorms.isEmpty ? '—' : v.emissionNorms),
                  _IR('Test Date', v.testDate.isEmpty ? '—' : v.testDate),
                  _IR('ATS', v.atsName.isEmpty ? '—' : v.atsName),
                  _IR('RTO', v.rtoDistrict.isEmpty ? '—' : v.rtoDistrict, last: true),
                ])),
              const SizedBox(height: 16),

              // Photos summary
              _CardSection('Vehicle Photos', Icons.camera_alt_rounded,
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(children: [
                    Icon(v.photosComplete ? Icons.check_circle_rounded
                        : Icons.camera_alt_rounded,
                        color: v.photosComplete ? pass : warn, size: 20),
                    const SizedBox(width: 10),
                    Text('${v.photoCount}/8 vehicle photos captured',
                        style: GoogleFonts.inter(color: textPrimary,
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ]))),
              const SizedBox(height: 16),

              // Section summary
              _CardSection('Section Summary', Icons.list_alt_rounded,
                Column(children: v.sections.asMap().entries.map((e) =>
                    _SRow(e.value, last: e.key == v.sections.length - 1)).toList())),

              // Failed items
              if (v.failCount > 0) ...[
                const SizedBox(height: 16),
                _CardSection('Failed Items', Icons.warning_amber_rounded,
                  Column(children: v.sections.expand((s) => s.items)
                      .where((i) => i.result == InspectionResult.fail)
                      .toList().asMap().entries.map((e) {
                    final items = v.sections.expand((s) => s.items)
                        .where((i) => i.result == InspectionResult.fail).toList();
                    return _FRow(e.value, last: e.key == items.length - 1);
                  }).toList()),
                  iconColor: fail),
              ],
              const SizedBox(height: 32),
            ],
          )),
        ]),
      ),
    );
  }
}

class _ST extends StatelessWidget {
  final String l; final int c; final Color col, bg; final IconData i;
  const _ST(this.l, this.c, this.col, this.bg, this.i);
  @override build(BuildContext ctx) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 6, offset: const Offset(0,2))]),
    child: Column(children: [
      Container(width: 32, height: 32,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(i, color: col, size: 16)),
      const SizedBox(height: 4),
      Text('$c', style: GoogleFonts.inter(color: textPrimary,
          fontSize: 18, fontWeight: FontWeight.w800)),
      Text(l, style: GoogleFonts.inter(color: textMuted,
          fontSize: 9, fontWeight: FontWeight.w500)),
    ]),
  ));
}

class _CardSection extends StatelessWidget {
  final String t; final IconData i; final Widget child;
  final Color iconColor;
  const _CardSection(this.t, this.i, this.child, {this.iconColor = navy});
  @override build(BuildContext ctx) => Container(
    decoration: BoxDecoration(color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0,2))]),
    child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16,14,16,12),
        child: Row(children: [
          Icon(i, color: iconColor, size: 16), const SizedBox(width: 8),
          Text(t, style: GoogleFonts.inter(color: textPrimary,
              fontSize: 13, fontWeight: FontWeight.w700)),
        ])),
      Divider(height: 1, color: border),
      child,
    ]),
  );
}

class _IR extends StatelessWidget {
  final String l, v; final bool first, last;
  const _IR(this.l, this.v, {this.first=false, this.last=false});
  @override build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    decoration: BoxDecoration(border: Border(bottom: last ? BorderSide.none
        : BorderSide(color: border))),
    child: Row(children: [
      SizedBox(width: 110, child: Text(l, style: GoogleFonts.inter(
          color: textMuted, fontSize: 12))),
      Expanded(child: Text(v, style: GoogleFonts.inter(
          color:textPrimary, fontSize: 12, fontWeight: FontWeight.w600))),
    ]),
  );
}

class _SRow extends StatelessWidget {
  final InspectionSection s; final bool last;
  const _SRow(this.s, {this.last=false});
  Color get c => s.hasFailure ? fail : s.allDone ? pass : textMuted;
  Color get bg => s.hasFailure ? failLight : s.allDone ? passLight : naLight;
  @override build(BuildContext ctx) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(border: Border(bottom: last ? BorderSide.none
        : BorderSide(color: border))),
    child: Row(children: [
      Text(s.icon, style: const TextStyle(fontSize: 18)), const SizedBox(width: 12),
      Expanded(child: Text(s.title, style: GoogleFonts.inter(
          color: textPrimary, fontSize: 12, fontWeight: FontWeight.w500))),
      _mb('${s.passCount}P', pass, passLight),
      const SizedBox(width: 4),
      _mb('${s.failCount}F', fail, failLight),
      const SizedBox(width: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(s.hasFailure ? 'Fail' : s.allDone ? 'Done' : 'Pending',
            style: GoogleFonts.inter(color: c, fontSize: 10, fontWeight: FontWeight.w600))),
    ]),
  );
  Widget _mb(String t, Color c, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
    child: Text(t, style: GoogleFonts.inter(color: c, fontSize: 10, fontWeight: FontWeight.w600)));
}

class _FRow extends StatelessWidget {
  final InspectionItem item; final bool last;
  const _FRow(this.item, {this.last=false});
  @override build(BuildContext ctx) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(border: Border(bottom: last ? BorderSide.none
        : BorderSide(color: border))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.cancel_rounded, color:fail, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: failLight,
                borderRadius: BorderRadius.circular(4)),
            child: Text('Item ${item.ref}', style: GoogleFonts.robotoMono(
                color: fail, fontSize: 9))),
          const SizedBox(width: 8),
          Expanded(child: Text(item.name, style: GoogleFonts.inter(
              color:textPrimary, fontSize: 12, fontWeight: FontWeight.w600))),
        ]),
        if (item.observation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(item.observation, style: GoogleFonts.inter(
              color: textSecondary, fontSize: 11)),
        ],
      ])),
    ]),
  );
}
