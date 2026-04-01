import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';

class VehiclePartsScreen extends StatefulWidget {
  const VehiclePartsScreen({super.key});

  @override
  State<VehiclePartsScreen> createState() => _VehiclePartsScreenScreenState();
}

class _VehiclePartsScreenScreenState extends State<VehiclePartsScreen> {


  @override
  void initState() {
    super.initState();
    context.read<VehiclePartsProvider>().vehiclePartsApi(context);
    context.read<FileProvider>().clearAll();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final partsProvider = context.watch<VehiclePartsProvider>();
    if (!partsProvider.isLoading &&
        partsProvider.vehiclePartsEntity != null &&
        partsProvider.vehiclePartsEntity!.data != null) {
      partsProvider.currentPageData = isTablet ? context.read<VehiclePartsProvider>().getCurrentPageDataForTablet() : context.read<VehiclePartsProvider>().getCurrentPageData();
    }
    return PopScope(
      canPop: partsProvider.currentStep == 0,
        onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (partsProvider.currentStep > 0) {
          context.read<VehiclePartsProvider>().previousPage();
          }
        },
      child: Scaffold(
        backgroundColor: background,
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
                context.read<VehiclePartsProvider>().previousPage();
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
          child: VehiclePartsResponsiveLayout(),

        ),
      ),
    );
  }
}
