import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/new_app_theme/app_radius.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';

/// Compact brand header for the Home tab: logo, then a greeting with the
/// signed-in inspector's name and today's date, and the centre location.
class BuildHeaderHome extends StatelessWidget {
  const BuildHeaderHome({super.key});

  /// Preferences values are stored with toString(), so a missing value can
  /// come back as "null".
  static String _pref(Object? value) {
    final text = (value ?? '').toString().trim();
    return text == 'null' ? '' : text;
  }

  @override
  Widget build(BuildContext context) {
    final location = _pref(Preferences.getLocation());
    final name = _pref(Preferences.getName());
    final firstName = name.split(RegExp(r'\s+')).first;

    return Container(
      width: double.infinity,
      color: appColor,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            image: true,
            label: 'Logo',
            child: CustomImage(image: lmsLogo, height: 30, fit: BoxFit.contain),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName.isEmpty ? 'Welcome' : 'Hello, $firstName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sectionTitle.copyWith(color: textWhite),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      DateFormat('EEEE, d MMM').format(DateTime.now()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: textWhiteSub),
                    ),
                  ],
                ),
              ),
              if (location.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.md),
                // Never wider than half the header so the greeting stays readable.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.5,
                  ),
                  child: _LocationPill(location: location),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  final String location;

  const _LocationPill({required this.location});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Location: $location',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: textWhite.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: textWhiteSub,
              size: AppIconSize.sm,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.tag.copyWith(color: textWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
