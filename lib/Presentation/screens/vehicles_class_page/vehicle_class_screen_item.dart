import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';

import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/app_ui.dart';

/// Appointment card shown in the Home list. The whole card is tappable.
class VehicleClassScreenItem extends StatefulWidget {
  final Appointments classDataModel;
  final VoidCallback onTap;

  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
  });

  @override
  State<VehicleClassScreenItem> createState() => _VehicleClassScreenItemState();
}

class _VehicleClassScreenItemState extends State<VehicleClassScreenItem> {
  /// Hides "null"/empty values coming from the API.
  String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.classDataModel;
    final regNo = _text(item.registrationNo);
    final chips = <Widget>[
      if (_text(item.vehicleClass).isNotEmpty)
        InfoChip(icon: Icons.tag_rounded, label: _text(item.vehicleClass)),
      if (_text(item.make).isNotEmpty)
        InfoChip(icon: Icons.directions_car_outlined, label: _text(item.make)),
      if (_text(item.fuelType).isNotEmpty)
        InfoChip(icon: Icons.local_gas_station_outlined, label: _text(item.fuelType)),
    ];

    return AppCard(
      onTap: widget.onTap,
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
              const Icon(Icons.chevron_right_rounded, color: textMuted, size: 24),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chips,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, thickness: 1, color: border),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: MetaRow(
                  icon: Icons.confirmation_number_outlined,
                  text: "Booking ID ${_text(item.bookingId)}",
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MetaRow(
                  icon: Icons.schedule_rounded,
                  text:
                      "${formatDate(item.appointmentDate.toString())} · ${formatTime(item.appointmentDate.toString())}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
