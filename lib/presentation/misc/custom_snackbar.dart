import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/enum.dart';
import 'color_manager/color_manager.dart';

showCustomToast({
  required BuildContext context,
  required String description,
  Widget? widget,
  Color? backgroundColor,
  ToastType type = ToastType.error,
  Duration duration = const Duration(milliseconds: 2100),
}) async {
  Color textColor = ColorManager.kSuccess;
  Color bgColor = ColorManager.kSuccessAlt;
  IconData icon = LucideIcons.check;

  if (type == ToastType.error) {
    bgColor = ColorManager.kError.withOpacity(.2);
    textColor = ColorManager.kError;
    icon = LucideIcons.x;
  }

  InAppNotification.show(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          //
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: bgColor),
            child: Center(child: Icon(icon, size: 17, color: textColor)),
          ),

          //
          Expanded(
            child: Text(
              description,
              style: get14TextStyle().copyWith(color: textColor),
            ),
          ),

          const SizedBox(width: 5),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => InAppNotification.dismiss(context: context),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(LucideIcons.x, color: ColorManager.kD1D3D9),
            ),
          )
        ],
      ),
    ),
    context: context,
    duration: duration,
  );
}

showCustomErrorTransaction({
  required BuildContext context,
  required String errMsg,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorManager.kError,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            // height: 200,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(24.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.kErrorEB.withValues(alpha: .08),
                  radius: 43.r,
                  child: CircleAvatar(
                    backgroundColor: ColorManager.kErrorEB,
                    radius: 30.r,
                    child: Icon(Icons.close, color: ColorManager.kWhite,),
                  ),
                ),
                Gap(24.h),
                Text(
                  'Purchase Failed',
                  style: get20TextStyle(),
                ),
                Gap(12.h),
                Text(
                  errMsg,
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(),
                ),
                Gap(24.h),
                CustomButton(
                    text: 'Okay',
                    width: 90,
                    borderRadius: BorderRadius.circular(12.r),
                    isActive: true,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    loading: false)
              ],
            ),
          ),
        );
      });
}
