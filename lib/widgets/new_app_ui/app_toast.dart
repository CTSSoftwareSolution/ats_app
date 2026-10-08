import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_layout.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_shadow.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

enum AppToastTone { info, success, error }

/// Passing confirmation or notice that needs no action ("Result updated",
/// "2 photos left to capture", "Couldn't update result"). Always an icon plus
/// text, never colour alone; one at a time; floats above bottom action bars.
///
/// For something the inspector must act on, use [AppBanner] in the page or
/// [AppStateView] for a whole area.
///
/// Returns the overlay entry (null for an empty message) so a caller can
/// dismiss the toast early.
OverlaySupportEntry? showAppToast(
  String message, {
  AppToastTone tone = AppToastTone.info,
}) {
  if (message.trim().isEmpty) return null;
  return showOverlay(
    (context, progress) => AppToast(
      message: message.trim(),
      tone: tone,
      progress: progress,
    ),
    // Same key: a new toast replaces the one on screen.
    key: const ValueKey('app-toast'),
    duration: tone == AppToastTone.error
        ? const Duration(seconds: 4)
        : const Duration(milliseconds: 2500),
  );
}

class AppToast extends StatelessWidget {
  final String message;
  final AppToastTone tone;

  /// 0 → 1 while appearing, 1 → 0 while leaving.
  final double progress;

  const AppToast({
    super.key,
    required this.message,
    this.tone = AppToastTone.info,
    this.progress = 1,
  });

  (Color, IconData) get _style => switch (tone) {
    AppToastTone.info => (textPrimary, Icons.info_outline_rounded),
    AppToastTone.success => (pass, Icons.check_circle_rounded),
    AppToastTone.error => (fail, Icons.error_outline_rounded),
  };

  @override
  Widget build(BuildContext context) {
    final (background, icon) = _style;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        // Clear of the bottom navigation / BottomActionBar.
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          bottomInset + 88,
        ),
        child: Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - progress) * 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.maxDialogWidth,
              ),
              child: Semantics(
                liveRegion: true,
                label: message,
                excludeSemantics: true,
                child: Material(
                  color: background,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: AppShadow.overlay,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, color: textWhite, size: AppIconSize.md),
                          const SizedBox(width: AppSpacing.md),
                          Flexible(
                            child: Text(
                              message,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.label.copyWith(color: textWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
