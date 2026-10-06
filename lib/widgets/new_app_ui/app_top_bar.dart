import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import 'app_back_button.dart';

/// Standard brand app bar for every screen.
///
/// * Pushed screens pass [onBack] and get the shared back button; tab roots
///   omit it and the title lines up with the page gutter.
/// * Optional [subtitle] for context (e.g. a vehicle number) under the title.
/// Colours, height and title style come from the theme.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleWidget = subtitle == null
        ? Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(color: textWhiteSub),
              ),
            ],
          );

    return AppBar(
      automaticallyImplyLeading: false,
      leading: onBack == null ? null : AppBackButton(onPressed: onBack!),
      titleSpacing: onBack == null ? AppSpacing.page : 0,
      title: Semantics(header: true, child: titleWidget),
      actions: actions == null
          ? null
          : [...actions!, const SizedBox(width: AppSpacing.xs)],
    );
  }
}
