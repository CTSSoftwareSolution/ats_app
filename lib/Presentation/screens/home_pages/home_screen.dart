import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_shimmer.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';

import '../../provider/manual_inspection_list_provider.dart';
import '../../provider/new_vehicle_list_provider.dart';
import '../../provider/vehicle_class_provider.dart';
import '../manual_inspection_images/manual_inspection_image_screen.dart';
import '../vehicles_class_page/vehicle_class_screen_item.dart';
import 'home_widgets/build_header_home.dart';
import 'home_widgets/search_filter_bar_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NewVehicleListProvider>().vehicleListApi(context: context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<NewVehicleListProvider>().vehicleListApi(context: context, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewVehicleListProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),

      body: SafeArea(
        child: Column(
          children: [
            BuildHeaderHome(),
            SearchFilterBarHome(provider: provider),
            Expanded(
              child: provider.isLoading ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, __) => const HomeShimmer(),
              ) : (provider.newVehicleListEntity?.data?.rows?.isEmpty ?? true)
                  ? const EmptyStateWidget(
                icon: Icons.search_off_rounded,
                title: 'No Appointments Found',
                subtitle: 'Try changing the filter or search term',
              ) : ListView.builder(
                padding: EdgeInsets.only(bottom: 100),
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: provider.newVehicleListEntity!.data!.rows!.length + (provider.isLoadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  final appointments = provider.newVehicleListEntity!.data!.rows!;
                  if (index == appointments.length) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: appColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }
                  final item = appointments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: VehicleClassScreenItem(
                      vehicleDataModel: item,
                      onTap: () {
                        context.read<ManualInspectionListProvider>().setManualInspectionScreen(false);
                       provider.setSelectedClass(item);
                        context.push(ManualInspectionImageScreen());
                       //  debugPrint("RegNo on list : ${item.registrationNo}");
                       //  context.push( VehicleDetailScreen(vehicleId: item.registrationNo.toString(),));
                        },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
