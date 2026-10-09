import 'package:ats_app/Presentation/provider/ai_inspection_list_provider.dart';
import 'package:ats_app/Presentation/provider/ai_result_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/ai_inspection_list/ai_inspection_list_item.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_shimmer.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/model/response_model/ai_inspection_list_res_model.dart';
import '../../../EmptyStateWidget.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_search_bar.dart';
import '../../../widgets/new_app_ui/app_back_button.dart';
import '../../../widgets/new_app_ui/app_state_view.dart';
import '../../../widgets/new_app_ui/pull_to_refresh_fill.dart';
import '../ai_result/ai_result_screen.dart';

class AiInspectionListScreen extends StatefulWidget {
  const AiInspectionListScreen({super.key});

  @override
  State<AiInspectionListScreen> createState() => _AiInspectionListScreenState();
}

class _AiInspectionListScreenState extends State<AiInspectionListScreen> {

  final ScrollController _scrollController = ScrollController();

  /// True while a pull-to-refresh request is in flight.
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetched once per screen open, not on rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AiInspectionListProvider>().aiInspectedList();
    });
    _scrollController.addListener(() {
      // No paging while the first page is being reloaded (the pull's
      // overscroll on a short list would otherwise trigger it).
      if (_isRefreshing) return;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<AiInspectionListProvider>().aiInspectedList(loadMore: true);
      }
    });
  }

  /// Reloads the first page with the current search text.
  Future<void> _onRefresh() async {
    final provider = context.read<AiInspectionListProvider>();
    if (_isRefreshing || provider.isLoading) return;
    _isRefreshing = true;
    try {
      await provider.aiInspectedList();
    } finally {
      _isRefreshing = false;
    }
  }

  /// Opens the AI result for [item] through the existing AI result flow.
  Future<void> _openResult(Appointments item) async {
    final listProvider = context.read<AiInspectionListProvider>();
    context.read<VehicleClassProvider>().setSelectedClass(listProvider.toSelectedClass(item));
    CustomLoader.showLoader("Loading result...");
    final result = await context.read<AiResultProvider>().aiResultDetails(context);
    if (!mounted) return;
    final message = result?.message?.trim() ?? "";
    if (result == null || result.success == false) {
      CustomLoader.errorMessage(
        message.isNotEmpty ? message : "Unable to load result. Please try again.",
      );
      return;
    }
    context.push(const AiResultScreen());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBody(AiInspectionListProvider provider) {
    if (provider.isLoading) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => const HomeShimmer(),
      );
    }
    final error = provider.errorMessage;
    if (error != null) {
      return PullToRefreshFill(
        child: Center(
          child: AppStateView(
            icon: Icons.error_outline_rounded,
            color: fail,
            title: 'Something went wrong',
            message: error,
            onAction: () => provider.aiInspectedList(),
          ),
        ),
      );
    }
    final appointments = provider.appointments;
    if (appointments.isEmpty) {
      return const PullToRefreshFill(
        child: EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'No AI Inspections Found',
          subtitle: 'Try changing the search term or pull to refresh',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.page, AppSpacing.xs, AppSpacing.page, AppSpacing.lg),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: appointments.length + (provider.isLoadMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == appointments.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: appColor,
                strokeWidth: 2.5,
              ),
            ),
          );
        }
        final item = appointments[index];
        return AiInspectionListItem(
          appointment: item,
          onTap: () => _openResult(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiInspectionListProvider>();
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.page,
        backgroundColor: appColor,
        title: const Text("AI Inspections"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.sm),
              child: CustomSearchTextField(
                onChanged: provider.onSearchChanged,
                controller: provider.searchController,
                suffixIcon: provider.searchValue.isEmpty
                    ? null
                    : SearchClearButton(onPressed: provider.clearSearch),
              ),
            ),
            Expanded(
              // Wraps every state so the indicator stays mounted while the
              // list is swapped for the shimmer during a reload.
              child: RefreshIndicator(
                color: appColor,
                backgroundColor: surface,
                onRefresh: _onRefresh,
                child: _buildBody(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
