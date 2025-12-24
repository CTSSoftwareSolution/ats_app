

import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';

import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/media_picker_tiles.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/MediaPicker/file_provider.dart';
import '../inspection_result/inspection_result_screen.dart';

class VehiclePartsScreen extends StatefulWidget {
  const VehiclePartsScreen({super.key});

  @override
  State<VehiclePartsScreen> createState() => _VehiclePartsScreenScreenState();
}

class _VehiclePartsScreenScreenState extends State<VehiclePartsScreen> {


  @override
  void initState() {
    super.initState();
    final testProvider = Provider.of<VehiclePartsProvider>(context,listen: false);
    testProvider.vehiclePartsApi(context);
  }



  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    final partsProvider = Provider.of<VehiclePartsProvider>(context);
    if (!partsProvider.isLoading &&
        partsProvider.vehiclePartsEntity != null &&
        partsProvider.vehiclePartsEntity!.data != null) {
      partsProvider.currentPageData = partsProvider.getCurrentPageData();
    }
    return PopScope(
      canPop: partsProvider.currentStep == 0,
        onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (partsProvider.currentStep > 0) {
          partsProvider.previousPage();
          }
        },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: appColor,
          title: CustomText(
            text: "Vehicle Test Parameter",
            fontSize: 20,
            fontFamily: "SemiBold",
            textColor: whiteColor,
          ),
          leading: IconButton(
            onPressed: (){
              if(partsProvider.currentStep > 0){
                partsProvider.previousPage();
              }else{
                Navigator.pop(context);
              }
              },
            icon: ImageIcon(
              AssetImage(backArrowIcon),
              color: whiteColor,
              size: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: partsProvider.isLoading ?
            Center(child: CustomLoader.loader()) :
            partsProvider.vehiclePartsEntity!.data!.isEmpty ?
            Center(child: CustomText(text: partsProvider.vehiclePartsEntity!.message.toString(), fontFamily: "Bold",)) :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0,),
                CustomStepper(currentStep: partsProvider.currentStep, totalStep: partsProvider.totalPages,),
                Expanded(
                  child:
                  ListView.builder(
                    itemCount: partsProvider.currentPageData.length,
                    itemBuilder: (context, index) {
                      final item = partsProvider.currentPageData[index];
                      final allIndex = partsProvider.currentPage * partsProvider.itemsPerPage + index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: item.vehiclePartName.toString(),
                              fontFamily: "Bold",
                              fontSize: 18.0,
                            ),
                            CustomText(
                              text: "Capture or upload the ${item.vehiclePartName}",
                              fontFamily: "Medium",
                              fontSize: 15.0,
                            ),
                            SizedBox(height: 10.0),
                            UploadImageContainer(
                              index: allIndex,
                              onTap: () {
                                fileProvider.setCurrentIndex(allIndex);
                                customBottomSheet(
                                  context: context,
                                  title: "Select Media",
                                  child: mediaPickerTiles(
                                    context: context,
                                  ),
                                );
                              },
                            ),
                            fileProvider.getImage(allIndex) != null
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomButton(
                                      height: 38,
                                      width: double.infinity,
                                      buttonText: "Re-upload",
                                      onPress: () {
                                        fileProvider.setCurrentIndex(allIndex);
                                        customBottomSheet(
                                          context: context,
                                          title: "Select Media",
                                          child: mediaPickerTiles(
                                            context: context,
                                          ),
                                        );
                                      },
                                      backgroundColor: appColor,
                                      foregroundColor: whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                                      ),
                                      fontSize: 15,
                                      fontFamily: "Bold",
                                    ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: CustomButton(
                    width: double.infinity,
                    height: 50.0,
                    buttonText:partsProvider.currentPage == partsProvider.totalPages - 1 ? "Submit" : "Next",
                    onPress: () {
                      partsProvider.nextStepper();
                      if (partsProvider.currentPage < partsProvider.totalPages - 1) {
                        partsProvider.nextPage();
                      }
                      else if(partsProvider.currentPage == partsProvider.totalPages - 1){
                        final images = fileProvider.allImages;
                        final imagesName = images.map((value)=> value!.name);
                        debugPrint("All Images: $imagesName");
                        context.push(InspectionResultScreen());
                        const snack = SnackBar(content: Text("All images completed"),duration: Duration(seconds: 3),);
                        ScaffoldMessenger.of(context).showSnackBar(snack);

                      }

                    },
                    backgroundColor: appColor,
                    foregroundColor: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    fontSize: 20.0,
                    fontFamily: "Bold",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
