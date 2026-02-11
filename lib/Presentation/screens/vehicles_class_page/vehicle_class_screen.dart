import 'package:ats_app/Presentation/provider/MediaPicker/file_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_screen.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/confirmation_dialog_box.dart';
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
    final vehicleType = context.watch<VehicleTypeProvider>().selectedType!.vehicleType;
    final classProvider = context.watch<VehicleClassProvider>().vehicleClassEntity?.data;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        title: CustomText(
          text: vehicleType.toString(),
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
          child:
          Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: CustomSearchTextField(
                  onChanged: (String value) {

                    context.read<VehicleClassProvider>()
                        .onSearchChanged(context, value);
                    // context.read<VehicleClassProvider>().searchValue = value;
                    // if(value.length >= 3){
                    //   context.read<VehicleClassProvider>().vehicleClassApi(context);
                    // }
                    // else if(value.isEmpty){
                    //   context.read<VehicleClassProvider>().vehicleClassApi(context);
                    // }
                  },
                  onCloseClick: () {
                    context.read<VehicleClassProvider>().searchController.clear();
                    context.read<VehicleClassProvider>().vehicleClassApi(context);
                  },
                  controller: context.watch<VehicleClassProvider>().searchController,
                ),
              ),
              SizedBox(height: 12.0),

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
                    : ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: classProvider.length +
                      (context.watch<VehicleClassProvider>().isLoadMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index ==
                        classProvider.length) {
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
                          confirmationDialogBox(context: context);
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
