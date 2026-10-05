import 'package:flutter/material.dart';
import '../utilities/inspection_sheet.dart';


void showInspectionSheet(BuildContext context, {required Function(String) onSelect}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => InspectionSheet(onSelect: onSelect),
  );
}




