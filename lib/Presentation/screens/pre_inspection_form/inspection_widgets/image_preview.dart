import 'dart:io';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageFile != null
              ? Image.file(
            imageFile!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          )
              : Image.network(
            imageUrl!,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: 160,
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: Colors.grey.shade500,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image_rounded,
                      color: Colors.grey.shade400, size: 36),
                  const SizedBox(height: 6),
                  Text('Could not load image',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha:0.7),
                  Colors.transparent,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onReplace,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Replace',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_rounded,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}