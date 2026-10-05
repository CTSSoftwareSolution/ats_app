import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';

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

  static const double _height = 180;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md - 1),
            child: imageFile != null
                ? Image.file(
              imageFile!,
              width: double.infinity,
              height: _height,
              fit: BoxFit.cover,
            )
                : Image.network(
              imageUrl!,
              width: double.infinity,
              height: _height,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: _height,
                  color: surface2,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: appColor,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: _height,
                color: surface2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.broken_image_rounded,
                        color: textMuted, size: 32),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Could not load image', style: AppText.caption),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReplace,
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: const Text('Replace'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRemove,
                style: OutlinedButton.styleFrom(
                  foregroundColor: fail,
                  side: BorderSide(color: fail.withValues(alpha: 0.4)),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Remove'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
