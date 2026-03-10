
import 'package:flutter/material.dart';
import '../../../utilities/color_data.dart';

class VehicleFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  IconData _iconFor(String label) {
    switch (label) {
      case 'All':
        return Icons.dashboard_rounded;
      case 'LMV':
        return Icons.directions_car_rounded;
      case 'HMV':
        return Icons.local_shipping_rounded;
      case 'MCWG':
        return Icons.two_wheeler_rounded;
      case 'EV':
        return Icons.electric_bolt_rounded;
      default:
        return Icons.filter_list_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? appColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: appColor.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _iconFor(label),
                key: ValueKey(isSelected),
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black87,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}