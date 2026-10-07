import 'package:flutter/material.dart';
import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Opens a modal bottom sheet with the app's standard options: full-height
/// capable (keyboard-safe), transparent route background so [AppBottomSheet]
/// draws the rounded surface, themed scrim.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: builder,
  );
}

/// Standard bottom sheet surface: drag handle, optional title / subtitle,
/// scrollable content that stays above the keyboard. Pass [onClose] to show
/// a close button beside the title (null while closing is not allowed).
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onClose;
  final bool showClose;

  const AppBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.onClose,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
        decoration: const BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.dialog,
            AppSpacing.md,
            AppSpacing.dialog,
            AppSpacing.dialog + media.padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              SizedBox(height: showClose ? AppSpacing.xs : AppSpacing.lg),
              if (title != null)
                showClose
                    ? Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              header: true,
                              child: Text(title!, style: AppText.sectionTitle),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: onClose,
                            icon: const Icon(
                              Icons.close_rounded,
                              size: AppIconSize.md,
                            ),
                          ),
                        ],
                      )
                    : Text(title!, style: AppText.sectionTitle),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: AppText.bodySecondary),
              ],
              if (title != null || subtitle != null)
                const SizedBox(height: AppSpacing.lg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
