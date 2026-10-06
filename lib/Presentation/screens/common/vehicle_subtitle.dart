import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../provider/manual_inspection_list_provider.dart';
import '../../provider/vehicle_class_provider.dart';

/// Registration number of the vehicle being inspected, for the app bar
/// subtitle of the inspection-flow screens. Read-only: it only looks at the
/// selection the providers already hold, and returns null when there is none.
///
/// [fromResultList] — the Inspection page is also opened from the Result tab
/// (Retest), where the selection lives in [ManualInspectionListProvider].
String? vehicleSubtitle(BuildContext context, {bool fromResultList = false}) {
  String clean(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text.toUpperCase();
  }

  try {
    if (fromResultList) {
      final list = Provider.of<ManualInspectionListProvider>(
        context,
        listen: false,
      );
      if (list.isManualInspectionScreen) {
        final reg = clean(list.selectedManualListData?.registrationNo);
        return reg.isEmpty ? null : reg;
      }
    }
    final reg = clean(
      Provider.of<VehicleClassProvider>(
        context,
        listen: false,
      ).selectedClass?.registrationNo,
    );
    return reg.isEmpty ? null : reg;
  } on ProviderNotFoundException {
    return null;
  }
}
