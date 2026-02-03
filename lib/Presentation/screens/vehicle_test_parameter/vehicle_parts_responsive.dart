import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/vehicle_parts_provider.dart';
import '../inspection_result/inspection_result_screen.dart';

class VehiclePartsResponsiveLayout extends StatefulWidget {
  const VehiclePartsResponsiveLayout({super.key});

  @override
  State<VehiclePartsResponsiveLayout> createState() => _VehiclePartsResponsiveLayoutState();
}

class _VehiclePartsResponsiveLayoutState extends State<VehiclePartsResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    final partsProvider = context.watch<VehiclePartsProvider>();
    return  LayoutBuilder(
      builder: (context, constraints) {
        return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: constraints.horizontalPadding),
                child: partsProvider.isLoading ?
                Center(child: CustomLoader.loader()) :
                partsProvider.vehiclePartsEntity!.data!.isEmpty ?
                Center(child: CustomText(text: partsProvider.vehiclePartsEntity!.message.toString(), fontFamily: "Bold",)) :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     25.height,
                    CustomStepper(currentStep: partsProvider.currentStep, totalStep: constraints.isTablet ? partsProvider.totalPagesForTablet : partsProvider.totalPages),
                   15.height,
                    Expanded(
                      child: constraints.isTablet ?
                          GridView.builder(
                              itemCount: partsProvider.currentPageData.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                mainAxisSpacing: 40,
                                crossAxisSpacing: 15,
                                childAspectRatio: 3 / 2,
                              ),
                              itemBuilder: (context, index){
                                final item = partsProvider.currentPageData[index];
                                final allIndex = partsProvider.currentPage * partsProvider.itemsPerPageForTablet + index;
                                return VehiclePartsResponsiveItem(item: item, allIndex: allIndex, isTablet: true,);
                              }
                          )
                     : ListView.builder(
                        itemCount: partsProvider.currentPageData.length,
                        itemBuilder: (context, index) {
                          final item = partsProvider.currentPageData[index];
                          final allIndex = partsProvider.currentPage * partsProvider.itemsPerPage + index;
                          return Padding(padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: VehiclePartsResponsiveItem(item: item, allIndex: allIndex, isTablet: false,)
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
                        onPress: () async {
                          context.read<VehiclePartsProvider>().nextStepper();

                          if (partsProvider.currentPage < partsProvider.totalPages - 1) {
                            context.read<VehiclePartsProvider>().nextPage();
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InspectionResultScreen(),
                              ),
                            );
                            context.read<VehiclePartsProvider>().resetStepper();
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
            );
      }
    );
  }
}
