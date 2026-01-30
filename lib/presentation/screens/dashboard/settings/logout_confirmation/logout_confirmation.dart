import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_back_icon.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/auth_helper.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class LogoutConfirmation extends StatelessWidget {
  const LogoutConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w,right: 20.w, top: 30.h),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            svgImage(imgPath: 'assets/icons/power-icon.svg'),
            Gap(12.h),
            Text('Are you sure?', style: get24TextStyle(),),
            Gap(12.h),
            Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.left,
              style: get14TextStyle(),
            ),
            Gap(40.h),
            Row(
              spacing: 15.w,
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Cancel",
                    isActive: true,
                    onTap: () async {
                     popScreen();
                    },
                    loading: false,
                    backgroundColor: ColorManager.kGreyF8,
                    textColor: ColorManager.kBlack.withValues(alpha: .4),
                  ),
                ),

                Expanded(
                  child: CustomButton(
                    text: "Logout",
                    isActive: true,
                    onTap: () async {
                      AuthHelper.logout(context, deactivateTokenAndRestart: true);
                      removeAllAndPushScreen(RoutesManager.signIn);
                    },
                    loading: false,
                    backgroundColor: ColorManager.kPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
