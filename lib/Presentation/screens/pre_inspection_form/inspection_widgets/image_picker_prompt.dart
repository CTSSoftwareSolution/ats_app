
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
    return Material(
      color: boxColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor!, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor?.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_a_photo_rounded, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Evidence Photo',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14,
                        fontFamily: "Bold",
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Required for items marked "No". Tap to open camera.',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}
