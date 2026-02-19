import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:ats_app/Responsive/responsive_ext.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/image_data.dart';
import '../../../utilities/inspection_type_tiles.dart';
import '../../../widgets/custom_bottomsheet.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/MediaPicker/file_provider.dart';
import '../../provider/inspection_type_provider.dart';
import '../../provider/pre_ins_manual_status_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../vehicle_test_parameter/vehicle_parts_screen.dart';

class VehicleClassResponsiveLayout extends StatefulWidget {
  const VehicleClassResponsiveLayout({super.key});

  @override
  State<VehicleClassResponsiveLayout> createState() => _VehicleClassResponsiveLayoutState();
}

class _VehicleClassResponsiveLayoutState extends State<VehicleClassResponsiveLayout> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<VehicleClassProvider>().vehicleClassApi(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<VehicleClassProvider>().vehicleClassApi(context, loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<VehicleClassProvider>().vehicleClassEntity?.data;
    final typeProvider = Provider.of<InspectionTypeProvider>(context);
    return  LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child:
              Column(
                children: [
                 constraints.isTablet ? 20.height : 10.height,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: SizedBox(
                      width: constraints.isTablet ? constraints.maxWidth/1.5 : double.infinity,
                      child: CustomSearchTextField(
                        onChanged: (String value) {
                          context.read<VehicleClassProvider>().onSearchChanged(context, value);
                        },
                        onCloseClick: () {
                          context.read<VehicleClassProvider>().searchController.clear();
                          context.read<VehicleClassProvider>().vehicleClassApi(context);
                        },
                        controller: context.watch<VehicleClassProvider>().searchController,
                      ),
                    ),
                  ),
                  constraints.isTablet ? 24.height : 12.height,
                  Expanded(
                    child: context.watch<VehicleClassProvider>().isLoading
                        ? Center(child: CustomLoader.loader())
                        :
                    context.watch<VehicleClassProvider>().vehicleClassEntity == null ||
                        classProvider == null ||
                        classProvider.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImage(image: emptyBoxImage,scale: 2.5,),
                          CustomText(
                            text: "No active vehicle found",
                            fontFamily: "Bold",
                            fontSize: 17,
                          ),
                        ],
                      ),
                    )
                        : constraints.isTablet ?
                        GridView.builder(
                            controller: scrollController,
                            itemCount:  classProvider.length +
                                (context.watch<VehicleClassProvider>().isLoadMore ? 1 : 0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                          mainAxisSpacing: constraints.isTablet ? 0.0 : 40,
                          crossAxisSpacing:  5,
                          childAspectRatio: 1/ 0.4,
                        ),
                            itemBuilder: (context,index){
                              if (index == classProvider.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: CustomLoader.loader(),
                                  ),
                                );
                              }
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: VehicleClassScreenItem(
                              classDataModel: classProvider[index],
                              onTap: () {
                                context.read<VehicleClassProvider>().setSelectedClass(
                                  classProvider[index],
                                );
                                context.read<FileProvider>().clearAll(context);
                                context.push(VehiclePartsScreen());
                              },
                            ),
                          );
                            }
                        )
                    :
                    ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: classProvider.length +
                          (context.watch<VehicleClassProvider>().isLoadMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == classProvider.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: CustomLoader.loader(),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 8.0,
                          ),
                          child: VehicleClassScreenItem(
                            classDataModel: classProvider[index],
                            onTap: () {
                              context.read<VehicleClassProvider>().setSelectedClass(classProvider[index],);
                              context.read<FileProvider>().clearAll(context);
                              context.read<PreInsManualStatusProvider>().getManualStatusApi(context);
                              if(typeProvider.inspectionTypeEntity!.status!=false) {
                                customBottomSheet(
                                  context: context,
                                  title: 'Select Inspection Type',
                                  child:  inspectionTypeTiles(context: context, parentContext: context)
                              );
                              }else{
                                context.showErrorSnackBar("Something went wrong!");
                              }
                            },
                          ),

                          //
                          // VehicleClassScreenItem(
                          //   classDataModel: classProvider[index],
                          //   onTap: () {
                          //     context.read<VehicleClassProvider>().setSelectedClass(classProvider[index]);
                          //     context.read<FileProvider>().clearAll(context);
                          //     context.push(VehiclePartsScreen());
                          //   },
                          // ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
