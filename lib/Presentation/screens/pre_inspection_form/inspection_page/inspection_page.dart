import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/submit_fab_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/inspection_form_provider.dart';
import '../inspection_widgets/error_screen.dart';
import '../inspection_widgets/loading_screen.dart';
import '../inspection_widgets/section_tab_view.dart';

class InspectionPage extends StatefulWidget {
  final bool? isEditMode;
  const InspectionPage({super.key, this.isEditMode});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InspectionFormProvider>();
      final vehicleClass = context.read<VehicleClassProvider>();
      if (widget.isEditMode == true) {
        provider.fetchAndPrefill(
            vehicleClass.selectedClass!.regNo.toString());
      } else {
        provider.fetchInspectionData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appColor,
            title: const Text("Inspection"),
          ),
          backgroundColor: const Color(0xFFF4F6FA),
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

    final sections = provider.filteredSections;

    return Column(
      children: [

        Container(
          color: appColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            tabs: provider.sections.map((s) => Tab(
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
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              text: s.label.split('-').last,
            )).toList(),
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
                  (i) => SectionTabView(sectionIndex: i),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(InspectionFormProvider provider) {
    final answered = provider.grandTotalAnswered;
    final unanswered = provider.grandTotalQuestions - answered;
    final no = provider.grandTotalNo; // ← NEW

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              count: provider.grandTotalQuestions,
              selected: provider.filter == QuestionFilter.all,
              color: const Color(0xFF1A3C6E),
              onTap: () => provider.setFilter(QuestionFilter.all),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Answered',
              count: answered,
              selected: provider.filter == QuestionFilter.answered,
              color: Colors.green,
              onTap: () => provider.setFilter(QuestionFilter.answered),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Pending',
              count: unanswered,
              selected: provider.filter == QuestionFilter.unanswered,
              color: Colors.orange,
              onTap: () => provider.setFilter(QuestionFilter.unanswered),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'No',
              count: no,
              selected: provider.filter == QuestionFilter.no,
              color: Colors.red,
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
        ? 'No failed questions found ✓'
        : 'No questions found';

    final iconColor = filter == QuestionFilter.no
        ? Colors.red.shade200
        : Colors.grey.shade300;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: iconColor),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha:0.12) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected ? color : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}