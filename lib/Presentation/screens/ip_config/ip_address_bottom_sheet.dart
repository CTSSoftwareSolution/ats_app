import 'package:flutter/material.dart';

import 'ip_address_bottom_sheet_screen.dart';

void showIpAddressBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (context) => const IpAddressBottomSheetScreen(),
  );
}