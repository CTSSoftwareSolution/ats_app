import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/media_preview_header.dart';

/// Full-width image preview with pinch-to-zoom and a single close action.
class ImageDialogBox extends StatelessWidget {
  final String path;

  /// Header text, e.g. "Front bumper · Photo".
  final String title;

  const ImageDialogBox({
    super.key,
    required this.path,
    this.title = 'Image preview',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: mediaBg,
      insetPadding: const EdgeInsets.all(AppSpacing.page),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
          maxWidth: 560,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MediaPreviewHeader(
              title: title,
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => SizedBox(
                    height: 220,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.broken_image_outlined,
                            color: textWhiteSub,
                            size: 32,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            "This image can't be displayed",
                            style: AppText.bodySecondary.copyWith(
                              color: textWhiteSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
