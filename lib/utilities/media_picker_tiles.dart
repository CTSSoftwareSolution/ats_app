
import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/provider/MediaPicker/file_provider.dart';
import '../Presentation/screens/camera_page/camera_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'color_data.dart';
import 'image_data.dart';

Widget mediaPickerTiles({required BuildContext context}) {
 // final fileProvider = Provider.of<FileProvider>(context, listen: false);
  int selectedIndex = -1;
  return SafeArea(
    bottom: true,
    child: Padding(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: mediaSource.length,
            itemBuilder: (context, index) {
              final bool isSelected = selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: InkWell(
                  onTap: () async {
                    selectedIndex = index;
                    if (mediaSource[index].id == 0) {
                      Navigator.pop(context);
                    //  await context.read<FileProvider>().initCamera();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
                    } else if (mediaSource[index].id == 1) {
                      Navigator.pop(context);
                      context.read<FileProvider>().pickSingleImage(context);
                    }
                  },
                  child: Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: isSelected
                          ? cardBackgroundColor
                          : mediaPickerColor,
                    ),
                    child: Row(
                      children: [
                       20.width,
                        CustomImage(
                          image: mediaSource[index].image,
                          scale: 4.0,
                        ),
                       15.width,
                        CustomText(
                          text: mediaSource[index].name,
                          fontSize: 18.0,
                          fontFamily: "Bold",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: CustomButton(
              height: 45.0,
              width: double.infinity,
              buttonText: "Close",
              onPress: () {
                Navigator.pop(context);
              },
              backgroundColor: appColor,
              foregroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              fontSize: 16.0,
              fontFamily: "Bold",
            ),
          ),
        ],
      ),
    ),
  );
}
