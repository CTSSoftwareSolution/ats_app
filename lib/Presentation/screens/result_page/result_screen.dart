import 'package:ats_app/Presentation/screens/result_page/result_screen_item.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../utilities/color_data.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: CustomText(text: "Result", fontFamily: "SemiBold",textColor: whiteColor,fontSize: 20,)
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 80.0),
          physics: BouncingScrollPhysics(),
          itemCount: 7,
            shrinkWrap: false ,
            itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
            child: ResultScreenItem(),
          );})

      ))
    );
  }
}
