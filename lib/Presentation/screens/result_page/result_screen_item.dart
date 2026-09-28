
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/color_data.dart';

class ResultScreenItem extends StatelessWidget {
  final ManualLisAppointments appointments;
  final VoidCallback? onRetest;

  const ResultScreenItem({
    super.key,
    required this.appointments,
    this.onRetest,
  });

  static String _value(Object? v) {
    final s = v?.toString().trim() ?? '';
    return s == 'null' ? '' : s;
  }

  @override
  Widget build(BuildContext context) {
    final isFail = appointments.manualStatus == "Fail";
    final date = _value(appointments.appointmentDate);
    final bookingId = _value(appointments.bookingId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AppCard(
        borderColor: isFail ? fail.withValues(alpha: 0.30) : null,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: RegistrationPlate(
                    number: _value(appointments.registrationNo).isEmpty
                        ? '—'
                        : _value(appointments.registrationNo),
                  ),
                ),
                const Spacer(),
                StatusBadge.fromResult(appointments.manualStatus),
              ],
            ),
            12.height,
            if (date.isNotEmpty)
              MetaRow(
                icon: Icons.event_rounded,
                text: "${formatDate(date)}  •  ${formatTime(date)}",
              ),
            if (bookingId.isNotEmpty) ...[
              6.height,
              MetaRow(icon: Icons.confirmation_number_outlined, text: "Booking ID: $bookingId"),
            ],
            12.height,
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (_value(appointments.vehicleClass).isNotEmpty)
                  InfoChip(icon: Icons.category_outlined, label: _value(appointments.vehicleClass)),
                if (_value(appointments.make).isNotEmpty)
                  InfoChip(icon: Icons.directions_car_outlined, label: _value(appointments.make)),
                if (_value(appointments.fuelType).isNotEmpty)
                  InfoChip(icon: Icons.local_gas_station_outlined, label: _value(appointments.fuelType)),
              ],
            ),
            12.height,
            const Divider(),
            10.height,
            Row(
              children: [
                const StatusBadge.neutral(label: "Manual", icon: Icons.edit_note_rounded, dense: true),
                const Spacer(),
                if (isFail)
                  FilledButton.icon(
                    onPressed: onRetest,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      textStyle: const TextStyle(fontSize: 13.5, fontFamily: "Bold"),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text("Retest"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
