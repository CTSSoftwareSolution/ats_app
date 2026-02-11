import 'package:ats_app/Presentation/provider/inspection_form_provider.dart';
import 'package:ats_app/Presentation/provider/pre_inspection_result_provider.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/question_card.dart';
import 'package:ats_app/Presentation/screens/pre_inspection_form/vehicle_section_title.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_loader.dart';
import '../../../widgets/custom_text.dart';


class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key});

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InspectionFormProvider>().questionListApi();
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<InspectionFormProvider>();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        title: CustomText(
          text: "Manually Inspection Form",
          fontSize: 20,
          fontFamily: "SemiBold",
          textColor: whiteColor,
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
            formProvider.clearAnswer();
          },
          icon: ImageIcon(
            AssetImage(backArrowIcon),
            color: whiteColor,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: formProvider.isLoading
            ? Center(child: CustomLoader.loader())
            : formProvider.inspectionQueEntity!.data!.isEmpty
            ? const Center(child: Text("No data found"))
            : ListView.builder(
          physics: BouncingScrollPhysics(),
               padding: const EdgeInsets.only(top: 16,bottom: 60),
                itemCount: formProvider.inspectionQueEntity!.data?.length,
                itemBuilder: (context, index) {
                  final questions = formProvider.inspectionQueEntity!.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(questions.title.toString()),
                        ...questions.carData!
                            .map((question) => questionCard(question, context))
                            .toList(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              )
      ),
      floatingActionButton: formProvider.isLoading ?
          SizedBox.shrink() :
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: FloatingActionButton.extended(
            backgroundColor: appColor,
            onPressed: () {

              if (!formProvider.areAllQuestionsAnswered()) {
                CustomLoader.errorMessage("Please answer all questions before submitting.");
                return;
              }

              context.read<PreInspectionResultProvider>().saveResultApi(context);
              formProvider.clearAnswer();
              context.pop();
            },
            label: CustomText(
              text: "Submit",
              fontSize: 18,
              fontFamily: "SemiBold",
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
