
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/info_chip.dart';
import '../../../widgets/new_app_ui/meta_row.dart';
import '../../../widgets/new_app_ui/registration_plate.dart';
import '../../../widgets/new_app_ui/status_badge.dart';

/// Manual inspection result card shown in the Result tab.
class ResultScreenItem extends StatelessWidget {
  final ManualLisAppointments appointments;
  final VoidCallback? onRetest;

  const ResultScreenItem({
    super.key,
    required this.appointments,
    this.onRetest,
  });

  /// Hides "null"/empty values coming from the API.
  String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  @override
  Widget build(BuildContext context) {
    final regNo = _text(appointments.registrationNo);
    final isFail = appointments.manualStatus == "Fail";
    final chips = <Widget>[
      if (_text(appointments.vehicleClass).isNotEmpty)
        InfoChip(icon: Icons.tag_rounded, label: _text(appointments.vehicleClass)),
      if (_text(appointments.make).isNotEmpty)
        InfoChip(icon: Icons.directions_car_outlined, label: _text(appointments.make)),
      if (_text(appointments.fuelType).isNotEmpty)
        InfoChip(icon: Icons.local_gas_station_outlined, label: _text(appointments.fuelType)),
      const InfoChip(icon: Icons.edit_note_rounded, label: "Manual"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RegistrationPlate(number: regNo.isEmpty ? '-' : regNo),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                StatusBadge.fromResult(appointments.manualStatus),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chips,
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1, thickness: 1, color: border),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MetaRow(
                        icon: Icons.confirmation_number_outlined,
                        text: "Booking ID ${_text(appointments.bookingId)}",
                      ),
                      const SizedBox(height: 6),
                      MetaRow(
                        icon: Icons.schedule_rounded,
                        text:
                            "${formatDate(appointments.appointmentDate.toString())} · ${formatTime(appointments.appointmentDate.toString())}",
                      ),
                    ],
                  ),
                ),
                if (isFail) ...[
                  const SizedBox(width: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: onRetest,
                    style: FilledButton.styleFrom(
                      backgroundColor: appColor,
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text("Retest"),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
