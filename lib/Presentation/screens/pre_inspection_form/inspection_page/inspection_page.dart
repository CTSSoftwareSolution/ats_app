import 'package:ats_app/Presentation/provider/ai_inspection_details_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/submit_fab_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../EmptyStateWidget.dart';
import '../../../../widgets/app_ui.dart';
import '../../../provider/vehicle_class_provider.dart';
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
    final manualProvider = context.watch<ManualInspectionListProvider>();
    final isAIMode = context.watch<AiInspectionDetailsProvider>().isAIModeOn;
    final regNo = (manualProvider.isManualInspectionScreen
                ? manualProvider.selectedManualListData?.registrationNo
                : context.watch<VehicleClassProvider>().selectedClass?.registrationNo)
            ?.toString() ??
        '';
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Inspection"),
                if (regNo.isNotEmpty)
                  Text(
                    regNo.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontFamily: "SemiBold",
                      color: textWhiteSub,
                      letterSpacing: 0.8,
                    ),
                  ),
              ],
            ),
            leading: AppBackButton(
              onPressed: (){
                context.pop();
                },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAIMode ? Icons.auto_awesome_rounded : Icons.edit_note_rounded,
                        size: 15,
                        color: whiteColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAIMode ? "AI Result" : "Manual",
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "SemiBold",
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bg,
          body: _buildBody(provider),
          floatingActionButton: (!provider.isLoading && !provider.hasError)
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
            labelColor: Colors.white,
            unselectedLabelColor: textWhiteSub,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontFamily: "Bold",
              letterSpacing: 0.3,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontFamily: "Medium",
              letterSpacing: 0.3,
            ),
            tabs: List.generate(sections.length, (i) {
              final s = sections[i];
              return Tab(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(s.icon, size: 18),
                    if (s.isComplete)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                            border: Border.all(color: appColor, width: 1.5),
                          ),
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

    final total = provider.visibleTotalQuestions;
    return Container(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : answered / total,
                    minHeight: 6,
                    backgroundColor: surface2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        provider.isFullyComplete ? pass : appColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$answered/$total answered',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "SemiBold",
                  color: textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  count: total,
                  selected: provider.filter == QuestionFilter.all,
                  color: appColor,
                  onTap: () => provider.setFilter(QuestionFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Answered',
                  count: answered,
                  selected: provider.filter == QuestionFilter.answered,
                  color: pass,
                  onTap: () => provider.setFilter(QuestionFilter.answered),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pending',
                  count: unanswered,
                  selected: provider.filter == QuestionFilter.unanswered,
                  color: warn,
                  onTap: () => provider.setFilter(QuestionFilter.unanswered),
                ),
                const SizedBox(width: 8),
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
        ],
      ),
    );
  }

  Widget _buildEmptyFilter(InspectionFormProvider provider) {
    final filter = provider.filter;

    final icon = filter == QuestionFilter.answered
        ? Icons.check_circle_outline
        : filter == QuestionFilter.unanswered
        ? Icons.task_alt_rounded
        : filter == QuestionFilter.no
        ? Icons.verified_outlined
        : Icons.inbox_outlined;

    final message = filter == QuestionFilter.answered
        ? 'No questions answered yet'
        : filter == QuestionFilter.unanswered
        ? 'All questions answered!'
        : filter == QuestionFilter.no
        ? 'No failed questions found'
        : 'No questions found';

    return EmptyStateWidget(
      icon: icon,
      title: message,
      subtitle: filter == QuestionFilter.all
          ? 'There are no inspection items to show'
          : 'Switch the filter above to see other items',
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
    return Material(
      color: selected ? color.withValues(alpha: 0.10) : surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(color: selected ? color : border, width: selected ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: selected ? "Bold" : "SemiBold",
                  color: selected ? color : textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                constraints: const BoxConstraints(minWidth: 22),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? color : surface2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? whiteColor : textSecondary,
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
