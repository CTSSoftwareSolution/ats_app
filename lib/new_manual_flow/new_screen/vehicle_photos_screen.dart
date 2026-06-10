import 'dart:io';
import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:ats_app/new_manual_flow/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utilities/color_data.dart';

import '../debug_log_overlay.dart';
import '../new_model/vehicle_photos_model.dart';

import 'package:provider/provider.dart';

import '../new_services/upload_service.dart';
import '../new_widget/upload_progress_dialog.dart';


class VehiclePhotosScreen extends StatelessWidget {
  final String vehicleId;
  const VehiclePhotosScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (_, prov, __) {
      final v = prov.vehicles.firstWhere((e) => e.id == vehicleId);
      final done = v.photoCount;
      final total = VehiclePhotoAngle.values.length;

      final content = Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor:navy, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context)),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Vehicle Photos', style: GoogleFonts.inter(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            Text('$done/$total captured', style: GoogleFonts.inter(
                color: textWhiteSub, fontSize: 10)),
          ]),
        ),
        body: Column(children: [
          // Progress bar
          LinearProgressIndicator(
            value: done / total, minHeight: 4,
            backgroundColor: border,
            valueColor: AlwaysStoppedAnimation<Color>(
                done == total ? pass : navyAccent)),
          // Instruction banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: accentLight,
            child: Row(children: [
              const Icon(Icons.info_outline_rounded,
                  color: navyAccent, size: 15),
              const SizedBox(width: 8),
              Expanded(child: Text(
                'Take all 8 photos from required angles. GPS coordinates will be stamped automatically.',
                style: GoogleFonts.inter(color: navyAccent, fontSize: 11))),
            ]),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: 0.85),
              itemCount: total,
              itemBuilder: (ctx, i) {
                final angle = VehiclePhotoAngle.values[i];
                final photo = v.photos[angle];
                return _PhotoTile(
                  angle: angle, photo: photo,
                  isCapturing: prov.capturing,
                  onCapture: () => prov.captureVehiclePhoto(v, angle),
                  onRetake: () => prov.retakeVehiclePhoto(v, angle),
                  onView: photo != null
                      ? () => _viewPhoto(ctx, photo)
                      : null,
                );
              },
            ),
          ),
          // Bottom action
          _PhotosBottomBar(vehicleId: vehicleId, done: done, total: total),
        ]),
      );
      return DebugFabWrapper(child: content);
    });
  }

  void _viewPhoto(BuildContext ctx, photo) {
    showDialog(context: ctx, builder: (_) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(children: [
        InteractiveViewer(child: photo.bytes != null
            ? Image.memory(photo.bytes!, fit: BoxFit.contain)
            : kIsWeb ? const Center(child: Icon(Icons.image, color: Colors.white))
                : Image.file(File(photo.path), fit: BoxFit.contain)),
        Positioned(top: 8, right: 8,
          child: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(ctx))),
        Positioned(bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.7),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
              Text(vehiclePhotoLabel(photo.angle).toUpperCase(),
                  style: GoogleFonts.inter(color: const Color(0xFFFBBF24),
                      fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('GPS: ${photo.coordString}',
                  style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 11)),
              Text(photo.address,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 11)),
              Text(photo.formattedDate,
                  style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 10)),
              const SizedBox(height: 6),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: photo.savedToServer
                        ? Colors.green.withOpacity(0.25)
                        : Colors.orange.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: photo.savedToServer
                          ? Colors.greenAccent.withOpacity(0.6)
                          : Colors.orangeAccent.withOpacity(0.6))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      photo.savedToServer
                          ? Icons.cloud_done_rounded : Icons.folder_rounded,
                      color: photo.savedToServer
                          ? Colors.greenAccent : Colors.orangeAccent,
                      size: 11),
                    const SizedBox(width: 4),
                    Text(photo.savedToServer ? 'Saved to Server' : 'Saved Locally',
                        style: GoogleFonts.inter(
                            color: photo.savedToServer
                                ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 10, fontWeight: FontWeight.w600)),
                  ])),
                if (photo.storageNote != null) ...[
                  const SizedBox(width: 6),
                  Expanded(child: Text(photo.storageNote!,
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 9),
                      overflow: TextOverflow.ellipsis)),
                ],
              ]),
            ])),
        ),
      ]),
    ));
  }
}

