import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../color_manager/color_manager.dart';
import '../image_manager/image_manager.dart';

Widget customDivider(
        {EdgeInsetsGeometry? margin,
        double? height,
        double? width,
        Color? color}) =>
    Container(
        width: width ?? double.infinity,
        height: height ?? .85,
        margin: margin ?? EdgeInsets.zero,
        color: color ?? ColorManager.kBar2Color);

Widget loadNetworkImage(String url,
    {double? height,
    double? width,
    double? strokeWidth,
    Color? strokeWidthColor,
    BoxFit? fit,
    String errorDefaultImage = ImageManager.kNetworkImageFallBack,
    File? file,
    required BorderRadius borderRadius}) {
  bool isSvgImage = url.split(".").last.contains("svg");

  if (isSvgImage) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SvgPicture.network(
        url,
        height: height,
        width: width,
        fit: fit ?? BoxFit.fill,
        placeholderBuilder: (BuildContext? context) {
          return Center(
            child: CircularProgressIndicator(
              color: strokeWidthColor ?? ColorManager.kPrimary,
              strokeWidth: strokeWidth ?? 2,
            ),
          );
        },
      ),
    );
    //
  }

  return ClipRRect(
    borderRadius: borderRadius,
    child: url.startsWith("assets")
        ? Image.asset(url, height: height, width: width, fit: fit)
        : url.trim().toLowerCase() == ("file:///") || url.isEmpty
            ? Image.asset(errorDefaultImage,
                height: height, width: width, fit: fit)
            : Image.network(url, height: height, width: width, fit: fit,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;

                return Center(
                  child: CircularProgressIndicator(
                    color: strokeWidthColor ?? ColorManager.kPrimary,
                    strokeWidth: strokeWidth ?? 2,
                  ),
                );
              }, errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                return Image.asset(errorDefaultImage,
                    width: width, height: height, fit: fit);
              }),
  );
}
