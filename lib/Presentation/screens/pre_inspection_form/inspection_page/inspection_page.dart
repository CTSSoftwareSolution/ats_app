import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/submit_fab_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/Presentation/screens/common/vehicle_subtitle.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:provider/provider.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';
import '../../../provider/manual_inspection_list_provider.dart';
import '../inspection_widgets/error_screen.dart';
import '../inspection_widgets/loading_screen.dart';
import '../inspection_widgets/section_tab_view.dart';

class InspectionPage extends StatefulWidget {
  final bool? isEditMode;

  const InspectionPage({super.key, this.isEditMode});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

// TickerProviderStateMixin (not Single...) because the TabController is
// recreated whenever the number of visible sections changes.
class _InspectionPageState extends State<InspectionPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //  _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InspectionFormProvider>();
      final detailsProvider = context.read<AiInspectionDetailsProvider>();

      final manualProvider = Provider.of<ManualInspectionListProvider>(
        context,
        listen: false,
      );
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

      _tabController = TabController(length: length, vsync: this);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppTopBar(
            title: provider.inspectionMode == InspectionMode.underPitInspection
                ? "Under-PIT Inspection"
                : "Visual Inspection",
            subtitle: vehicleSubtitle(context, fromResultList: true),
            onBack: () {
              context.pop();
            },
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

    // The controller is (re)created after this frame; until it matches the
    // sections, a same-height placeholder keeps the layout from jumping and
    // avoids building TabBar/TabBarView without a valid controller.
    final tabsReady =
        sections.isNotEmpty &&
        _tabController != null &&
        _tabController!.length == sections.length;

    // A single section (Under-PIT) needs no tab strip.
    final showTabs = sections.length > 1;

    return Column(
      children: [
        if (showTabs)
          Container(
            color: appColor,
            child: !tabsReady
                ? const SizedBox(height: 52, width: double.infinity)
                : TabBar(
                    controller: _tabController,
                    isScrollable: sections.length > 3,
                    tabAlignment: sections.length > 3
                        ? TabAlignment.start
                        : null,
                    indicatorColor: textWhite,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: textWhite,
                    unselectedLabelColor: textWhiteSub,
                    labelStyle: AppText.chip.copyWith(letterSpacing: 0.2),
                    unselectedLabelStyle: AppText.chip.copyWith(
                      fontFamily: "Medium",
                      letterSpacing: 0.2,
                    ),
                    tabs: List.generate(sections.length, (i) {
                      final s = sections[i];
                      return Tab(
                        height: 52,
                        // "Pre-Inspection  12/20" – name plus progress, or a check
                        // once the section is complete.
                        child: Semantics(
                          label: s.isComplete
                              ? '${s.label}, complete'
                              : '${s.label}, ${s.totalAnswered} of ${s.totalQuestions} answered',
                          excludeSemantics: true,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  s.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              s.isComplete
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: textWhite,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: textWhite.withValues(
                                          alpha: 0.16,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Text(
                                        '${s.totalAnswered}/${s.totalQuestions}',
                                        style: AppText.caption.copyWith(
                                          color: textWhite,
                                          fontFamily: "SemiBold",
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ),

        _buildFilterBar(provider),

        Expanded(
          child: sections.isEmpty
              ? _buildEmptyFilter(provider)
              : !tabsReady
              ? const LoadingScreen()
              : TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    sections.length,
                    (i) => SectionTabView(sectionIndex: i),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(InspectionFormProvider provider) {
    final answered = provider.visibleAnsweredQuestions;
    final unanswered = provider.visibleTotalQuestions - answered;
    // Failed answers in the sections on screen (grandTotalNo counts every
    // section, including ones hidden in this mode).
    final no = provider.visibleSections.fold<int>(
      0,
      (sum, s) =>
          sum +
          s.categories.fold<int>(
            0,
            (c, cat) =>
                c +
                cat.questions.where((q) => q.answer == AnswerState.Fail).length,
          ),
    );

    return Container(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.sm,
      ),
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

    final iconColor =
        filter == QuestionFilter.no || filter == QuestionFilter.unanswered
        ? pass
        : na;

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
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      excludeSemantics: true,
      child: Material(
        color: selected ? color.withValues(alpha: 0.1) : surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 44,
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
                  style: AppText.chip.copyWith(
                    color: selected ? color : textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? color : surface2,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? textWhite : textSecondary,
                      fontSize: 11,
                      fontFamily: "Bold",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
