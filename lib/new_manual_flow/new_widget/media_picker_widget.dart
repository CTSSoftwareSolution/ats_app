import 'dart:io';
import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../utilities/color_data.dart';

import '../new_model/inspection_model.dart';


// ── Safe image helper ─────────────────────────────────────────────────────────
Widget _safeImage(MediaFile m, {BoxFit fit = BoxFit.cover}) {
  if (m.bytes != null && m.bytes!.isNotEmpty) {
    return Image.memory(m.bytes!, fit: fit,
        errorBuilder: (_, __, ___) => _ph());
  }
  if (!kIsWeb && m.path.isNotEmpty && m.path != 'memory') {
    return Image.file(File(m.path), fit: fit,
        errorBuilder: (_, __, ___) => _ph());
  }
  return _ph();
}

Widget _ph() => Container(
    color: surface2,
    child: const Center(child: Icon(Icons.image_not_supported_rounded,
        color: textMuted, size: 20)));

// ── Compact media section ─────────────────────────────────────────────────────
// Respects:
//   item.photoVideoFlag  1=photo only  2=video only  3=both
//   item.allowMultiple   false=only one capture allowed
class MediaPickerSection extends StatefulWidget {
  final String vehicleId;
  final InspectionItem item;
  const MediaPickerSection({super.key,
      required this.vehicleId, required this.item});
  @override State<MediaPickerSection> createState() => _MediaState();
}

class _MediaState extends State<MediaPickerSection> {
  bool _busy = false;

  // ── Capture helpers ───────────────────────────────────────────────────────
  Future<void> _photo() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final p = context.read<AppProvider>();
      final v = p.vehicles.firstWhere((e) => e.id == widget.vehicleId);
      await p.captureEvidencePhoto(v, widget.item);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _video() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final p = context.read<AppProvider>();
      final v = p.vehicles.firstWhere((e) => e.id == widget.vehicleId);
      await p.captureEvidenceVideo(v, widget.item);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _delete(String id) {
    context.read<AppProvider>().removeMedia(widget.item, id);
    setState(() {});
  }

  void _view(int idx) => Navigator.push(context, MaterialPageRoute(
      builder: (_) => MediaViewerScreen(
          mediaList: widget.item.media, initialIndex: idx)));

  @override
  Widget build(BuildContext context) {
    final media      = widget.item.media;
    final flag       = widget.item.photoVideoFlag; // 1=photo 2=video 3=both
    final allowMulti = widget.item.allowMultiple;
    final hasMedia   = media.isNotEmpty;

    // Whether capture buttons are shown
    // If allowMultiple=false and already captured one → hide buttons
    final canCaptureMore = allowMulti || !hasMedia;
    final showPhoto = canCaptureMore && (flag == 1 || flag == 3);
    final showVideo = canCaptureMore && (flag == 2 || flag == 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Thumbnails ──────────────────────────────────────────────
          if (hasMedia) ...[
            ...media.take(4).map((m) => GestureDetector(
              onTap:      () => _view(media.indexOf(m)),
              onLongPress: () => _delete(m.id),
              child: Container(
                key: ValueKey(m.id),
                margin: const EdgeInsets.only(right: 4),
                width: 44, height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: border)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(fit: StackFit.expand, children: [
                    m.type == MediaType.photo
                        ? _safeImage(m)
                        : _VidThumb(path: m.path),
                    Positioned(bottom: 1, right: 1,
                      child: Icon(
                        m.type == MediaType.video
                            ? Icons.play_circle_filled_rounded
                            : Icons.location_on_rounded,
                        color: Colors.white, size: 10)),
                  ]),
                ),
              ),
            )),
            // Overflow badge
            if (media.length > 4)
              Container(
                margin: const EdgeInsets.only(right: 6),
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: border)),
                child: Center(child: Text('+${media.length - 4}',
                    style: GoogleFonts.inter(
                        color: navyAccent,
                        fontSize: 10, fontWeight: FontWeight.w700)))),
            const SizedBox(width: 4),
          ],

          // ── Busy spinner ────────────────────────────────────────────
          if (_busy) ...[
            const SizedBox(width: 14, height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: navyAccent)),
            const SizedBox(width: 6),
            Text('Capturing...', style: GoogleFonts.inter(
                color: textMuted, fontSize: 10)),

          // ── Capture buttons (respects flags) ───────────────────────
          ] else if (showPhoto || showVideo) ...[
            if (showPhoto) ...[
              _MicroBtn(
                icon: Icons.camera_alt_rounded,
                color: navy,
                onTap: _photo),
              const SizedBox(width: 4),
            ],
            if (showVideo) ...[
              _MicroBtn(
                icon: Icons.videocam_rounded,
                color: pass,
                onTap: _video),
              const SizedBox(width: 4),
            ],
            if (hasMedia)
              Text('Long press to delete',
                  style: GoogleFonts.inter(
                      color: textMuted, fontSize: 9)),

          // ── Already captured, no more allowed ──────────────────────
          ] else if (!allowMulti && hasMedia) ...[
            const Icon(Icons.check_circle_rounded,
                color: pass, size: 14),
            const SizedBox(width: 4),
            Text('Captured', style: GoogleFonts.inter(
                color: pass, fontSize: 10,
                fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Text('Long press to delete',
                style: GoogleFonts.inter(
                    color: textMuted, fontSize: 9)),

          // ── No media flag set (flag=0) ──────────────────────────────
          ] else ...[
            Text('No media required',
                style: GoogleFonts.inter(
                    color: textMuted, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}

// ── Micro icon button ─────────────────────────────────────────────────────────
class _MicroBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MicroBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35))),
      child: Icon(icon, color: color, size: 16)),
  );
}

