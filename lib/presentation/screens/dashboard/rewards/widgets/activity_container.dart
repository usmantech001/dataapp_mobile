import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActivityContainer extends StatelessWidget {
  const ActivityContainer({super.key, required this.iconPath, required this.totalNumber, required this.text, required this.onTap});
  final String iconPath;
  final String totalNumber;
  final String text;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
            color: ColorManager.kGreyF8,
            borderRadius: BorderRadius.circular(12.sp)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                  color: ColorManager.kPrimary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(10.r)),
              child: svgImage(imgPath: 'assets/icons/$iconPath.svg'),
            ),
            Gap(16.h),
            Text(
              totalNumber,
              style: get18TextStyle(),
            ),
            Gap(8.h),
            Text(
              text,
              style: get10TextStyle()
                  .copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),
            )
          ],
        ),
      ),
    );
  }
}
