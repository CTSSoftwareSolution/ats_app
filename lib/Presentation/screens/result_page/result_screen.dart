import 'package:ats_app/Presentation/provider/manual_inspection_list_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/home_widgets/home_shimmer.dart';
import 'package:ats_app/Presentation/screens/result_page/result_screen_item.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../EmptyStateWidget.dart';
import '../../../utilities/color_data.dart';
import '../../../widgets/custom_search_bar.dart';

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
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: CustomText(text: "Result", fontFamily: "SemiBold",textColor: whiteColor,fontSize: 20,)
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:      Column(
          children: [
            CustomSearchTextField(
              onChanged: (v) => provider.onSearchChanged(context, v),
              onCloseClick: () {
                provider.searchController.clear();
                provider.onFilterChanged(context);
              },
              controller: provider.searchController,
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
                padding: EdgeInsets.only(bottom: 100),
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
                  return ResultScreenItem(appointments: item);
                },
              ),
            ),
          ],
        ),

        // ListView.builder(
        //   padding: EdgeInsets.only(bottom: 80.0),
        //   physics: BouncingScrollPhysics(),
        //   itemCount: 7,
        //     shrinkWrap: false ,
        //     itemBuilder: (context,index){
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
        //     child: ResultScreenItem(),
        //   );})

      ))
    );
  }
}
