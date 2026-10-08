import 'dart:io';
import 'package:ats_app/new_manual_flow/app_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../../widgets/new_app_ui/status_badge.dart';

import '../new_model/inspection_model.dart';

// ── Safe image helper ─────────────────────────────────────────────────────────
Widget _safeImage(MediaFile m, {BoxFit fit = BoxFit.cover}) {
  if (m.bytes != null && m.bytes!.isNotEmpty) {
    return Image.memory(m.bytes!, fit: fit, errorBuilder: (_, __, ___) => _ph());
  }
  if (!kIsWeb && m.path.isNotEmpty && m.path != 'memory') {
    return Image.file(
      File(m.path),
      fit: fit,
      errorBuilder: (_, __, ___) => _ph(),
    );
  }
  return _ph();
}

Widget _ph() => Container(
  color: surface2,
  child: const Center(
    child: Icon(
      Icons.image_not_supported_rounded,
      color: textMuted,
      size: AppIconSize.md,
    ),
  ),
);

// ── Compact media section ─────────────────────────────────────────────────────
// Respects:
//   item.photoVideoFlag  1=photo only  2=video only  3=both
//   item.allowMultiple   false=only one capture allowed
class MediaPickerSection extends StatefulWidget {
  final String vehicleId;
  final InspectionItem item;
  const MediaPickerSection({
    super.key,
    required this.vehicleId,
    required this.item,
  });
  @override
  State<MediaPickerSection> createState() => _MediaState();
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

  void _view(int idx) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          MediaViewerScreen(mediaList: widget.item.media, initialIndex: idx),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final media = widget.item.media;
    final flag = widget.item.photoVideoFlag; // 1=photo 2=video 3=both
    final allowMulti = widget.item.allowMultiple;
    final hasMedia = media.isNotEmpty;

