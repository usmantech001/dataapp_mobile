import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;
  final Function onTap;
  final double? width;
  final double? height;
  final bool isActive;
  final bool loading;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const CustomButton({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
    this.width,
    required this.isActive,
    required this.onTap,
    required this.loading,
    this.loadingColor,
    this.padding,
    this.child,
    this.height,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive && loading == false ? onTap() : () {},
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 0),
        decoration: boxDecoration ??
            BoxDecoration(
              border: border,
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              color: backgroundColor ??
                  (isActive
                      ? ColorManager.kPrimary
                      : ColorManager.kPrimaryLight),
            ),
        child: loading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loadingColor ?? Colors.white,
                    ),
                  ),
                ),
              )
            : child ??
                Center(
                  child: Text(
                    text,
                    style: textStyle ??
                        getBtnTextStyle().copyWith(
                          color: textColor ??
                              (isActive
                                  ? ColorManager.kWhite
                                  : ColorManager.kPrimary),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
    );
  }
}
