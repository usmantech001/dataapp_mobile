import 'package:flutter/material.dart';
import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomSmallBtn extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderWidth;
  final Color? borderColor;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;
  final Function onTap;
  final bool isActive;
  final bool loading;
  final Widget? child;

  const CustomSmallBtn({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    this.boxDecoration,
    this.textStyle,
    required this.isActive,
    required this.onTap,
    required this.loading,
    this.loadingColor,
    this.padding,
    this.borderWidth,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive && loading == false ? onTap() : () {},
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: boxDecoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: backgroundColor ?? ColorManager.kPrimaryLight,
              border: Border.all(
                width: borderWidth ?? .5,
                color: borderColor ?? ColorManager.k267E9B.withOpacity(.3),
              ),
            ),
        child: loading
            ? Center(
                child: SizedBox(
                  height: 19,
                  width: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      loadingColor ?? ColorManager.kWhite,
                    ),
                  ),
                ),
              )
            : child ??
                Text(
                  text,
                  style: textStyle ??
                      get12TextStyle()
                          .copyWith(color: textColor ?? ColorManager.kPrimary),
                  textAlign: TextAlign.center,
                ),
      ),
    );
  }
}
