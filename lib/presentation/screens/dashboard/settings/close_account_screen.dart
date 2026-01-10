import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CloseAccountScreen extends StatelessWidget {
  const CloseAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Close Account"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
              color: ColorManager.kWhite,
              borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8.w,
                children: [
                  svgImage(
                      imgPath: 'assets/icons/document-icon.svg',
                      height: 16.h,
                      width: 16.w),
                  Text(
                    'What\'s Included',
                    style:
                        get18TextStyle().copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Gap(17.5),
              Column(
                spacing: 12.h,
                children: [
                  CloseAccountRowWidget(
                      text: 'You will be logged out of all devices'),
                  CloseAccountRowWidget(
                      text: 'Your account will be permanently deleted'),
                  CloseAccountRowWidget(
                      text: 'You will no longer receive any notifications'),
                  CloseAccountRowWidget(
                      text: 'A deleted account can no longer be restored'),
                ],
              ),
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                    color: ColorManager.kError.withValues(alpha: .12),
                    border: Border.all(color: ColorManager.kError),
                    borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    Flexible(
                      child: RichText(
                          text: TextSpan(
                              text: 'Please make sure your account balance is ',
                              style: get14TextStyle().copyWith(
                                  color: ColorManager.kGreyColor,
                                  fontWeight: FontWeight.w400),
                              children: [
                            TextSpan(
                              text: '₦0.00',
                              style: get14TextStyle().copyWith(
                                  color: ColorManager.kGreyColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: ' before proceeding',
                              style: get14TextStyle().copyWith(
                                  color: ColorManager.kGreyColor,
                                  fontWeight: FontWeight.w400),
                            )
                          ])),
                    )
                  ],
                ),
              ),
              Gap(20.h),
              CustomButton(
                text: 'text',
                isActive: true,
                backgroundColor: ColorManager.kError,
                onTap: () {},
                loading: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    Icon(
                      Icons.delete,
                      color: ColorManager.kWhite,
                    ),
                    Text('Delete My Account', style: get16TextStyle().copyWith(color: ColorManager.kWhite, fontWeight: FontWeight.w500),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CloseAccountRowWidget extends StatelessWidget {
  const CloseAccountRowWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        svgImage(
            imgPath: 'assets/icons/check-icon.svg', height: 18.h, width: 18.w),
        Text(text)
      ],
    );
  }
}
