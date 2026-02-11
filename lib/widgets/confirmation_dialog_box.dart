import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/provider/MediaPicker/file_provider.dart';
import '../Presentation/screens/pre_inspection_form/inspection_form_screen.dart';
import '../Presentation/screens/vehicle_test_parameter/vehicle_parts_screen.dart';
import '../utilities/image_data.dart';
import 'custom_button.dart';
import 'custom_text.dart';

confirmationDialogBox({
  required BuildContext context,
}) {
  int selectedIndex = -1;
  showDialog(
    context: context,
    builder: (BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){ context.pop(); },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Select Inspection Type",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    textColor: blackColor,
                  ),
                  CustomImage(image: closeIcon,scale: 20,)
                ],
              ),
            ),
            15.height,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: inspectionTypeTitles.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: InkWell(
                        onTap: () async {
                          selectedIndex = index;
                          if (inspectionTypeTitles[index].id == 0) {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InspectionFormScreen()),
                            );
                          } else if (mediaSource[index].id == 1) {
                            Navigator.pop(context);
                            context.read<FileProvider>().clearAll(context);
                            context.push(VehiclePartsScreen());
                          }
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: isSelected
                                ? cardBackgroundColor
                                : mediaPickerColor,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomImage(image: inspectionTypeTitles[index].image,scale: 20,),
                              ),
                              10.width,
                              CustomText(
                                text: inspectionTypeTitles[index].name,
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

          ],
        ),
      ),
    ),
  );
}
