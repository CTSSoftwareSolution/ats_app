import 'package:flutter/material.dart';
import '../utilities/color_data.dart';
import '../widgets/custom_text.dart';

void customBottomSheet({required BuildContext context, required String title, required Widget child}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0,),
                  Center(
                    child: Container(
                      width: 66,
                      height: 4,
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  CustomText(
                    text: title,
                    fontSize: 18,
                    fontFamily: "Bold",

                  ),
                  SizedBox(height: 15.0,),
                  child
                ],
              )),
        ),
      );
    },
  );
}