    // Whether capture buttons are shown
    // If allowMultiple=false and already captured one → hide buttons
    final canCaptureMore = allowMulti || !hasMedia;
    final showPhoto = canCaptureMore && (flag == 1 || flag == 3);
    final showVideo = canCaptureMore && (flag == 2 || flag == 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Thumbnails ──────────────────────────────────────────────
          if (hasMedia) ...[
            ...media
                .take(4)
                .map(
                  (m) => GestureDetector(
                    onTap: () => _view(media.indexOf(m)),
                    onLongPress: () => _delete(m.id),
                    child: Container(
                      key: ValueKey(m.id),
                      margin: const EdgeInsets.only(right: AppSpacing.xs),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm - 1),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            m.type == MediaType.photo
                                ? _safeImage(m)
                                : _VidThumb(path: m.path),
                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: Icon(
                                m.type == MediaType.video
                                    ? Icons.play_circle_filled_rounded
                                    : Icons.location_on_rounded,
                                color: textWhite,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            // Overflow badge
            if (media.length > 4)
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.xs + 2),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: border),
                ),
                child: Center(
                  child: Text(
                    '+${media.length - 4}',
                    style: AppText.badge.copyWith(color: appColor),
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.xs),
          ],

          // ── Busy spinner ────────────────────────────────────────────
          if (_busy) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: appColor,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Capturing...', style: AppText.caption),

            // ── Capture buttons (respects flags) ───────────────────────
          ] else if (showPhoto || showVideo) ...[
            if (showPhoto) ...[
              _MicroBtn(
                icon: Icons.photo_camera_rounded,
                color: appColor,
                onTap: _photo,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            if (showVideo) ...[
              _MicroBtn(
                icon: Icons.videocam_rounded,
                color: appColor,
                onTap: _video,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            if (hasMedia)
              const Flexible(
                child: Text(
                  'Long press to delete',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption,
                ),
              ),

            // ── Already captured, no more allowed ──────────────────────
          ] else if (!allowMulti && hasMedia) ...[
            const StatusBadge.captured(dense: true),
            const SizedBox(width: AppSpacing.sm),
            const Flexible(
              child: Text(
                'Long press to delete',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption,
              ),
            ),

            // ── No media flag set (flag=0) ──────────────────────────────
          ] else ...[
            const Text('No media required', style: AppText.caption),
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
  const _MicroBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: AppSpacing.compactHeight,
      height: AppSpacing.compactHeight,
      decoration: BoxDecoration(
        color: accentLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Icon(icon, color: color, size: AppIconSize.md),
    ),
  );
}

// ── Video thumbnail ───────────────────────────────────────────────────────────
class _VidThumb extends StatelessWidget {
  final String path;
  const _VidThumb({required this.path});
  @override
  Widget build(BuildContext context) => Container(
    color: primaryDark,
    child: const Center(
      child: Icon(
        Icons.play_circle_fill_rounded,
        color: textWhite,
        size: AppIconSize.md,
      ),
    ),
  );
}

// ── Full-screen media viewer ──────────────────────────────────────────────────
class MediaViewerScreen extends StatefulWidget {
  final List<MediaFile> mediaList;
  final int initialIndex;
  const MediaViewerScreen({
    super.key,
    required this.mediaList,
    required this.initialIndex,
  });
  @override
  State<MediaViewerScreen> createState() => _VS();
}

class _VS extends State<MediaViewerScreen> {
  late final PageController _pc;
  late int _cur;

  @override
  void initState() {
    super.initState();
    _cur = widget.initialIndex;
    _pc = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mediaList[_cur];
    // Full-screen media viewer: stays black so photos read true.
    return Scaffold(
      backgroundColor: mediaBg,
      appBar: AppBar(
        backgroundColor: mediaBg,
        foregroundColor: textWhite,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded, color: textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_cur + 1} / ${widget.mediaList.length}',
          style: AppText.titleOnDark.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + 2,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: textWhite.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              m.type == MediaType.photo ? '📷 Photo' : '🎬 Video',
              style: AppText.badge.copyWith(color: textWhite),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pc,
              itemCount: widget.mediaList.length,
              onPageChanged: (i) => setState(() => _cur = i),
              itemBuilder: (_, i) {
                final med = widget.mediaList[i];
                return med.type == MediaType.photo
                    ? InteractiveViewer(
                        child: Center(
                          child: _safeImage(med, fit: BoxFit.contain),
                        ),
                      )
                    : _VideoPage(media: med);
              },
            ),
          ),

          // GPS info bar
          Container(
            color: primaryDark,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              MediaQuery.of(context).padding.bottom + AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: textWhiteSub,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Text(
                      m.geoTag.coordString,
                      style: AppText.chip.copyWith(
                        color: textWhite,
                        fontSize: 12,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  m.geoTag.address,
                  style: AppText.caption.copyWith(color: textWhiteSub),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  m.geoTag.formattedDate,
                  style: AppText.caption.copyWith(
                    fontSize: 11,
                    color: textWhiteSub,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Video player page ─────────────────────────────────────────────────────────
class _VideoPage extends StatefulWidget {
  final MediaFile media;
  const _VideoPage({required this.media});
  @override
  State<_VideoPage> createState() => _VPS();
}

class _VPS extends State<_VideoPage> {
  VideoPlayerController? _c;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb &&
        widget.media.path.isNotEmpty &&
        widget.media.path != 'memory') {
      _c = VideoPlayerController.file(File(widget.media.path))
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() => _ready = true);
                _c!.play();
              }
            })
            .catchError((_) {});
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _c == null) {
      return const Center(child: CircularProgressIndicator(color: textWhite));
    }
    return GestureDetector(
      onTap: () =>
          setState(() => _c!.value.isPlaying ? _c!.pause() : _c!.play()),
      child: Center(
        child: AspectRatio(
          aspectRatio: _c!.value.aspectRatio,
          child: VideoPlayer(_c!),
        ),
      ),
    );
  }
}