class _PhotoTile extends StatelessWidget {
  final VehiclePhotoAngle angle;
  final dynamic photo;
  final bool isCapturing;
  final VoidCallback onCapture, onRetake;
  final VoidCallback? onView;

  const _PhotoTile({required this.angle, this.photo, required this.isCapturing,
      required this.onCapture, required this.onRetake, this.onView});

  bool get _captured => photo != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _captured ? pass.withOpacity(0.4) : border,
          width: _captured ? 1.5 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Column(children: [
        // Photo preview / placeholder
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: GestureDetector(
              onTap: _captured ? onView : null,
              child: _captured
                  ? Stack(fit: StackFit.expand, children: [
                      photo.bytes != null
                          ? Image.memory(photo.bytes!, fit: BoxFit.cover)
                          : kIsWeb
                              ? Container(color: passLight,
                                  child: const Icon(Icons.check_circle_rounded,
                                      color: pass, size: 36))
                              : Image.file(File(photo.path), fit: BoxFit.cover),
                      // Captured overlay top-right
                      Positioned(top: 6, right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: pass, shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 12))),
                      // Storage badge bottom-left
                      Positioned(bottom: 4, left: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4)),
                          child: Icon(
                            photo.savedToServer
                                ? Icons.cloud_done_rounded
                                : Icons.folder_rounded,
                            color: photo.savedToServer
                                ? Colors.greenAccent : Colors.orangeAccent,
                            size: 11))),
                    ])
                  : Container(
                      color: bg,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(vehiclePhotoEmoji(angle), style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(vehiclePhotoLabel(angle), textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: textSecondary, fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ])),
            ),
          ),
        ),
        // Bottom action bar
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: border))),
          child: _captured
              ? Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: onView,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.zoom_in_rounded,
                          color: navyAccent, size: 14),
                      const SizedBox(width: 4),
                      Text('View', style: GoogleFonts.inter(
                          color: navyAccent, fontSize: 11,
                          fontWeight: FontWeight.w600)),
                    ]),
                  )),
                  Container(width: 1, height: 16, color: border),
                  Expanded(child: GestureDetector(
                    onTap: onRetake,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.refresh_rounded,
                          color: textMuted, size: 14),
                      const SizedBox(width: 4),
                      Text('Retake', style: GoogleFonts.inter(
                          color: textMuted, fontSize: 11,
                          fontWeight: FontWeight.w600)),
                    ]),
                  )),
                ])
              : GestureDetector(
                  onTap: isCapturing ? null : onCapture,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.camera_alt_rounded,
                        color: isCapturing ? textMuted : navy,
                        size: 15),
                    const SizedBox(width: 5),
                    Text('Capture', style: GoogleFonts.inter(
                        color: isCapturing ? textMuted : navy,
                        fontSize: 12, fontWeight: FontWeight.w700)),
                  ]),
                ),
        ),
      ]),
    );
  }
}

// ── Photos bottom bar with Submit & Upload ────────────────────────────────────
class _PhotosBottomBar extends StatelessWidget {
  final String vehicleId;
  final int done, total;
  const _PhotosBottomBar(
      {required this.vehicleId, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final allDone = done == total;
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border))),
      child: allDone
          ? SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _submitAndUpload(context),
                icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                label: Text('Submit & Upload Photos',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white, elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              ))
          : Row(children: [
              const Icon(Icons.camera_alt_rounded,
                  color: textMuted, size: 16),
              const SizedBox(width: 8),
              Text('${total - done} photos remaining',
                  style: GoogleFonts.inter(
                      color: textMuted, fontSize: 12)),
            ]),
    );
  }

  Future<void> _submitAndUpload(BuildContext context) async {
    final prov = context.read<AppProvider>();
    final auth = context.read<AuthProvider>();
    final v = prov.vehicles.firstWhere((e) => e.id == vehicleId);

    debugPrint('[Submit] Vehicle: ' + v.regNo + '  Photos: ' + v.photos.length.toString());
    for (final e in v.photos.entries) {
      debugPrint('  [' + e.key.name + '] bytes=' + (e.value.bytes?.length.toString() ?? 'null') + '  path=' + e.value.path);
    }

    await showUploadDialog(
      context: context,
      title: 'Uploading Vehicle Photos',
      uploadFn: (onProgress) => UploadService.uploadVehiclePhotos(
        vehicle: v, config: auth.config, onProgress: onProgress,
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }
}
