import 'package:ats_app/Presentation/provider/inspection_type_provider.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/screens/pre_inspection_form/handle_inspection_tap.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'color_data.dart';
import 'image_data.dart';

Widget inspectionTypeTiles({required BuildContext context,required BuildContext parentContext, }) {
  final typeProvider = Provider.of<InspectionTypeProvider>(context,listen: false);
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
              final inspection =
              typeProvider.inspectionTypeEntity!.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: InkWell(
                  onTap: () => handleInspectionTap(
                    context,
                    parentContext,
                    inspection.inspectionTypeCode,
                  ),
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
