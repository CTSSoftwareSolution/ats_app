import 'package:flutter/material.dart';

import '../../utilities/color_data.dart';
import '../../utilities/new_app_theme/app_text.dart';

class MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const MetaRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.chip.copyWith(color: textSecondary),
          ),
        ),
      ],
    );
  }
}