// ── Video thumbnail ───────────────────────────────────────────────────────────
class _VidThumb extends StatelessWidget {
  final String path;
  const _VidThumb({required this.path});
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF1A1A2E),
    child: const Center(child: Icon(Icons.play_circle_fill_rounded,
        color: Colors.greenAccent, size: 20)));
}

// ── Full-screen media viewer ──────────────────────────────────────────────────
class MediaViewerScreen extends StatefulWidget {
  final List<MediaFile> mediaList;
  final int initialIndex;
  const MediaViewerScreen({super.key,
      required this.mediaList, required this.initialIndex});
  @override State<MediaViewerScreen> createState() => _VS();
}

class _VS extends State<MediaViewerScreen> {
  late final PageController _pc;
  late int _cur;

  @override
  void initState() {
    super.initState();
    _cur = widget.initialIndex;
    _pc  = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() { _pc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final m = widget.mediaList[_cur];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text('${_cur + 1} / ${widget.mediaList.length}',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: m.type == MediaType.photo
                  ? navyAccent.withOpacity(0.7)
                  : pass.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16)),
            child: Text(
              m.type == MediaType.photo ? '📷 Photo' : '🎬 Video',
              style: GoogleFonts.inter(color: Colors.white,
                  fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: PageView.builder(
          controller: _pc,
          itemCount: widget.mediaList.length,
          onPageChanged: (i) => setState(() => _cur = i),
          itemBuilder: (_, i) {
            final med = widget.mediaList[i];
            return med.type == MediaType.photo
                ? InteractiveViewer(
                    child: Center(child: _safeImage(med, fit: BoxFit.contain)))
                : _VideoPage(media: med);
          },
        )),

        // GPS info bar
        Container(
          color: const Color(0xFF111827),
          padding: EdgeInsets.fromLTRB(
              16, 10, 16, MediaQuery.of(context).padding.bottom + 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.location_on_rounded,
                    color: Colors.lightBlueAccent, size: 12),
                const SizedBox(width: 5),
                Text(m.geoTag.coordString,
                    style: GoogleFonts.robotoMono(
                        color: Colors.white, fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 2),
              Text(m.geoTag.address,
                  style: GoogleFonts.inter(
                      color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 2),
              Text(m.geoTag.formattedDate,
                  style: GoogleFonts.robotoMono(
                      color: Colors.white38, fontSize: 9)),
            ],
          ),
        ),
      ]),
    );
  }
}

// ── Video player page ─────────────────────────────────────────────────────────
class _VideoPage extends StatefulWidget {
  final MediaFile media;
  const _VideoPage({required this.media});
  @override State<_VideoPage> createState() => _VPS();
}

class _VPS extends State<_VideoPage> {
  VideoPlayerController? _c;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && widget.media.path.isNotEmpty &&
        widget.media.path != 'memory') {
      _c = VideoPlayerController.file(File(widget.media.path))
        ..initialize().then((_) {
          if (mounted) { setState(() => _ready = true); _c!.play(); }
        }).catchError((_) {});
    }
  }

  @override
  void dispose() { _c?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _c == null) {
      return const Center(child: CircularProgressIndicator(
          color: Colors.white));
    }
    return GestureDetector(
      onTap: () => setState(() =>
          _c!.value.isPlaying ? _c!.pause() : _c!.play()),
      child: Center(child: AspectRatio(
          aspectRatio: _c!.value.aspectRatio,
          child: VideoPlayer(_c!))),
    );
  }
}
