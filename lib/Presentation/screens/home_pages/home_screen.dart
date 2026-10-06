import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_shimmer.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';
import '../../../new_manual_flow/new_screen/vehicle_details_screen.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_theme.dart';
import '../../../widgets/new_app_ui/pull_to_refresh_fill.dart';
import '../../provider/manual_inspection_list_provider.dart';
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

  /// True while a pull-to-refresh request is in flight.
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    context.read<VehicleClassProvider>().vehicleClassApi(context: context);
    _scrollController.addListener(() {
      // No paging while the first page is being reloaded (the pull's
      // overscroll on a short list would otherwise trigger it).
      if (_isRefreshing) return;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<VehicleClassProvider>().vehicleClassApi(context: context, loadMore: true);
      }
    });
  }

  /// Reloads the first page with the current search and category filter.
  Future<void> _onRefresh() async {
    final provider = context.read<VehicleClassProvider>();
    if (_isRefreshing || provider.isLoading) return;
    _isRefreshing = true;
    try {
      await provider.vehicleClassApi(context: context);
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleClassProvider>();
    // Status bar blends into the brand header: same colour behind it (also on
    // edge-to-edge Android, where statusBarColor is ignored) and light icons.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.statusBarStyle,
      child: Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ColoredBox(
              color: appColor,
              child: SafeArea(bottom: false, child: BuildHeaderHome()),
            ),
            SearchFilterBarHome(provider: provider),
            Expanded(
              // Wraps every state so the indicator stays mounted while the
              // list is swapped for the shimmer during a reload.
              child: RefreshIndicator(
              color: appColor,
              backgroundColor: surface,
              onRefresh: _onRefresh,
              child: provider.isLoading ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, __) => const HomeShimmer(),
              ) : (provider.vehicleClassEntity?.data?.appointments?.isEmpty ?? true)
                  ? const PullToRefreshFill(
                child: EmptyStateWidget(
                icon: Icons.search_off_rounded,
                title: 'No Appointments Found',
                subtitle: 'Try changing the filter or search term',
              ),
              ) : ListView.builder(
                padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.lg),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: provider.vehicleClassEntity!.data!.appointments!.length + (provider.isLoadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  final appointments = provider.vehicleClassEntity!.data!.appointments!;
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: 6),
                    child: VehicleClassScreenItem(
                      classDataModel: item,
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
            ),
          ],
        ),
      ),
    ),
    );
  }
}
