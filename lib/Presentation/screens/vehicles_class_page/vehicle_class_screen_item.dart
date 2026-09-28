import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';

class VehicleClassScreenItem extends StatelessWidget {
  final Appointments classDataModel;
  final VoidCallback onTap;

  const VehicleClassScreenItem({
    super.key,
    required this.onTap,
    required this.classDataModel,
  });

  static String _value(Object? v) {
    final s = v?.toString().trim() ?? '';
    return s == 'null' ? '' : s;
  }

  @override
  Widget build(BuildContext context) {
    final regNo = _value(classDataModel.registrationNo);
    final bookingId = _value(classDataModel.bookingId);
    final date = _value(classDataModel.appointmentDate);
    final status = _value(classDataModel.manualPreInspectionStatus);
    final make = [_value(classDataModel.make), _value(classDataModel.model)]
        .where((e) => e.isNotEmpty)
        .join(' ');

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(child: RegistrationPlate(number: regNo.isEmpty ? '—' : regNo)),
              const Spacer(),
              if (status.isNotEmpty) ...[
                StatusBadge.fromResult(status, dense: true),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.chevron_right_rounded, color: textMuted),
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
              if (_value(classDataModel.vehicleClass).isNotEmpty)
                InfoChip(icon: Icons.category_outlined, label: _value(classDataModel.vehicleClass)),
              if (make.isNotEmpty)
                InfoChip(icon: Icons.directions_car_outlined, label: make),
              if (_value(classDataModel.fuelType).isNotEmpty)
                InfoChip(icon: Icons.local_gas_station_outlined, label: _value(classDataModel.fuelType)),
            ],
          ),
        ],
      ),
    );
  }
}
