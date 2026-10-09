import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Data/model/response_model/ai_inspection_list_res_model.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/new_app_ui/app_card.dart';
import '../../../widgets/new_app_ui/info_chip.dart';
import '../../../widgets/new_app_ui/meta_row.dart';
import '../../../widgets/new_app_ui/registration_plate.dart';
import '../../../widgets/new_app_ui/status_badge.dart';

/// AI inspection appointment card shown in the AI Inspections list.
class AiInspectionListItem extends StatelessWidget {
  final Appointments appointment;
  final VoidCallback? onTap;

  const AiInspectionListItem({
    super.key,
    required this.appointment,
    this.onTap,
  });

  /// Hides "null"/empty values coming from the API.
  String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  /// Formats the appointment date, or returns '' when it can't be parsed.
  String _dateTime(String? raw) {
    final date = DateTime.tryParse(_text(raw));
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy · hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final regNo = _text(appointment.registrationNo);
    final status = _text(appointment.statusLabel).isNotEmpty
        ? _text(appointment.statusLabel)
        : _text(appointment.statusName);
    final bookingId = _text(appointment.bookingId);
    final customer = _text(appointment.customerName);
    final date = _dateTime(appointment.appointmentDate);
    final passCount = appointment.aiPassCount;
    final failCount = appointment.aiFailCount;

    final chips = <Widget>[
      if (_text(appointment.make).isNotEmpty)
        InfoChip(icon: Icons.directions_car_outlined, label: _text(appointment.make)),
      if (_text(appointment.model).isNotEmpty)
        InfoChip(icon: Icons.tag_rounded, label: _text(appointment.model)),
      if (_text(appointment.laneName).isNotEmpty)
        InfoChip(icon: Icons.alt_route_rounded, label: _text(appointment.laneName)),
      const InfoChip(icon: Icons.auto_awesome_outlined, label: "AI"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AppCard(
        onTap: onTap,
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
                if (status.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: StatusBadge(
                      label: status,
                      color: accent,
                      background: accentLight,
                      icon: Icons.info_outline_rounded,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chips,
            ),
            if (bookingId.isNotEmpty || customer.isNotEmpty || date.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, thickness: 1, color: border),
              const SizedBox(height: AppSpacing.md),
              if (bookingId.isNotEmpty)
                MetaRow(
                  icon: Icons.confirmation_number_outlined,
                  text: "Booking ID $bookingId",
                ),
              if (customer.isNotEmpty) ...[
                if (bookingId.isNotEmpty) const SizedBox(height: 6),
                MetaRow(icon: Icons.person_outline_rounded, text: customer),
              ],
              if (date.isNotEmpty) ...[
                if (bookingId.isNotEmpty || customer.isNotEmpty)
                  const SizedBox(height: 6),
                MetaRow(icon: Icons.schedule_rounded, text: date),
              ],
            ],
            if (passCount != null || failCount != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Text(
                    "AI Result",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "SemiBold",
                      color: textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (passCount != null)
                    StatusBadge.pass(label: "Pass ${passCount.toInt()}", dense: true),
                  if (passCount != null && failCount != null)
                    const SizedBox(width: AppSpacing.sm),
                  if (failCount != null)
                    StatusBadge.fail(label: "Fail ${failCount.toInt()}", dense: true),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
