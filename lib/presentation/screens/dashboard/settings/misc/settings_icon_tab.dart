import 'package:dataplug/core/utils/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class SettingsIconTab extends StatelessWidget {
  final String text, shortDesc;
  final String img;
  final Function onTap;
  final bool hasNavIcon;
  final Widget? suffix;
  const SettingsIconTab(
      {super.key, required this.text, required this.shortDesc, required this.img, required this.onTap, this.hasNavIcon = true, this.suffix});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.circular(16.r)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               if(img.isNotEmpty) Container(
                  width: 48.w,
                  height: 48.h,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: ColorManager.kGreyF8,
                    borderRadius: BorderRadius.circular(14),
                   // image: DecorationImage(image: AssetImage(img))
                  ),
                  child:svgImage(imgPath: 'assets/icons/$img.svg', ),
                ),
                Gap(12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 
                    Text(text, style: get16TextStyle().copyWith(fontWeight: FontWeight.w500)),
                    Text(shortDesc, style: get12TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7))),
                  ],
                )
              ],
            ),
           if(hasNavIcon) suffix?? Icon(Icons.arrow_forward_ios_rounded, size: 18,color: ColorManager.kGreyColor.withValues(alpha: .4),)
          ],
        ),
      ),
    );
  }
}
