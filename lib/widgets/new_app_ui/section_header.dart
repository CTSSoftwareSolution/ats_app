import 'package:flutter/material.dart';

import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// UPPERCASE overline label that introduces a group of content
/// ("SETTINGS", "CATEGORY", "REMARK"). Optional [trailing] for a count or
/// small action aligned to the right.
class SectionHeader extends StatelessWidget {
  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const SectionHeader(
    this.text, {
    super.key,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: AppSpacing.sm),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Semantics(
        header: true,
        child: Row(
          children: [
            Expanded(child: Text(text.toUpperCase(), style: AppText.overline)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
