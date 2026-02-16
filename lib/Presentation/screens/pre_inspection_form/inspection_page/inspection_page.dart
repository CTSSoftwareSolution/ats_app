
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/submit_fab_widget.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/inspection_form_provider.dart';
import '../inspection_widgets/error_screen.dart';
import '../inspection_widgets/loading_screen.dart';
import '../inspection_widgets/section_tab_view.dart';


class InspectionPage extends StatefulWidget {
  const InspectionPage({super.key});

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
      context.read<InspectionFormProvider>().fetchInspectionData();
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
              title: Text("Inspection")),
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

    final sections = provider.sections;

    return Column(
      children: [
        PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
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
              tabs: sections
                  .map(
                    (s) => Tab(
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
                ),
              )
                  .toList(),
            ),
          ),
        ),

        /// 🔥 IMPORTANT: Wrap TabBarView with Expanded
        Expanded(
          child: TabBarView(
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
}


