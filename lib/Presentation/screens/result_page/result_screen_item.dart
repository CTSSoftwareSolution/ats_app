import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_icon_size.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/appointment_time.dart';
import '../../../widgets/new_app_ui/info_chip.dart';
import '../../../widgets/new_app_ui/registration_plate.dart';
import '../../../widgets/new_app_ui/status_badge.dart';

/// Manual inspection result card shown in the Result tab.
///
/// Registration and appointment time on top, vehicle and booking details in
/// the middle, and the result (with Retest for failed inspections) in the
/// footer. The card border is tinted by the result.
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
    final bookingId = _text(appointments.bookingId);
    final rawDate = _text(appointments.appointmentDate);
    final isFail = appointments.manualStatus == "Fail";
    final isPass = appointments.manualStatus == "Pass";
    final make = _text(appointments.make);

    final chips = <Widget>[
      if (_text(appointments.vehicleClass).isNotEmpty)
        InfoChip(
          icon: Icons.tag_rounded,
          label: _text(appointments.vehicleClass),
        ),
      if (_text(appointments.fuelType).isNotEmpty)
        InfoChip(
          icon: Icons.local_gas_station_outlined,
          label: _text(appointments.fuelType),
        ),
      const InfoChip(icon: Icons.edit_note_rounded, label: "Manual"),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: EdgeInsets.zero,
        borderColor: isFail
            ? fail.withValues(alpha: 0.45)
            : isPass
            ? pass.withValues(alpha: 0.35)
            : null,
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
                  // Registration + appointment time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RegistrationPlate(
                            number: regNo.isEmpty ? '-' : regNo,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppointmentTime(raw: rawDate),
                    ],
                  ),
                  if (make.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      make,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.title,
                    ),
                  ],
                  if (bookingId.isNotEmpty) ...[
                    SizedBox(height: make.isNotEmpty ? 2 : AppSpacing.md),
                    Text(
                      "Booking ID $bookingId",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: chips,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Result + Retest
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSpacing.minTouchTarget,
                ),
                child: Row(
                  children: [
                    // "Result [badge]" stays together on the left and can
                    // shrink, so the row never overflows next to Retest.
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Flexible(
                            child: Text(
                              "Result",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.caption,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            flex: 3,
                            child: StatusBadge.fromResult(
                              appointments.manualStatus,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFail) ...[
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton.icon(
                        onPressed: onRetest,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          tapTargetSize: MaterialTapTargetSize.padded,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          textStyle: AppText.button.copyWith(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.refresh_rounded,
                          size: AppIconSize.sm + 2,
                        ),
                        label: const Text("Retest"),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
