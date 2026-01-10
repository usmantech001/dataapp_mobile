import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';




Widget customImage({
  required String imgPath,
  double? height, 
  double? width
}){
  return Image.asset(imgPath, width:width?? 200.h,height: height,);
}

Widget svgImage({
required String imgPath,
double? height,
double? width,
Color? color
}){
  return SvgPicture.asset(imgPath, height: height, width: width,fit: BoxFit.cover,color:color,);
}