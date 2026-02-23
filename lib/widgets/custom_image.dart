import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? scale;
  final bool? switchToNetwork;
  final String? defaultImage;
  const CustomImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.switchToNetwork = false,
    this.defaultImage,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return switchToNetwork == false
        ? Image.asset(
            image,
            scale: scale,
            width: width,
            height: height,
            fit: fit,
            color: color,
          )
        : Image.network(
            image.toString(),
            fit: fit,
            width: width,
            height: height,
            errorBuilder:
                (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return Image.asset(defaultImage!);
                },
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: appColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
          );
  }
}
