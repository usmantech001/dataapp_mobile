import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaderboardContainer extends StatelessWidget {
  const LeaderboardContainer({super.key});

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
                children: [
                  Row(
                    spacing: 12.w,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                            color: ColorManager.kGreyF8,
                            borderRadius: BorderRadius.circular(12.sp)),
                        child: svgImage(
                            imgPath: 'assets/icons/leaderboard-icon.svg'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leaderoard',
                            style: get16TextStyle(),
                          ),
                          Text(
                            'This month\'s top performers',
                            style: get14TextStyle().copyWith(
                                color: ColorManager.kGreyColor
                                    .withValues(alpha: .7)),
                          )
                        ],
                      )
                    ],
                  ),
                  Gap(16.h),
                  CustomButton(
                    text: 'View Leaderboard',
                    isActive: true,
                    onTap: () {
                      pushNamed(RoutesManager.leaderboard);
                    },
                    loading: false,
                    
                    textColor: ColorManager.kPrimary,
                    backgroundColor:
                        ColorManager.kPrimary.withValues(alpha: .08),
                    border: Border.all(
                        color: ColorManager.kPrimary.withValues(alpha: .3)),
                  )
                ],
              ),
            );
  }
}