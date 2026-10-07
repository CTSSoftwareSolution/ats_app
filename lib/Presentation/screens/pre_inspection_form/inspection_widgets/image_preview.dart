import '../../../../widgets/new_app_ui/app_spinner.dart';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/status_badge.dart';

/// Attached evidence photo: a compact thumbnail with its state and the
/// Replace / Remove actions beside it, so a failed check stays short.
class ImagePreview extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onRemove;
  final VoidCallback onReplace;

  const ImagePreview({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onRemove,
    required this.onReplace,
  }) : assert(imageFile != null || imageUrl != null,
  'Either imageFile or imageUrl must be provided');

  static const double _size = 88;

  @override
  Widget build(BuildContext context) {
    final thumbnail = imageFile != null
        ? Image.file(
            imageFile!,
            width: _size,
            height: _size,
            fit: BoxFit.cover,
            cacheWidth: 264,
          )
        : Image.network(
            imageUrl!,
            width: _size,
            height: _size,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ColoredBox(
                color: surface2,
                child: Center(
                  child: AppSpinner.small(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    semanticsLabel: 'Loading photo',
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: surface2,
              child: Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: na,
                  size: AppIconSize.lg,
                ),
              ),
            ),
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md - 1),
            child: Semantics(
              image: true,
              label: 'Evidence photo',
              child: thumbnail,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge.completed(
                label: imageFile != null ? 'Photo attached' : 'Saved photo',
                dense: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                children: [
                  TextButton.icon(
                    onPressed: onReplace,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      textStyle: AppText.buttonCompact,
                    ),
                    icon: const Icon(
                      Icons.photo_camera_outlined,
                      size: AppIconSize.md,
                    ),
                    label: const Text('Replace'),
                  ),
                  TextButton.icon(
                    onPressed: onRemove,
                    style: TextButton.styleFrom(
                      foregroundColor: fail,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      textStyle: AppText.buttonCompact,
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: AppIconSize.md,
                    ),
                    label: const Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
