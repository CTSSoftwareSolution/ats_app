import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/app_progress_bar.dart';
import '../../../widgets/new_app_ui/appointment_time.dart';
import '../../../widgets/new_app_ui/registration_plate.dart';
import '../home_pages/home_widgets/appointment_status.dart';

/// Compact appointment card for the Home list.
///
///   [PLATE]                     [In progress]
///   Maruti Suzuki Swift · 2019        10:30
///   LMV · Petrol                     06 Oct
///   Booking ID BKG-0001
///   ───────────────────────────────────────
///   Manual [Pass]    AI [Pending]
///   ▰▰▰▰▰▰▰▱▱▱▱▱▱▱  1/2          [Continue →]
///
/// The whole card and the action button trigger [onTap]. [highlighted]
/// outlines the card in the brand colour (used for the current inspection).
class VehicleClassScreenItem extends StatelessWidget {
  final Appointments classDataModel;
  final VoidCallback onTap;
  final bool highlighted;

  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
    this.highlighted = false,
  });

  /// Hides "null"/empty values coming from the API.
  static String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  @override
  Widget build(BuildContext context) {
    final item = classDataModel;
    final status = AppointmentStatus(item);
    final regNo = _text(item.registrationNo).isNotEmpty
        ? _text(item.registrationNo)
        : _text(item.regNo);
    final bookingId = _text(item.bookingId);

    // "Maruti Suzuki Swift · 2019" – built only from the fields present.
    final vehicleName = [
      _text(item.make),
      _text(item.model),
    ].where((s) => s.isNotEmpty).join(' ');
    final title = [
      vehicleName,
      _text(item.mfgYear),
    ].where((s) => s.isNotEmpty).join(' · ');

    // "LMV · LMV-NT · Petrol" – category only when it adds something.
    final vehicleClass = _text(item.vehicleClass);
    final category = _text(item.vehicleCategory);
    final meta = [
      vehicleClass,
      if (category != vehicleClass) category,
      _text(item.fuelType),
    ].where((s) => s.isNotEmpty).join(' · ');

    final Color? borderColor = highlighted
        ? appColor.withValues(alpha: 0.45)
        : status.hasFailure
        ? fail.withValues(alpha: 0.35)
        : null;

    return Semantics(
      button: true,
      label: [
        regNo.isEmpty ? 'Appointment' : 'Appointment $regNo',
        status.badge().label,
        status.progressLabel,
        'Open inspection',
      ].join('. '),
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        borderColor: borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.card,
                AppSpacing.card,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Registration + overall status
                  Row(
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RegistrationPlate(
                            number: regNo.isEmpty ? '—' : regNo,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      status.badge(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Vehicle details + appointment time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.isEmpty ? 'Vehicle details unavailable' : title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: title.isEmpty
                                  ? AppText.title.copyWith(color: na)
                                  : AppText.title,
                            ),
                            if (meta.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              _MetaLine(
                                icon: Icons.directions_car_outlined,
                                text: meta,
                                style: AppText.bodySecondary,
                              ),
                            ],
                            if (bookingId.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xxs),
                              _MetaLine(
                                icon: Icons.confirmation_number_outlined,
                                text: 'Booking ID $bookingId',
                                style: AppText.caption,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppointmentTime(raw: _text(item.appointmentDate)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stage results (Manual / AI), full width so long API
                  // statuses have room.
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final stage in status.stages)
                          _StageResult(stage: stage),
                      ],
                    ),
                  ),
                  // Stage progress + action
                  Row(
                    children: [
                      // The bar gives way first so the action button never
                      // gets squeezed; the "1/2" counter shows when it fits.
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final bar = AppProgressBar(
                              value: status.progress,
                              color: status.hasFailure ? fail : null,
                            );
                            if (constraints.maxWidth < 96) return bar;
                            return Row(
                              children: [
                                Expanded(child: bar),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  '${status.finishedCount}/${status.total}',
                                  style: AppText.caption.copyWith(
                                    fontFeatures: AppText.tabular,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _ActionButton(
                        label: status.actionLabel,
                        icon: status.actionIcon,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One line of vehicle metadata with a small leading icon.
class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;

  const _MetaLine({required this.icon, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.xs, color: na),
        const SizedBox(width: AppSpacing.iconGap),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

/// "Manual [Pass]" – a stage name next to its result badge.
class _StageResult extends StatelessWidget {
  final InspectionStage stage;

  const _StageResult({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(stage.label, style: AppText.caption),
        const SizedBox(width: AppSpacing.iconGap),
        Flexible(child: stage.badge()),
      ],
    );
  }
}

/// Compact tonal action; same action as tapping the card, so it is hidden
/// from screen readers (the card already announces it).
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FilledButton.tonal(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: accentLight,
          foregroundColor: appColor,
          minimumSize: const Size(0, AppSpacing.compactHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: AppText.buttonCompact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: AppSpacing.xs),
            Icon(icon, size: AppIconSize.sm + 2),
          ],
        ),
      ),
    );
  }
}
