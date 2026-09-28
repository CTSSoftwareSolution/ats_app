import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive.dart';
import 'package:ats_app/image_processing/MediaPicker/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/app_ui.dart';
import '../../provider/vehicle_class_provider.dart';

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
    final regNo = context.watch<VehicleClassProvider>().selectedClass?.registrationNo?.toString() ?? '';
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Vehicle Test Parameter"),
              if (regNo.isNotEmpty)
                Text(
                  regNo.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontFamily: "SemiBold",
                    color: textWhiteSub,
                    letterSpacing: 0.8,
                  ),
                ),
            ],
          ),
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
        body: SafeArea(
          child: VehiclePartsResponsiveLayout(),

        ),
      ),
    );
  }
}
