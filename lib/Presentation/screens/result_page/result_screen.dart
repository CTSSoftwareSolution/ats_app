import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/provider/manual_inspection_list_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_shimmer.dart';
import 'package:ats_app/Presentation/screens/result_page/result_screen_item.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../widgets/custom_search_bar.dart';
import '../pre_inspection_form/inspection_page/inspection_page.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ManualInspectionListProvider>().manualInspectionListAPI(context: context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ManualInspectionListProvider>().manualInspectionListAPI(context: context, loadMore: true);
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
    final provider = context.watch<ManualInspectionListProvider>();
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: const Text("Result"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.sm),
              child: CustomSearchTextField(
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
              child: provider.isLoading ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, __) => const HomeShimmer(),
              ) : (provider.manualInspectionEntity?.data?.appointments?.isEmpty ?? true)
                  ? const EmptyStateWidget(
                icon: Icons.search_off_rounded,
                title: 'No Appointments Found',
                subtitle: 'Try changing the filter or search term',
              ) : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page, AppSpacing.xs, AppSpacing.page, 100),
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: provider.manualInspectionEntity!.data!.appointments!.length + (provider.isLoadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  final appointments = provider.manualInspectionEntity!.data!.appointments!;
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
                  return ResultScreenItem(appointments: item,
                      onRetest: (){
                    context.read<ManualInspectionListProvider>().setManualInspectionScreen(true);
                    provider.setSelectedManualListData(item);
                    context.read<AiInspectionDetailsProvider>().setAIMode(false);
                    context.push(InspectionPage(isEditMode: true));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
