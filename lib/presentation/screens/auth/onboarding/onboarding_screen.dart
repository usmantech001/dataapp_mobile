import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/services/secure_storage.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: Column(
            children: [
              SizedBox(
                height: 380.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: 0,
                      //alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/data-app-logo.png',
                        height: 350.h,
                        width: 300.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: 15.w,
                      top: 10.h,
                      child: Image.asset(
                        'assets/images/data-app-logo-name.png',
                        width: 150.w,
                        height: 32.h,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Text(
                      'One App for Every Payment',
                      textAlign: TextAlign.center,
                      style: get32TextStyle().copyWith(
                          fontSize: 44.sp,
                          color: ColorManager.kWhite,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        'Pay bills, transfer money, and track transactions in one place.',
                        textAlign: TextAlign.center,
                        style: get16TextStyle().copyWith(
                            color: ColorManager.kWhite,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Gap(24.h),
                    CustomButton(
                        text: 'Create an Account',
                        isActive: true,
                        backgroundColor: ColorManager.kWhite,
                        textColor: ColorManager.kBlack,
                        onTap: () {
                          SecureStorage.getInstance().then((pref) =>
                              pref.setBool(Constants.kAlreadyUsedAppKey, true));
                          removeAllAndPushScreen(RoutesManager.onboarding1);
                        },
                        loading: false),
                    Gap(12.h),
                    CustomButton(
                        text: 'Login',
                        isActive: true,
                        backgroundColor:
                            ColorManager.kWhite.withValues(alpha: .16),
                        border: Border.all(
                            color: ColorManager.kWhite.withValues(alpha: .24)),
                        textColor: ColorManager.kWhite,
                        onTap: () {
                          SecureStorage.getInstance().then((pref) =>
                              pref.setBool(Constants.kAlreadyUsedAppKey, true));
                          removeAllAndPushScreen(RoutesManager.signIn);
                        },
                        loading: false),
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
