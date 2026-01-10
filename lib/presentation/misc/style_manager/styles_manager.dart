import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../color_manager/color_manager.dart';


TextStyle _getTextStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
}) {
  return TextStyle(
    fontFamily: "Geist",
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamilyFallback: const ['Roboto', 'sans-serif'],
    color: color ?? const Color(0xff313146),
  );
}


// Font weights + sizes
TextStyle get10TextStyle() => _getTextStyle(fontSize: 10);
TextStyle get11TextStyle() => _getTextStyle(fontSize: 11);
TextStyle get12TextStyle() => _getTextStyle(fontSize: 12);
TextStyle get14TextStyle() => _getTextStyle(fontSize: 14);
TextStyle get16TextStyle() => _getTextStyle(fontSize: 16, fontWeight: FontWeight.w600);
TextStyle get18TextStyle() => _getTextStyle(fontSize: 18, fontWeight: FontWeight.w600);
TextStyle get20TextStyle() => _getTextStyle(fontSize: 20, fontWeight: FontWeight.w700);
TextStyle get22TextStyle() => _getTextStyle(fontSize: 22, fontWeight: FontWeight.w700);
TextStyle get24TextStyle() => _getTextStyle(fontSize: 24, fontWeight: FontWeight.w600);
TextStyle get26TextStyle() => _getTextStyle(fontSize: 26, fontWeight: FontWeight.w700);
TextStyle get28TextStyle() => _getTextStyle(fontSize: 28, fontWeight: FontWeight.w800);
TextStyle get32TextStyle() => _getTextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700);

TextStyle getPrefixTextStyle() => _getTextStyle(fontSize: 16);
TextStyle getHintTextStyle() => _getTextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: ColorManager.kFormHintText,
);
TextStyle getBtnTextStyle() => _getTextStyle(fontSize: 14, fontWeight: FontWeight.w600);

// Pin Theme
PinTheme getPinTheme({double? width}) => PinTheme(
  activeColor: ColorManager.kWhite,
  inactiveFillColor: ColorManager.kWhite,
  selectedColor: ColorManager.kWhite,
  activeFillColor: ColorManager.kFormBg,
  selectedFillColor: ColorManager.kFormBg,
  errorBorderColor: Colors.black,
  inactiveColor: ColorManager.kBlack,
  shape: PinCodeFieldShape.box,
  borderWidth: 0.5,
  activeBorderWidth: .5,
  inactiveBorderWidth: .5,
  borderRadius: BorderRadius.circular(10),
  fieldHeight: 53,
  fieldWidth: width ?? 45,
  fieldOuterPadding: const EdgeInsets.only(left: 15),
);

// Icons
Widget dropDownIcon({
  Color? color,
  EdgeInsetsGeometry? padding,
  double? width,
}) => Padding(
  padding: padding ?? const EdgeInsets.only(right: 13),
  child: Icon(Icons.keyboard_arrow_down_rounded,
      size: width ?? 30, color: color),
);

Widget dateIcon({
  Color? color,
  EdgeInsetsGeometry? padding,
  double? size,
}) => Padding(
  padding: padding ?? const EdgeInsets.symmetric(horizontal: 13),
  child: Icon(Icons.calendar_month_sharp,
      size: size ?? 30, color: color ?? ColorManager.kPrimary),
);

Widget searchSuffix() => SizedBox(
  width: 45,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          CupertinoIcons.search,
          color: ColorManager.kTextColor,
        ),
      ),
    ],
  ),
);

// Search Input Decoration
InputDecoration getSearchInputDecoration({
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  EdgeInsetsGeometry? padding,
}) => InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      width: 1.2,
      color: Color(0xffF4F4F4),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(width: 1.2, color: Color(0xffF4F4F4)),
  ),
  border: InputBorder.none,
  hintText: hintText ?? 'Search',
  suffixIcon: suffixIcon ??
      const Padding(
        padding: EdgeInsets.only(right: 13),
        child: SizedBox(
          width: 20,
          height: 20,
          child: Center(child: Icon(LucideIcons.search, size: 20)),
        ),
      ),
  contentPadding:
      padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  fillColor: const Color(0xffF4F4F4),
  filled: true,
  prefixIcon: prefixIcon,
);
