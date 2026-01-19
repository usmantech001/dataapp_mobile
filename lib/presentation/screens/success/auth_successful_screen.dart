import 'package:dataplug/core/model/core/auth_success_model.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AuthSuccessfulScreen extends StatelessWidget {
  const AuthSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authSuccessModel =
        ModalRoute.of(context)?.settings.arguments as AuthSuccessModel;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: svgImage(imgPath: 'assets/icons/success.svg')),
            Gap(20.h),
            Text(
              authSuccessModel.title,
              textAlign: TextAlign.center,
              style: get24TextStyle(),
            ),
            Gap(12.h),
            Text(
              authSuccessModel.description,
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(
                  color: ColorManager.kGreyColor.withValues(
                    alpha: .7,
                  ),
                  fontWeight: FontWeight.w400),
            ),
            Gap(24.h),
            CustomButton(
                text: authSuccessModel.btnText,
                isActive: true,
                onTap: authSuccessModel.onTap,
                loading: false)
          ],
        ),
      ),
    );
  }
}
