import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletActivitiesContainer extends StatelessWidget {
  const WalletActivitiesContainer(
      {super.key,
      required this.name,
      required this.iconPath,
      required this.onTap,
      this.bgColor,
      this.textColor
      });
  final String name;
  final String iconPath;
  final VoidCallback onTap;
  final Color? bgColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
            color: bgColor?? ColorManager.kWhite,
            borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: iconPath.isEmpty? 2: 8.w,
          children: [
            iconPath.isNotEmpty
                ? svgImage(
                    imgPath: 'assets/icons/$iconPath.svg',
                    height: 20.h,
                    width: 20.w, color: textColor)
                : Icon(Icons.add, color: ColorManager.kPrimary,),
            Text(name, style: get14TextStyle().copyWith(color: textColor,),)
          ],
        ),
      ),
    );
  }
}
