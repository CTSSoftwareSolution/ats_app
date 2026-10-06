import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/info_chip.dart';
import '../../../widgets/new_app_ui/registration_plate.dart';
import '../../../widgets/new_app_ui/status_badge.dart';

/// Appointment card shown in the Home list.
///
/// Layout (top to bottom): registration + appointment time, vehicle name and
/// booking ID, attribute chips, then the inspection stages with the
/// "Inspect" action. The whole card and the button trigger [onTap].
class VehicleClassScreenItem extends StatelessWidget {
  final Appointments classDataModel;
  final VoidCallback onTap;

  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
  });

  /// Hides "null"/empty values coming from the API.
  static String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  @override
  Widget build(BuildContext context) {
    final item = classDataModel;
    final regNo = _text(item.registrationNo).isNotEmpty
        ? _text(item.registrationNo)
        : _text(item.regNo);
    final bookingId = _text(item.bookingId);
    final rawDate = _text(item.appointmentDate);
    final hasDate = DateTime.tryParse(rawDate) != null;

    // "Maruti Suzuki Swift · 2019" – built only from the fields present.
    final vehicleName = [_text(item.make), _text(item.model)]
        .where((s) => s.isNotEmpty)
        .join(' ');
    final year = _text(item.mfgYear);
    final title = [vehicleName, year].where((s) => s.isNotEmpty).join(' · ');

    final chips = <Widget>[
      if (_text(item.vehicleClass).isNotEmpty)
        InfoChip(icon: Icons.tag_rounded, label: _text(item.vehicleClass)),
      if (_text(item.vehicleCategory).isNotEmpty &&
          _text(item.vehicleCategory) != _text(item.vehicleClass))
        InfoChip(icon: Icons.category_outlined, label: _text(item.vehicleCategory)),
      if (_text(item.fuelType).isNotEmpty)
        InfoChip(icon: Icons.local_gas_station_outlined, label: _text(item.fuelType)),
    ];

    return Semantics(
      button: true,
      label: regNo.isEmpty
          ? 'Appointment. Open inspection'
          : 'Appointment $regNo. Open inspection',
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.card, AppSpacing.card, AppSpacing.card, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Registration + appointment time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RegistrationPlate(number: regNo.isEmpty ? '—' : regNo),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _AppointmentTime(raw: rawDate, hasDate: hasDate),
                    ],
                  ),
                  if (title.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title,
                    ),
                  ],
                  if (bookingId.isNotEmpty) ...[
                    SizedBox(height: title.isNotEmpty ? 2 : AppSpacing.md),
                    Text(
                      'Booking ID $bookingId',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption,
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: chips,
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            // Inspection stages + primary action
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.card, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  // Stages stacked in a table so labels and badges line up and
                  // each badge keeps a usable width on narrow phones.
                  Expanded(
                    child: Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        _stageRow('Manual', item.manualPreInspectionStatus),
                        _stageRow('Machine', item.machineInspectonStatus, top: AppSpacing.xs),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Same action as tapping the card; excluded from semantics
                  // because the card already announces it.
                  ExcludeSemantics(
                    child: FilledButton.tonal(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: accentLight,
                        foregroundColor: appColor,
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        textStyle: AppText.button.copyWith(fontSize: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Inspect'),
                          SizedBox(width: AppSpacing.xs),
                          Icon(Icons.arrow_forward_rounded, size: AppIconSize.sm + 2),
                        ],
                      ),
                    ),
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

/// Date and time of the appointment, right-aligned next to the plate.
class _AppointmentTime extends StatelessWidget {
  final String raw;
  final bool hasDate;

  const _AppointmentTime({required this.raw, required this.hasDate});

  @override
  Widget build(BuildContext context) {
    if (!hasDate) {
      return const Text('Date not set', style: AppText.caption);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatTime(raw),
          style: AppText.chip.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(formatDate(raw), style: AppText.caption),
      ],
    );
  }
}

/// One inspection stage ("Manual" / "Machine") and its status badge.
TableRow _stageRow(String label, String? value, {double top = 0}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.only(top: top, right: AppSpacing.sm),
        child: Text(label, maxLines: 1, style: AppText.caption),
      ),
      Padding(
        padding: EdgeInsets.only(top: top),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _stageBadge(value),
        ),
      ),
    ],
  );
}

/// Pass / Fail map to their badges, an empty value means the stage hasn't
/// started, and any other value from the API is shown as pending.
StatusBadge _stageBadge(String? value) {
  final text = (value ?? '').trim();
  final lower = text.toLowerCase();
  if (text.isEmpty || lower == 'null') {
    return const StatusBadge.neutral(
      label: 'Not started',
      icon: Icons.radio_button_unchecked_rounded,
      dense: true,
    );
  }
  if (lower == 'pass' || lower == 'fail') {
    return StatusBadge.fromResult(text, dense: true);
  }
  return StatusBadge.pending(label: text, dense: true);
}
