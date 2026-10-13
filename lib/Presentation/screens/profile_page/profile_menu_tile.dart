import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';

class ProfileMenuTile extends StatelessWidget {
  final String image;
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool destructive;
  final VoidCallback onTap;

  const ProfileMenuTile({super.key,
    required this.image,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.destructive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color tint = destructive ? fail : appColor;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: destructive ? failLight : accentLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: icon != null
                    ? Icon(icon, size: 20, color: tint)
                    : Image(
                  image: AssetImage(image),
                  width: 20,
                  height: 20,
                  color: tint,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppText.title.copyWith(
                        color: destructive ? fail : textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppText.caption.copyWith(color: textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}