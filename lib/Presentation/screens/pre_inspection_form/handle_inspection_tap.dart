import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/custom_confirmation_dialog_box.dart';
import '../../provider/MediaPicker/file_provider.dart';
import '../../provider/pre_ins_manual_status_provider.dart';
import '../vehicle_test_parameter/vehicle_parts_screen.dart';
import 'inspection_page/inspection_page.dart';

void handleInspectionTap(BuildContext context, BuildContext parentContext, String? inspectionCode){
  switch (inspectionCode){
    case "1" :
      openManualInspection(context,parentContext);
      break;
    case "2" :
      openMachineInspection(context, parentContext);
  }
}


void openManualInspection(BuildContext context, BuildContext parentContext) {
  final statusProvider = Provider.of<PreInsManualStatusProvider>(context, listen: false);
  context.pop();
  final status = statusProvider.preInsManualStatusEntity?.data;
  if(status == "Fail"){
    context.push(InspectionPage(isEditMode: true));
  }else if(status == "Pass"){
    customConfirmationDialogBox(context: parentContext, text: 'Manual Inspection passed successfully. You can continue to Machine Inspection.',
        buttons: [
          DialogButton(
            text: "Machine Inspection",
            textColor: whiteColor,
            backgroundColor: appColor,
            onPressed: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => VehiclePartsScreen()),
              );
            },
          ),
        ]);
  }
  else{
    context.push(InspectionPage(isEditMode: false));
  }

}

void openMachineInspection(BuildContext context, BuildContext parentContext){
  final statusProvider =
  Provider.of<PreInsManualStatusProvider>(context, listen: false);

  context.pop();

  final status = statusProvider.preInsManualStatusEntity?.data;

  if(status == null){
    customConfirmationDialogBox(context: parentContext, text: 'Please complete the Manual Inspection before proceeding to Machine Inspection.',
        buttons: [
          DialogButton(
            text: "Manual Inspection",
            textColor: whiteColor,
            backgroundColor: appColor,
            onPressed: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => InspectionPage()),
              );
            },
          ),
        ]);
  }else if(status == "Fail"){
    customConfirmationDialogBox(
        context: parentContext,
        text: 'Manual Inspection has failed. Do you want to continue Manual Inspection or proceed with Machine Inspection?',
        buttons: [
          DialogButton(
            text: "Manual Inspection",
            textColor: whiteColor,
            backgroundColor: redColor,
            onPressed: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => InspectionPage(isEditMode: true)),
              );
            },
          ),
          DialogButton(
            text: "Machine Inspection",
            textColor: whiteColor,
            backgroundColor: appColor,
            onPressed: () {
              Navigator.pop(parentContext);
              Navigator.push(
                parentContext,
                MaterialPageRoute(builder: (_) => VehiclePartsScreen()),
              );
            },
          ),
        ]
    );
  }
  else{
    context.read<FileProvider>().clearAll(context);
    context.push(VehiclePartsScreen());
  }
}