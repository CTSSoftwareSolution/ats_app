import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';

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

    final partsProvider = context.watch<VehiclePartsProvider>();
    if (!partsProvider.isLoading &&
        partsProvider.vehiclePartsEntity != null &&
        partsProvider.vehiclePartsEntity!.data != null) {
      partsProvider.currentPageData = context.read<VehiclePartsProvider>().getCurrentPageData();
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
        backgroundColor: bg,
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: appColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text("Vehicle Test Parameter"),
          leading: AppBackButton(
            onPressed: (){
              if(partsProvider.currentStep > 0){
                context.read<VehiclePartsProvider>().previousPage();
              }else{
                Navigator.pop(context);
              }
              },
          ),
        ),
        body: const SafeArea(
          bottom: false,
          child: VehiclePartsResponsiveLayout(),
        ),
      ),
    );
  }
}
