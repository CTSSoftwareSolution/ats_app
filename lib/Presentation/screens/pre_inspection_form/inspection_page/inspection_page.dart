import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/submit_fab_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utilities/app_theme.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../widgets/app_ui.dart';
import '../../../../widgets/new_app_ui/app_back_button.dart';
import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../../provider/manual_inspection_list_provider.dart';
import '../inspection_widgets/error_screen.dart';
import '../inspection_widgets/loading_screen.dart';
import '../inspection_widgets/section_tab_view.dart';

class InspectionPage extends StatefulWidget {
  final bool? isEditMode;

  const InspectionPage({super.key, this.isEditMode,});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage>
    with SingleTickerProviderStateMixin {
   TabController? _tabController;

  @override
  void initState() {
    super.initState();
  //  _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InspectionFormProvider>();
      final detailsProvider = context.read<AiInspectionDetailsProvider>();

      final manualProvider = Provider.of<ManualInspectionListProvider>(context, listen: false);
       provider.fetchInspectionData();
      // if(detailsProvider.isAIModeOn){
      //   detailsProvider.aiInspectionDetails(context);
      // }
      // if (widget.isEditMode == true) {
      //   provider.fetchAndPrefill(
      //       vehicleNo: manualProvider.selectedManualListData!.registrationNo.toString(),
      //       appointmentID: manualProvider.selectedManualListData!.appointmentId.toString());
      // }
      // else {
      //   provider.fetchInspectionData();
      // }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final count =
  //       context.read<InspectionFormProvider>()
  //           .visibleSections
  //           .length;
  //
  //   if (count > 0) {
  //     _tabController = TabController(
  //       length: count,
  //       vsync: this,
  //     );
  //   }
  // }
  //
  // @override
  //
  //
  //
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

   void _updateTabController(int length) {
     if (length <= 0) return;

     if (_tabController?.length != length) {
       _tabController?.dispose();

       _tabController = TabController(
         length: length,
         vsync: this,
       );

       setState(() {});
     }
   }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0,
            backgroundColor: appColor,
            title: const Text("Inspection"),
            leading: AppBackButton(
              onPressed: (){
                context.pop();
                },
            ),
          ),
          backgroundColor: bg,
          body: _buildBody(provider),
          bottomNavigationBar: (!provider.isLoading && !provider.hasError)
              ? SubmitFAB(provider: provider)
              : null,
        );
      },
    );
  }

  Widget _buildBody(InspectionFormProvider provider) {
    if (provider.isLoading) return const LoadingScreen();
    if (provider.hasError) return ErrorScreen(provider: provider);

    // if (provider.sections.isEmpty) {
    //   return const Center(child: Text("No sections available"));
    // }

   // final sections = provider.filteredSections;
    final sections = provider.visibleSections;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTabController(sections.length);
    });

    return Column(
      children: [
        Container(
          color: appColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: textWhiteSub,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontFamily: "SemiBold",
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontFamily: "Medium",
              letterSpacing: 0.2,
            ),
            tabs: List.generate(sections.length, (i) {
              final s = sections[i];
              return Tab(
                height: 60,
                iconMargin: const EdgeInsets.only(bottom: 4),
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(s.icon, size: 20),
                    if (s.isComplete)
                      Positioned(
                        right: -7,
                        top: -5,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: pass,
                            shape: BoxShape.circle,
                            border: Border.all(color: appColor, width: 1.5),
                          ),
                          child: const Icon(Icons.check_rounded,
                              size: 9, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                text: 'Step ${i + 1}',
              );
            }),
          ),
        ),

        _buildFilterBar(provider),

        Expanded(
          child: sections.isEmpty
              ? _buildEmptyFilter(provider)
              : TabBarView(
            controller: _tabController,
            children: List.generate(
              sections.length,
                  (i) => SectionTabView(sectionIndex: i,),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(InspectionFormProvider provider) {
    final answered = provider.visibleAnsweredQuestions;
    final unanswered = provider.visibleTotalQuestions - answered;
    final no = provider.grandTotalNo;

    return Container(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.page, vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              count: provider.visibleTotalQuestions,
              selected: provider.filter == QuestionFilter.all,
              color: appColor,
              onTap: () => provider.setFilter(QuestionFilter.all),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Answered',
              count: answered,
              selected: provider.filter == QuestionFilter.answered,
              color: pass,
              onTap: () => provider.setFilter(QuestionFilter.answered),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'Pending',
              count: unanswered,
              selected: provider.filter == QuestionFilter.unanswered,
              color: warn,
              onTap: () => provider.setFilter(QuestionFilter.unanswered),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'No',
              count: no,
              selected: provider.filter == QuestionFilter.no,
              color: fail,
              onTap: () => provider.setFilter(QuestionFilter.no),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilter(InspectionFormProvider provider) {
    final filter = provider.filter;

    final icon = filter == QuestionFilter.answered
        ? Icons.check_circle_outline
        : filter == QuestionFilter.unanswered
        ? Icons.pending_outlined
        : filter == QuestionFilter.no
        ? Icons.cancel_outlined
        : Icons.inbox_outlined;

    final message = filter == QuestionFilter.answered
        ? 'No questions answered yet'
        : filter == QuestionFilter.unanswered
        ? 'All questions answered!'
        : filter == QuestionFilter.no
        ? 'No failed questions found'
        : 'No questions found';

    final iconColor = filter == QuestionFilter.no || filter == QuestionFilter.unanswered
        ? pass
        : textMuted;

    return Center(
      child: SingleChildScrollView(
        child: AppStateView(icon: icon, color: iconColor, title: message),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(100);
    return Material(
      color: selected ? color.withValues(alpha: 0.1) : surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? color : border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "SemiBold",
                  color: selected ? color : textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                constraints: const BoxConstraints(minWidth: 22),
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? color : surface2,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : textSecondary,
                    fontSize: 11,
                    fontFamily: "Bold",
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
