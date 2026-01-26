import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

showCustomMessageBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  bool isSuccess = true,
  required VoidCallback onTap

}) {
  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(left: 32.h, right: 32.h, top: 20.w, bottom: 44.h),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorManager.kWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              svgImage(imgPath: isSuccess? 'assets/icons/success-icon.svg' : 'assets/icons/failed-icon.svg'),
              Gap(24.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: get18TextStyle().copyWith(fontWeight: FontWeight.w600),
              ),
              Gap(12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: get12TextStyle(),
              ),
              Gap(20),
              CustomButton(
                  text:isSuccess? 'Continue' : 'Try Again',
                  isActive: true,
                  width: 120.w,
                  backgroundColor: isSuccess? ColorManager.kPrimary : ColorManager.kError,
                  onTap: onTap,
               
                  loading: false)
            ],
          ),
        );
      });
}
