import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FundingMethodWidget extends StatelessWidget {
  const FundingMethodWidget({super.key, required this.name, required this.imgPath, required this.isSelected, required this.onTap});
  final String name;
  final String imgPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: isSelected? ColorManager.kPrimary : ColorManager.kWhite),
          color: ColorManager.kWhite,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5.w,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected? ColorManager.kPrimary : ColorManager.kWhite)),
                  child: CustomNetworkImage(imageUrl: imgPath)
                  // svgImage(
                  //     imgPath: imgPath,
                  //     height: 15.h,
                  //     width: 15.w),
                ),
              
                 Text(
                   name,
                  style: get14TextStyle(),
                ),
              ],
            ),
            Radio<bool>(
              value: isSelected,
              groupValue: true,
              onChanged: (value) {},
              fillColor: WidgetStatePropertyAll(ColorManager.kPrimary),
            )
          ],
        ),
      ),
    );
  }
}
