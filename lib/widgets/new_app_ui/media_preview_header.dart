import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';

/// Title row with a close button for the dark image / video preview dialogs.
class MediaPreviewHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const MediaPreviewHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.titleOnDark,
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: textWhite),
          ),
        ],
      ),
    );
  }
}
