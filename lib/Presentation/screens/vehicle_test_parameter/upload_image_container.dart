import 'dart:io';
import 'package:ats_app/Presentation/provider/MediaPicker/file_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UploadImageContainer extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  const UploadImageContainer({super.key, required this.onTap, required this.index});

  @override
  Widget build(BuildContext context) {
    final image = context.watch<FileProvider>().getImage(index);


    return Container(
      width: double.infinity,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: cardBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File( image.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150.0,
                  ),
                )
              : Column(
                  children: [
                    CustomImage(image: uploadIcon, scale: 4),
                   15.height,
                    CustomButton(
                      height: 30.0,
                      width: 120.0,
                      buttonText: "Upload",
                      onPress: onTap,
                      backgroundColor: appColor,
                      foregroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      fontSize: 15.0,
                      fontFamily: "Bold",
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
