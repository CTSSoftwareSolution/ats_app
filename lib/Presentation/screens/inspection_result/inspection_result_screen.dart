import 'package:ats_app/Presentation/provider/inspection_result_provider.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/bottom_navigation_bar.dart';
import 'package:ats_app/Presentation/screens/inspection_result/status_dialog_box.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_dialog_box.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/image_data.dart';
import '../../../widgets/custom_text.dart';
import 'inspection_result_screen_item.dart';

class InspectionResultScreen extends StatefulWidget {
  const InspectionResultScreen({super.key});

  @override
  State<InspectionResultScreen> createState() => _InspectionResultScreenState();
}

class _InspectionResultScreenState extends State<InspectionResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: appColor,
        title: CustomText(
          text: "Result",
          fontSize: 20,
          fontFamily: "SemiBold",
          textColor: whiteColor,
        ),
        leading: IconButton(
          onPressed: () {
            context.push(BottomNavigationBarScreen());
          },
          icon: ImageIcon(
            AssetImage(backArrowIcon),
            color: whiteColor,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView.builder(
                padding: EdgeInsets.only(bottom: 80.0,top: 12),
                physics: BouncingScrollPhysics(),
                itemCount: 15,
                shrinkWrap: false ,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
                    child: InspectionResultScreenItem(
                      onPress: () {
                        statusDialogBox(context: context
                        );
                      },),
                  );}),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0, bottom: 10.0 ),
              child: CustomButton(
                width: double.infinity,
                height: 50,
                buttonText: "Submit",
                onPress: () {
                  context.push(BottomNavigationBarScreen());
                },
                backgroundColor: appColor,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                fontSize: 20,
                fontFamily: "Bold",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
