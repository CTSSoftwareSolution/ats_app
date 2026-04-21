import 'package:ats_app/Core/network/InternetCheck/network_status.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/responsive_button.dart';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_responsive_item.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/custom_stepper.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/vehicle_parts_provider.dart';
import '../inspection_result/inspection_result_screen.dart';

class VehiclePartsResponsiveLayout extends StatefulWidget {
  const VehiclePartsResponsiveLayout({super.key});

  @override
  State<VehiclePartsResponsiveLayout> createState() =>
      _VehiclePartsResponsiveLayoutState();
}

class _VehiclePartsResponsiveLayoutState
    extends State<VehiclePartsResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    final partsProvider = context.watch<VehiclePartsProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (constraints.isTablet &&
                partsProvider.vehiclePartsEntity != null) {
              partsProvider.setTabletItemsPerPage(
                orientation == Orientation.portrait,
              );
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.horizontalPadding,
                ),
                child: partsProvider.isLoading
                    ? Center(child: CustomLoader.loader())
                    : partsProvider.vehiclePartsEntity!.data!.isEmpty
                    ? Center(
                        child: CustomText(
                          text: partsProvider.vehiclePartsEntity!.message
                              .toString(),
                          fontFamily: "Bold",
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          constraints.isTablet ? 35.height : 25.height,
                          Center(
                            child: CustomStepper(
                              currentStep: partsProvider.currentStep,
                              totalStep: constraints.isTablet
                                  ? partsProvider.totalPagesForTablet
                                  : partsProvider.totalPages,
                              width: constraints.isTablet
                                  ? (orientation == Orientation.portrait
                                        ? double.infinity
                                        : constraints.contentMaxWidth / 2)
                                  : double.infinity,
                            ),
                          ),
                          constraints.isTablet ? 30.height : 15.height,
                          Expanded(
                            child: constraints.isTablet
                                ? GridView.builder(
                                    itemCount:
                                        partsProvider.currentPageData.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              orientation ==
                                                  Orientation.portrait
                                              ? 2
                                              : 3,
                                          mainAxisSpacing: constraints.isTablet
                                              ? 10
                                              : 40,
                                          crossAxisSpacing: 15,
                                          childAspectRatio: 6 / 5,
                                        ),
                                    itemBuilder: (context, index) {
                                      final item =
                                          partsProvider.currentPageData[index];
                                      final allIndex =
                                          partsProvider.currentPage *
                                              partsProvider
                                                  .itemsPerPageForTablet +
                                          index;
                                      return VehiclePartsResponsiveItem(
                                        item: item,
                                        allIndex: allIndex,
                                        isTablet: true,
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    itemCount:
                                        partsProvider.currentPageData.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          partsProvider.currentPageData[index];
                                      final allIndex =
                                          partsProvider.currentPage *
                                              partsProvider.itemsPerPage +
                                          index;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                        ),
                                        child: VehiclePartsResponsiveItem(
                                          item: item,
                                          allIndex: allIndex,
                                          isTablet: false,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          constraints.isTablet
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: ResponsiveButton(
                                    width: 200,
                                    buttonText:
                                        partsProvider.currentPage ==
                                            partsProvider.totalPagesForTablet -
                                                1
                                        ? "Submit"
                                        : "Next",
                                    onPress: () {
                                      if (context
                                          .read<NetworkStatus>()
                                          .isConnected) {
                                        context
                                            .read<VehiclePartsProvider>()
                                            .nextStepper(
                                              partsProvider.totalPagesForTablet,
                                            );

                                        if (partsProvider.currentPage <
                                            partsProvider.totalPagesForTablet -
                                                1) {
                                          context
                                              .read<VehiclePartsProvider>()
                                              .nextPage(
                                                partsProvider
                                                        .totalPagesForTablet -
                                                    1,
                                              );
                                        } else {
                                          context.push(
                                            InspectionResultScreen(),
                                          );
                                          context
                                              .read<VehiclePartsProvider>()
                                              .resetStepperForTablet();
                                        }
                                      } else {
                                        CustomLoader.internetMessage(
                                          msg: "No Internet Connection",
                                          context: context,
                                        );
                                      }
                                    },
                                  ),
                                )
                              : ResponsiveButton(
                                  width: double.infinity,
                                  buttonText:
                                      partsProvider.currentPage ==
                                          partsProvider.totalPages - 1
                                      ? "Submit"
                                      : "Next",
                                  onPress: () {
                                    if (context
                                        .read<NetworkStatus>()
                                        .isConnected) {
                                      context
                                          .read<VehiclePartsProvider>()
                                          .nextStepper(
                                            partsProvider.totalPages,
                                          );

                                      if (partsProvider.currentPage <
                                          partsProvider.totalPages - 1) {
                                        context
                                            .read<VehiclePartsProvider>()
                                            .nextPage(
                                              partsProvider.totalPages - 1,
                                            );
                                      } else {
                                        context.push(InspectionResultScreen());
                                        context
                                            .read<VehiclePartsProvider>()
                                            .resetStepper();
                                      }
                                    } else {
                                      CustomLoader.internetMessage(
                                        msg: "No Internet Connection",
                                        context: context,
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
