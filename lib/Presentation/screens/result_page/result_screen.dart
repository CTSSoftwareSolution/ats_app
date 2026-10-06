import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/provider/manual_inspection_list_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/appointment_card_shimmer.dart';
import '../../../Data/model/response_model/manual_inspection_list_model.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../widgets/new_app_ui/status_badge.dart';
import 'package:ats_app/Presentation/screens/result_page/result_screen_item.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/new_app_ui/list_footer.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/new_app_ui/pull_to_refresh_fill.dart';
import '../pre_inspection_form/inspection_page/inspection_page.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

  /// True while a pull-to-refresh request is in flight.
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    context.read<ManualInspectionListProvider>().manualInspectionListAPI(
      context: context,
    );
    _scrollController.addListener(() {
      // The listener fires on every scroll frame, so only ask for the next
      // page when none is in flight, there is more to load, and the user has
      // actually scrolled into the list. At the top (pixels <= 0) the gesture
      // is a pull-to-refresh: on a short list "near the end" is always true
      // there and would otherwise send a page request per frame.
      if (_isRefreshing) return;
      final provider = context.read<ManualInspectionListProvider>();
      if (provider.isLoading || provider.isLoadMore || !provider.hasMoreData) {
        return;
      }
      final position = _scrollController.position;
      if (position.pixels <= 0) return;
      if (position.pixels >= position.maxScrollExtent - 200) {
        provider.manualInspectionListAPI(context: context, loadMore: true);
      }
    });
  }

  /// Reloads the first page with the current search text.
  Future<void> _onRefresh() async {
    final provider = context.read<ManualInspectionListProvider>();
    // One request at a time: ignore the pull while a refresh, the first
    // load, or a "load more" page is already running (a reload during
    // paging would race with the page being appended).
    if (_isRefreshing || provider.isLoading || provider.isLoadMore) return;
    _isRefreshing = true;
    try {
      await provider.manualInspectionListAPI(context: context);
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
    final provider = context.watch<ManualInspectionListProvider>();
    return Scaffold(
      backgroundColor: bg,
      appBar: const AppTopBar(title: "Result"),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: bg,
                border: Border(bottom: BorderSide(color: border)),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.md,
              ),
              child: CustomSearchTextField(
                hint: 'Search results',
                onChanged: (v) => provider.onSearchChanged(context, v),
                controller: provider.searchController,
                suffixIcon: provider.searchValue.isEmpty
                    ? null
                    : SearchClearButton(
                        onPressed: () {
                          provider.searchController.clear();
                          provider.onFilterChanged(context);
                        },
                      ),
              ),
            ),
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
                          AppSpacing.lg,
                          AppSpacing.page,
                          AppSpacing.lg,
                        ),
                        itemCount: 4,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (_, __) => const AppointmentCardShimmer(),
                      )
                    : (provider
                              .manualInspectionEntity
                              ?.data
                              ?.appointments
                              ?.isEmpty ??
                          true)
                    ? PullToRefreshFill(
                        child: provider.searchValue.isNotEmpty
                            ? EmptyStateWidget(
                                icon: Icons.search_off_rounded,
                                title: 'No matching results',
                                subtitle:
                                    'No results for "${provider.searchValue}". Check the spelling or try another search.',
                              )
                            : EmptyStateWidget(
                                icon: Icons.fact_check_outlined,
                                title: 'No Results Yet',
                                subtitle:
                                    'Completed inspections will appear here. Pull down to refresh.',
                                actionLabel: 'Refresh',
                                onAction: _onRefresh,
                              ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.page,
                          0,
                          AppSpacing.page,
                          AppSpacing.lg,
                        ),
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        // Summary + results + footer (loading more / end of list).
                        itemCount:
                            provider
                                .manualInspectionEntity!
                                .data!
                                .appointments!
                                .length +
                            2,
                        itemBuilder: (context, index) {
                          final appointments = provider
                              .manualInspectionEntity!
                              .data!
                              .appointments!;
                          if (index == 0) {
                            return _ResultSummary(
                              totalRecords: provider
                                  .manualInspectionEntity!
                                  .data!
                                  .totalRecords,
                              results: appointments,
                              search: provider.searchValue,
                            );
                          }
                          if (index == appointments.length + 1) {
                            return ListFooter(
                              isLoadingMore: provider.isLoadMore,
                              reachedEnd: !provider.hasMoreData,
                              count: appointments.length,
                              singular: 'result',
                              plural: 'results',
                            );
                          }
                          final item = appointments[index - 1];
                          return ResultScreenItem(
                            appointments: item,
                            onRetest: () {
                              context
                                  .read<ManualInspectionListProvider>()
                                  .setManualInspectionScreen(true);
                              provider.setSelectedManualListData(item);
                              context
                                  .read<AiInspectionDetailsProvider>()
                                  .setAIMode(false);
                              context.push(InspectionPage(isEditMode: true));
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top of the results list: total count, the active search, and a
/// Pass / Fail / Pending tally of the results loaded so far.
class _ResultSummary extends StatelessWidget {
  final num? totalRecords;
  final List<ManualLisAppointments> results;
  final String search;

  const _ResultSummary({
    required this.totalRecords,
    required this.results,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    int passCount = 0, failCount = 0;
    for (final r in results) {
      if (r.manualStatus == "Pass") passCount++;
      if (r.manualStatus == "Fail") failCount++;
    }
    final otherCount = results.length - passCount - failCount;
    final total = (totalRecords != null && totalRecords! > 0)
        ? totalRecords!.toInt()
        : results.length;
    final scope = <String>[
      if (search.isNotEmpty) '"$search"',
      results.length < total
          ? 'Counts for the ${results.length} loaded'
          : 'All results',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                child: Text(
                  'Inspection results',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sectionTitle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$total',
                  maxLines: 1,
                  style: AppText.chip.copyWith(color: appColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            scope,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              StatusBadge.pass(label: '$passCount Pass', dense: true),
              StatusBadge.fail(label: '$failCount Fail', dense: true),
              if (otherCount > 0)
                StatusBadge.pending(label: '$otherCount Pending', dense: true),
            ],
          ),
        ],
      ),
    );
  }
}
