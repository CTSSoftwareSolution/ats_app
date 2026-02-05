import 'package:ats_app/Presentation/provider/MediaPicker/file_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/vehicle_test_parameter/vehicle_parts_screen.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_responsive_screen.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen_item.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
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





  @override
  Widget build(BuildContext context) {
    final vehicleType = context.watch<VehicleTypeProvider>().selectedType!.vehicleType;

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
        child: VehicleClassResponsiveLayout()

      ),
    );
  }
}
