import 'package:ats_app/new_manual_flow/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../../widgets/new_app_ui/primary_button.dart';
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
  UploadProgress _progress = const UploadProgress(
    status: UploadStatus.uploading,
  );
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
            _scroll.animateTo(
              _scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final debugOn = context.watch<AuthProvider>().config.debugMode;
    final isDone =
        _progress.isComplete ||
        (_progress.total == 0 && _progress.status == UploadStatus.success);
    final isOk = _progress.status == UploadStatus.success;
    final noMedia = _progress.total == 0 && isDone;
    final entries = DebugService.entries;

    return PopScope(
      canPop: isDone,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.dialog,
          vertical: 40,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.dialog),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ─────────────────────────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDone ? (isOk ? passLight : failLight) : infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: isDone
                    ? Icon(
                        isOk
                            ? Icons.cloud_done_rounded
                            : Icons.cloud_off_rounded,
                        color: isOk ? pass : fail,
                        size: AppIconSize.xl - 4,
                      )
                    : const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: CircularProgressIndicator(
                          color: appColor,
                          strokeWidth: 3,
                        ),
                      ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Title ─────────────────────────────────────────────────
              Text(
                widget.title,
                style: AppText.dialogTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),

              // ── Status text ───────────────────────────────────────────
              Text(
                noMedia
                    ? 'No photos/videos captured for this step'
                    : isDone
                    ? isOk
                          ? 'All ${_progress.total} file(s) uploaded ✓'
                          : '${_progress.done} uploaded · ${_progress.failed} failed'
                    : 'Uploading ${_progress.done + 1} of ${_progress.total}...',
                style: AppText.bodySecondary,
                textAlign: TextAlign.center,
              ),

              if (!isDone && _progress.currentFile.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _progress.currentFile,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption,
                  textAlign: TextAlign.center,
                ),
              ],

              // ── Progress bar ──────────────────────────────────────────
              if (_progress.total > 0) ...[
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: LinearProgressIndicator(
                    value: _progress.percent,
                    minHeight: 6,
                    backgroundColor: surface2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _progress.failed > 0 ? fail : pass,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_progress.done}/${_progress.total}',
                      style: AppText.caption.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      '${(_progress.percent * 100).toStringAsFixed(0)}%',
                      style: AppText.caption.copyWith(
                        fontFamily: 'Bold',
                        color: appColor,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ],

              // ── Debug log (developer console, intentionally dark) ─────
              if (debugOn) ...[
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: () => setState(() => _showLog = !_showLog),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: primaryDark,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: pass.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.terminal_rounded,
                          color: passOnDark,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'API Log  (${entries.length} entries)',
                          style: const TextStyle(
                            color: passOnDark,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _showLog
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: passOnDark,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showLog) ...[
                  const SizedBox(height: 2),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: primaryDark,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.md),
                        bottomRight: Radius.circular(AppRadius.md),
                      ),
                      border: Border.all(
                        color: pass.withValues(alpha: 0.3),
                      ),
                    ),
                    child: entries.isEmpty
                        ? const Center(
                            child: Text(
                              'No log entries yet',
                              style: TextStyle(
                                color: textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.all(8),
                            itemCount: entries.length,
                            itemBuilder: (_, i) {
                              final e = entries[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.timeStr,
                                      style: const TextStyle(
                                        color: textMuted,
                                        fontSize: 8,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 45,
                                      ),
                                      child: Text(
                                        e.tag,
                                        style: TextStyle(
                                          color: e.color,
                                          fontSize: 9,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        e.message,
                                        style: const TextStyle(
                                          color: textWhiteSub,
                                          fontSize: 9,
                                          fontFamily: 'monospace',
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
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
                const SizedBox(height: AppSpacing.dialog),
                PrimaryButton(
                  label: isOk ? 'Continue' : 'OK',
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ],
          ),
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
