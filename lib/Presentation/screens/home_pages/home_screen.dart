import 'package:ats_app/Presentation/provider/lane_list_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/appointment_card_shimmer.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_list_summary.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/new_app_ui/list_footer.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_theme.dart';
import '../../../widgets/new_app_ui/pull_to_refresh_fill.dart';
import '../../../widgets/new_app_ui/section_header.dart';
import '../../../Data/model/response_model/vehicle_class_res_model.dart';
import 'home_widgets/appointment_status.dart';
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

  /// Appointment the inspector last opened. Display only: it is looked up in
  /// the freshly loaded list so the "Current inspection" card is never stale.
  num? _currentAppointmentId;

  @override
  void initState() {
    super.initState();
    final provider = context.read<VehicleClassProvider>();
    _currentAppointmentId = provider.selectedClass?.appointmentId;
    provider.vehicleClassApi(context: context);
    _scrollController.addListener(() {
      // The listener fires on every scroll frame, so only ask for the next
      // page when none is in flight, there is more to load, and the user has
      // actually scrolled into the list. At the top (pixels <= 0) the gesture
      // is a pull-to-refresh: on a short list "near the end" is always true
      // there and would otherwise send a page request per frame.
      if (_isRefreshing) return;
      final provider = context.read<VehicleClassProvider>();
      if (provider.isLoading || provider.isLoadMore || !provider.hasMoreData) {
        return;
      }
      final position = _scrollController.position;
      if (position.pixels <= 0) return;
      if (position.pixels >= position.maxScrollExtent - 200) {
        provider.vehicleClassApi(context: context, loadMore: true);
      }
    });
  }

  /// Reloads the first page with the current search and category filter.
  Future<void> _onRefresh() async {
    final provider = context.read<VehicleClassProvider>();
    // One request at a time: ignore the pull while a refresh, the first
    // load, or a "load more" page is already running (a reload during
    // paging would race with the page being appended).
    if (_isRefreshing || provider.isLoading || provider.isLoadMore) return;
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

  /// Nothing to list. Each case offers the quickest way back to a list; the
  /// actions reuse the existing search box, category chip and refresh paths.
  ///
  /// The provider reports a failed request the same way as an empty one, so
  /// the default case also covers "couldn't load" and offers Retry.
  Widget _buildEmptyState(VehicleClassProvider provider, String laneName) {
    final Widget state;
    if (provider.searchValue.isNotEmpty) {
      state = AppStateView.empty(
        icon: Icons.search_off_rounded,
        title: 'No matching vehicles',
        message:
            'Nothing matches "${provider.searchValue}"${_categorySuffix(laneName)}. Check the registration or booking ID.',
        actionLabel: 'Clear search',
        actionIcon: Icons.close_rounded,
        // Same as deleting the text in the search box.
        onAction: () {
          provider.searchController.clear();
          provider.onSearchChanged(context, '');
        },
      );
    } else if (laneName.isNotEmpty && laneName != 'All') {
      state = AppStateView.empty(
        icon: Icons.filter_alt_off_outlined,
        title: 'No vehicles in $laneName',
        message: 'Try another category, or pull down to refresh.',
        actionLabel: 'Show all categories',
        actionIcon: Icons.filter_list_off_rounded,
        // Same as tapping the "All" chip.
        onAction: () => context.read<LaneListProvider>().onChipSelected(
          'All',
          onChanged: () => provider.onFilterChanged(context, 'All'),
        ),
      );
    } else {
      state = AppStateView.empty(
        icon: Icons.event_available_outlined,
        title: 'No appointments to show',
        message:
            'New appointments will appear here. If you expected some, check your connection and try again.',
        actionLabel: 'Retry',
        onAction: _onRefresh,
      );
    }
    return Center(child: SingleChildScrollView(child: state));
  }

  /// Opens the inspection flow for [item] (unchanged behaviour), remembering
  /// it as the current inspection for the card at the top of the list.
  void _openInspection(VehicleClassProvider provider, Appointments item) {
    setState(() => _currentAppointmentId = item.appointmentId);
    context.read<ManualInspectionListProvider>().setManualInspectionScreen(
      false,
    );
    provider.setSelectedClass(item);
    context.push(ManualInspectionImageScreen());
  }

  /// The last opened appointment if it is in the loaded list and not yet
  /// completed.
  Appointments? _currentInspection(List<Appointments> appointments) {
    final id = _currentAppointmentId;
    if (id == null) return null;
    for (final item in appointments) {
      if (item.appointmentId == id) {
        return AppointmentStatus(item).phase == InspectionPhase.completed
            ? null
            : item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleClassProvider>();
    final laneName = context.select<LaneListProvider, String>(
      (p) => p.selectedFilter,
    );
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
                  child: provider.isLoading
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.page,
                            AppSpacing.md,
                            AppSpacing.page,
                            AppSpacing.lg,
                          ),
                          // Summary line + cards, shaped like the real list.
                          itemCount: 5,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (_, index) => index == 0
                              ? const HomeListSummarySkeleton()
                              : const AppointmentCardShimmer(),
                        )
                      : (provider
                                .vehicleClassEntity
                                ?.data
                                ?.appointments
                                ?.isEmpty ??
                            true)
                      ? PullToRefreshFill(
                          child: _buildEmptyState(provider, laneName),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          // [Current inspection] + summary + appointments +
                          // footer (loading more / end of list).
                          itemCount:
                              provider
                                  .vehicleClassEntity!
                                  .data!
                                  .appointments!
                                  .length +
                              2 +
                              (_currentInspection(
                                        provider
                                            .vehicleClassEntity!
                                            .data!
                                            .appointments!,
                                      ) ==
                                      null
                                  ? 0
                                  : 1),
                          itemBuilder: (context, index) {
                            final appointments = provider
                                .vehicleClassEntity!
                                .data!
                                .appointments!;
                            final current = _currentInspection(appointments);
                            if (current != null) {
                              if (index == 0) {
                                return _CurrentInspection(
                                  item: current,
                                  onTap: () =>
                                      _openInspection(provider, current),
                                );
                              }
                              index -= 1;
                            }
                            if (index == 0) {
                              return HomeListSummary(
                                totalRecords: provider
                                    .vehicleClassEntity!
                                    .data!
                                    .totalRecords,
                                loadedCount: appointments.length,
                                category: laneName,
                                search: provider.searchValue,
                              );
                            }
                            if (index == appointments.length + 1) {
                              return ListFooter(
                                isLoadingMore: provider.isLoadMore,
                                reachedEnd: !provider.hasMoreData,
                                count: appointments.length,
                                singular: 'appointment',
                                plural: 'appointments',
                              );
                            }
                            final item = appointments[index - 1];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.page,
                                0,
                                AppSpacing.page,
                                AppSpacing.md,
                              ),
                              child: VehicleClassScreenItem(
                                classDataModel: item,
                                onTap: () => _openInspection(provider, item),
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

/// "CURRENT INSPECTION" label and the brand-outlined card of the appointment
/// the inspector last opened, pinned above the list.
class _CurrentInspection extends StatelessWidget {
  final Appointments item;
  final VoidCallback onTap;

  const _CurrentInspection({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader('Current inspection'),
          VehicleClassScreenItem(
            classDataModel: item,
            highlighted: true,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
