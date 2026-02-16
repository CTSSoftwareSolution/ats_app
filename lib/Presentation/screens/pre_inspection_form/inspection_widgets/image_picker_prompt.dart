
import 'package:flutter/material.dart';

class ImagePickerPrompt extends StatelessWidget {
  final VoidCallback onTap;
  const ImagePickerPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.red.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo_rounded,
                color: Colors.red.shade400, size: 28),
            const SizedBox(height: 6),
            Text(
              'Add Evidence Photo',
              style: TextStyle(
                color: Colors.red.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap to capture or upload from gallery',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}