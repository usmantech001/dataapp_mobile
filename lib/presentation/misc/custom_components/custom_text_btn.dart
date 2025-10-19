import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomTextBtn extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? loadingColor;
  final Function onTap;
  final bool isActive;
  final bool loading;

  const CustomTextBtn({
    super.key,
    required this.text,
    this.textColor,
    this.textStyle,
    required this.isActive,
    required this.onTap,
    required this.loading,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isActive && loading == false ? onTap() : () {},
      child: loading
          ? Center(
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loadingColor ?? ColorManager.kPrimary,
                  ),
                ),
              ),
            )
          : Text(
              text,
              style: textStyle ??
                  get14TextStyle().copyWith(
                    color: textColor ?? ColorManager.kPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
