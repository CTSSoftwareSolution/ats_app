import 'package:ats_app/Presentation/provider/lane_list_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/appointment_card_shimmer.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_list_summary.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/new_app_theme/app_text.dart';
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

  String _categorySuffix(String laneName) =>
      laneName.isEmpty || laneName == 'All' ? '' : ' in $laneName';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleClassProvider>();
    final laneName = context.select<LaneListProvider, String>((p) => p.selectedFilter);
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
              child: provider.isLoading ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.lg),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, __) => const AppointmentCardShimmer(),
              ) : (provider.vehicleClassEntity?.data?.appointments?.isEmpty ?? true)
                  ? PullToRefreshFill(
                child: provider.searchValue.isNotEmpty
                    ? EmptyStateWidget(
                  icon: Icons.search_off_rounded,
                  title: 'No matching appointments',
                  subtitle: 'Nothing matches "${provider.searchValue}"${_categorySuffix(laneName)}. Check the spelling or try another search.',
                )
                    : EmptyStateWidget(
                  icon: Icons.event_available_outlined,
                  title: 'No appointments',
                  subtitle: laneName.isEmpty || laneName == 'All'
                      ? 'New appointments will appear here. Pull down to refresh, or check your connection if this persists.'
                      : 'There are no appointments in $laneName. Try another category or pull down to refresh.',
                  actionLabel: 'Refresh',
                  onAction: _onRefresh,
                ),
              ) : ListView.builder(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                // Summary + appointments + footer (loading more / end of list).
                itemCount: provider.vehicleClassEntity!.data!.appointments!.length + 2,
                itemBuilder: (context, index) {
                  final appointments = provider.vehicleClassEntity!.data!.appointments!;
                  if (index == 0) {
                    return HomeListSummary(
                      totalRecords: provider.vehicleClassEntity!.data!.totalRecords,
                      loadedCount: appointments.length,
                      category: laneName,
                      search: provider.searchValue,
                    );
                  }
                  if (index == appointments.length + 1) {
                    return _ListFooter(
                      isLoadingMore: provider.isLoadMore,
                      reachedEnd: !provider.hasMoreData,
                      count: appointments.length,
                    );
                  }
                  final item = appointments[index - 1];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page, 0, AppSpacing.page, AppSpacing.md),
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

/// Last list item: a spinner while the next page loads, a quiet
/// end-of-list note once everything is loaded, otherwise nothing.
class _ListFooter extends StatelessWidget {
  final bool isLoadingMore;
  final bool reachedEnd;
  final int count;

  const _ListFooter({
    required this.isLoadingMore,
    required this.reachedEnd,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }
    if (!reachedEnd) return const SizedBox(height: AppSpacing.sm);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.page, vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              count == 1 ? '1 appointment' : 'All $count appointments shown',
              style: AppText.caption,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
