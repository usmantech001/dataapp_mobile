import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReferEarnContainer extends StatelessWidget {
  const ReferEarnContainer({super.key, required this.referralCode});

  final String referralCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorManager.kWhite,
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12.w,
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                    color: ColorManager.kGreyF8,
                    borderRadius: BorderRadius.circular(12.sp)),
                child: svgImage(imgPath: 'assets/icons/users-icon.svg'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refer & Earn',
                    style: get16TextStyle(),
                  ),
                  Text(
                    '3 friends joined',
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyColor.withValues(alpha: .7)),
                  )
                ],
              )
            ],
          ),
          Gap(12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
                color: ColorManager.kGreyF8,
                borderRadius: BorderRadius.circular(16.sp)),
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refer friends and earn rewards',
                  style: get14TextStyle(),
                ),
                Row(
                  spacing: 8.w,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                            color: ColorManager.kWhite,
                            borderRadius: BorderRadius.circular(12.sp),
                            border: Border.all(
                                color: ColorManager.kGreyColor
                                    .withValues(alpha: .08))),
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Referral Code',
                              style: get10TextStyle().copyWith(
                                  color: ColorManager.kGreyColor
                                      .withValues(alpha: .7)),
                            ),
                            Text(
                              referralCode,
                              style: get16TextStyle()
                                  .copyWith(color: ColorManager.kPrimary),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        copyToClipboard(context, referralCode);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                            color: ColorManager.kPrimary,
                            borderRadius: BorderRadius.circular(14.r)),
                        child: Icon(
                          Icons.copy,
                          color: ColorManager.kWhite,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Gap(16.h),
          CustomButton(
            text: 'View Leaderboard',
            isActive: true,
            onTap: () {},
            loading: false,
            textColor: ColorManager.kPrimary,
            backgroundColor: ColorManager.kPrimary.withValues(alpha: .08),
            border:
                Border.all(color: ColorManager.kPrimary.withValues(alpha: .3)),
            child: Row(
              spacing: 8.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share,
                  color: ColorManager.kPrimary,
                ),
                Text(
                  'Share with Friends',
                  style:
                      get14TextStyle().copyWith(color: ColorManager.kPrimary),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
