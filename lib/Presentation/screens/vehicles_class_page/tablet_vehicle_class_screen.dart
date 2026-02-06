import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Responsive/responsive_ext.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/custom_text.dart';
import '../../provider/MediaPicker/file_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../vehicle_test_parameter/vehicle_parts_screen.dart';

class TabletVehicleClassScreen extends StatefulWidget {
  const TabletVehicleClassScreen({super.key});

  @override
  State<TabletVehicleClassScreen> createState() => _TabletVehicleClassScreenState();
}

class _TabletVehicleClassScreenState extends State<TabletVehicleClassScreen> {

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
    return Scaffold(
      body: SafeArea(
          child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                  child:
                  Column(
                    children: [
                         50.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomSearchTextField(
                            onChanged: (String value) {

                              context.read<VehicleClassProvider>()
                                  .onSearchChanged(context, value);
                            },
                            onCloseClick: () {
                              context.read<VehicleClassProvider>().searchController.clear();
                              context.read<VehicleClassProvider>().vehicleClassApi(context);
                            },
                            controller: context.watch<VehicleClassProvider>().searchController,
                          ),
                        ),
                      ),
                       12.height,

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
                        ) :
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
                                  context.read<VehicleClassProvider>().setSelectedClass(
                                    classProvider[index],
                                  );
                                  context.read<FileProvider>().clearAll(context);
                                  context.push(VehiclePartsScreen());
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
          ),
    );
  }
}
