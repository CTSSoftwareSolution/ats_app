import 'dart:io';

import 'package:flutter/material.dart';

import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';

/// Full-width image preview with pinch-to-zoom and a single close action.
class ImageDialogBox extends StatelessWidget {
  final String path;

  const ImageDialogBox({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(AppSpacing.page),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * 0.85, maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PreviewHeader(title: "Image preview", onClose: () => Navigator.pop(context)),
            Flexible(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _PreviewHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.xs, AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontFamily: "SemiBold", fontSize: 15, color: Colors.white),
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
