import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletActivitiesContainer extends StatelessWidget {
  const WalletActivitiesContainer({super.key, required this.name,required this.iconPath, required this.onTap});
  final String name;
  final String iconPath;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.w,
          children: [svgImage(imgPath: 'assets/icons/$iconPath.svg', height: 20.h, width: 20.w), Text(name)],
        ),
      ),
    );
  }
}
