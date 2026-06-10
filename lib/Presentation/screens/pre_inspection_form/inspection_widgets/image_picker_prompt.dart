
import 'package:flutter/material.dart';

class ImagePickerPrompt extends StatelessWidget {
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? boxColor;
  const ImagePickerPrompt({super.key, required this.onTap, this.titleColor, this.subtitleColor, this.iconColor, this.borderColor, this.boxColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo_rounded,
                color: iconColor,
                size: 28),
            const SizedBox(height: 6),
            Text(
              'Add Evidence Photo',
              style: TextStyle(
                color: titleColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap to capture or upload from gallery',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}