import 'package:ats_app/new_manual_flow/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utilities/color_data.dart';
import '../new_services/debug_service.dart';
import '../new_services/upload_service.dart';


class UploadProgressDialog extends StatefulWidget {
  final String title;
  final Future<UploadProgress> Function(Function(UploadProgress)) uploadFn;

  const UploadProgressDialog({
    super.key,
    required this.title,
    required this.uploadFn,
  });

  @override
  State<UploadProgressDialog> createState() => _State();
}

class _State extends State<UploadProgressDialog> {
  UploadProgress _progress =
      const UploadProgress(status: UploadStatus.uploading);
  bool _started = false;
  bool _showLog = true;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start upload after first frame so context is available
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_started || !mounted) return;
    _started = true;

    // Ensure debug mode is synced
    final debugOn = context.read<AuthProvider>().config.debugMode;
    DebugService.setEnabled(debugOn);

    await widget.uploadFn((p) {
      if (mounted) {
        setState(() => _progress = p);
        // Auto-scroll log to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) {
            _scroll.animateTo(_scroll.position.maxScrollExtent,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final debugOn = context.watch<AuthProvider>().config.debugMode;
    final isDone  = _progress.isComplete ||
        (_progress.total == 0 && _progress.status == UploadStatus.success);
    final isOk    = _progress.status == UploadStatus.success;
    final noMedia = _progress.total == 0 && isDone;
    final entries = DebugService.entries;

    return PopScope(
      canPop: isDone,
      child: Dialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            // ── Icon ─────────────────────────────────────────────────
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: isDone
                    ? (isOk ? passLight : failLight)
                    : accentLight,
                shape: BoxShape.circle),
              child: isDone
                  ? Icon(
                      isOk
                          ? Icons.cloud_done_rounded
                          : Icons.cloud_off_rounded,
                      color: isOk ? pass : fail,
                      size: 30)
                  : const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                          color: navyAccent, strokeWidth: 3)),
            ),
            const SizedBox(height: 14),

            // ── Title ─────────────────────────────────────────────────
            Text(widget.title, style: GoogleFonts.inter(
                color: textPrimary, fontSize: 15,
                fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),

            // ── Status text ───────────────────────────────────────────
            Text(
              noMedia
                  ? 'No photos/videos captured for this step'
                  : isDone
                      ? isOk
                          ? 'All ${_progress.total} file(s) uploaded ✓'
                          : '${_progress.done} uploaded · ${_progress.failed} failed'
                      : 'Uploading ${_progress.done + 1} of ${_progress.total}...',
              style: GoogleFonts.inter(
                  color: textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),

            if (!isDone && _progress.currentFile.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(_progress.currentFile,
                  style: GoogleFonts.robotoMono(
                      color: textMuted, fontSize: 10),
                  textAlign: TextAlign.center),
            ],

            // ── Progress bar ──────────────────────────────────────────
            if (_progress.total > 0) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress.percent, minHeight: 8,
                  backgroundColor: border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progress.failed > 0
                        ? fail : pass),
                ),
              ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text('${_progress.done}/${_progress.total}',
                    style: GoogleFonts.inter(
                        color: textMuted, fontSize: 11)),
                Text(
                    '${(_progress.percent * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.inter(
                        color: navyAccent, fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ]),
            ],

            // ── Debug log ─────────────────────────────────────────────
            if (debugOn) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _showLog = !_showLog),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.5))),
                  child: Row(children: [
                    const Icon(Icons.terminal_rounded,
                        color: Colors.greenAccent, size: 13),
                    const SizedBox(width: 6),
                    Text(
                      'API Log  (${entries.length} entries)',
                      style: GoogleFonts.robotoMono(
                          color: Colors.greenAccent, fontSize: 10)),
                    const Spacer(),
                    Icon(
                      _showLog
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: Colors.greenAccent, size: 16),
                  ]),
                ),
              ),
              if (_showLog) ...[
                const SizedBox(height: 2),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.3))),
                  child: entries.isEmpty
                      ? Center(child: Text('No log entries yet',
                          style: GoogleFonts.robotoMono(
                              color: Colors.white38, fontSize: 10)))
                      : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.all(8),
                          itemCount: entries.length,
                          itemBuilder: (_, i) {
                            final e = entries[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(e.timeStr,
                                      style: TextStyle(
                                          color: Colors.white24,
                                          fontSize: 8,
                                          fontFamily: 'monospace')),
                                  const SizedBox(width: 4),
                                  Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 45),
                                    child: Text(e.tag,
                                        style: TextStyle(
                                            color: e.color,
                                            fontSize: 9,
                                            fontFamily: 'monospace',
                                            fontWeight:
                                                FontWeight.bold))),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(e.message,
                                      style: const TextStyle(
                                          color: Color(0xFFCBD5E1),
                                          fontSize: 9,
                                          fontFamily: 'monospace',
                                          height: 1.4))),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ],

            // ── Continue button ───────────────────────────────────────
            if (isDone) ...[
              const SizedBox(height: 20),
              SizedBox(width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                  child: Text(isOk ? 'Continue' : 'OK',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

Future<bool> showUploadDialog({
  required BuildContext context,
  required String title,
  required Future<UploadProgress> Function(Function(UploadProgress)) uploadFn,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => UploadProgressDialog(title: title, uploadFn: uploadFn),
  );
  return result == true;
}
