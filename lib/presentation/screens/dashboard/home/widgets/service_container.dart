import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ServiceTypeContainer extends StatelessWidget {
  const ServiceTypeContainer({super.key, required this.name, required this.iconPath, required this.onTap});
  final String name, iconPath;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 74.w,
        height: 74.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 52.h,
              width: 52.w,
              padding: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                  color: ColorManager.kPrimary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16.r)),
              child: svgImage(imgPath: 'assets/icons/$iconPath.svg', height: 24.h, width: 24.w),
            ),
            Spacer(),
            Text(
              name,
              style: get12TextStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class ServiceContainer extends StatelessWidget {
  const ServiceContainer({super.key, required this.title, required this.serviceTypes});
  final String title;
  final List<ServiceTypeContainer> serviceTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          Gap(16.h),
          Wrap(
            spacing: MediaQuery.sizeOf(context).width * 0.015,
            runSpacing: 14.h,
            children: serviceTypes,
          )
        ],
      ),
    );
  }
}
