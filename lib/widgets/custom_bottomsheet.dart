import 'package:ats_app/utilities/extension.dart';
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
                 5.height,
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
                  16.height,
                  CustomText(
                    text: title,
                    fontSize: 18,
                    fontFamily: "Bold",

                  ),
                  15.height,
                  child
                ],
              )),
        ),
      );
    },
  );
}
