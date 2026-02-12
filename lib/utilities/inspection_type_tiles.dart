import 'package:ats_app/Presentation/provider/inspection_type_provider.dart';
import 'package:ats_app/Presentation/provider/pre_ins_manual_status_provider.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_dialog_box.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/provider/MediaPicker/file_provider.dart';
import '../Presentation/screens/pre_inspection_form/inspection_form_screen.dart';
import '../Presentation/screens/vehicle_test_parameter/vehicle_parts_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'color_data.dart';
import 'custom_confirmation_dialog_box.dart';
import 'image_data.dart';

Widget inspectionTypeTiles({required BuildContext context}) {
  final typeProvider = Provider.of<InspectionTypeProvider>(context,listen: false);
  final statusProvider = Provider.of<PreInsManualStatusProvider>(context,listen: false);
  int selectedIndex = -1;
  return SafeArea(
    bottom: true,
    child: Padding(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: typeProvider.inspectionTypeEntity!.data!.length,
            itemBuilder: (context, index) {
              final bool isSelected = selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: InkWell(
                  onTap: () async {
                    selectedIndex = index;
                    if (typeProvider.inspectionTypeEntity!.data![index].inspectionTypeCode == "1") {
                      context.pop();
                      context.push(InspectionFormScreen());
                    } else if (typeProvider.inspectionTypeEntity!.data![index].inspectionTypeCode == "2") {
                      context.pop();
                      if( statusProvider.preInsManualStatusEntity?.data == null ){

                        customConfirmationDialogBox(context: context, text: 'Please complete the Manual Inspection before proceeding to Machine Inspection.',
                            buttons: [
                              DialogButton(
                                text: "Manual Inspection",
                                textColor: appColor,
                                onPressed: () {
                                  context.pop();
                                  context.push(InspectionFormScreen());
                                },
                              ),
                            ]);

                      }else if( statusProvider.preInsManualStatusEntity?.data == "Fail" ){

                        customConfirmationDialogBox(context: context, text: 'Manual Inspection has failed. Do you want to continue Manual Inspection or proceed with Machine Inspection?',
                            buttons: [
                              DialogButton(
                                text: "Manual Inspection",
                                textColor: redColor,
                                onPressed: () {
                                  context.pop();
                                  context.push(InspectionFormScreen());
                                },
                              ),
                              DialogButton(
                                text: "Machine Inspection",
                                textColor: appColor,
                                onPressed: () {
                                  context.pop();
                                  context.push(VehiclePartsScreen());
                                },
                              ),
                            ]
                            );

                      }else{

                        context.read<FileProvider>().clearAll(context);
                        context.push(VehiclePartsScreen());

                      }
                    }
                  },
                  child: Container(
                    height: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: isSelected
                          ? cardBackgroundColor
                          : mediaPickerColor,
                    ),
                    child: Row(
                      children: [
                        20.width,
                        CustomImage(
                          image: inspectionTypeImage[index],
                          scale: 17.0,
                        ),
                        15.width,
                        CustomText(
                          text: typeProvider.inspectionTypeEntity!.data![index].inspectionTypeName ?? "",
                          fontSize: 16.0,
                          fontFamily: "Bold",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: CustomButton(
              height: 45.0,
              width: double.infinity,
              buttonText: "Close",
              onPress: () {
                Navigator.pop(context);
              },
              backgroundColor: appColor,
              foregroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              fontSize: 16.0,
              fontFamily: "Bold",
            ),
          ),
        ],
      ),
    ),
  );
}
