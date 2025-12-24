import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_screen.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../provider/vehicle_type_provider.dart';

class VehicleClassScreen extends StatefulWidget {
  const VehicleClassScreen({super.key});

  @override
  State<VehicleClassScreen> createState() => _VehicleClassScreenState();
}

class _VehicleClassScreenState extends State<VehicleClassScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final classProvider =
    Provider.of<VehicleClassProvider>(context, listen: false);

    classProvider.vehicleClassApi(context);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        classProvider.vehicleClassApi(context, loadMore: true);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final typeProvider = Provider.of<VehicleTypeProvider>(context);
    final classProvider = Provider.of<VehicleClassProvider>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        title: CustomText(
          text: typeProvider.selectedType!.vehicleType.toString(),
          fontSize: 20,
          fontFamily: "SemiBold",
          textColor: whiteColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          child: classProvider.isLoading
              ? Center(child: CustomLoader.loader())
              : classProvider.vehicleClassEntity == null ||
              classProvider.vehicleClassEntity!.data == null ||
              classProvider.vehicleClassEntity!.data!.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(image: emptyBoxImage,scale: 2.5,),
                CustomText(
                  text: "No active vehicle found"
                      .toString(),
                  fontFamily: "Bold",
                  fontSize: 17,
                ),
              ],
            ),
          )
              :
          Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: CustomSearchTextField(
                  onChanged: (String value) {
                    classProvider.searchValue = value;
                    if(value.length >= 3){
                      classProvider.vehicleClassApi(context);
                    }else if(value.isEmpty){
                      classProvider.vehicleClassApi(context);
                    }
                  },
                  onCloseClick: () {
                    classProvider.searchController.clear();
                    classProvider.vehicleClassApi(context);
                  },
                  controller: classProvider.searchController,
                ),
              ),
              SizedBox(height: 5.0),

              Expanded(
                child:  ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: classProvider.vehicleClassEntity!.data!.length +
                      (classProvider.isLoadMore ? 1 : 0),
                       itemBuilder: (context, index) {
                          if (index ==
                              classProvider.vehicleClassEntity!.data!.length) {
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
                              classDataModel: classProvider
                                  .vehicleClassEntity!
                                  .data![index],
                              onTap: () {
                                classProvider.setSelectedClass(
                                  classProvider
                                      .vehicleClassEntity!
                                      .data![index],
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VehiclePartsScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
