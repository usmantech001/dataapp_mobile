import 'package:dataplug/core/utils/custom_bottom_sheet.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GenerateAccountScreen extends StatelessWidget {
  const GenerateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Generate Account'),
      bottomNavigationBar: CustomBottomNavBotton(
          text: 'Continue',
          onTap: () {
            showCustomMessageBottomSheet(context: context, title: 'Virtual account generated', description: 'Virtual Account created successfully, access your virtual account anytime.', onTap: () {
              
            },);
          }),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          spacing: 24.h,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                spacing: 16.h,
                children: [
                  CustomInputField(
                    formHolderName: 'First Name',
                  ),
                  CustomInputField(
                    formHolderName: 'Last Name',
                  ),
                  CustomInputField(
                    formHolderName: 'BVN or NIN',
                  ),
                  CustomInputField(
                    formHolderName: 'Date of Birth',
                    readOnly: true,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                children: [
                  Row(
                    spacing: 16.w,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: ColorManager.kGreyF8,
                          borderRadius: BorderRadius.circular(14),
                          // image: DecorationImage(image: AssetImage(img))
                        ),
                        child: svgImage(
                          imgPath: 'assets/icons/security-icon.svg',
                        ),
                      ),
                      Text(
                        'Why We Ask for Your BVN',
                        style: get16TextStyle()
                            .copyWith(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Text(
                    'Your BVN helps us confirm your identity quickly and safely. We can only view your name, date of birth, and the phone number linked to your BVN.',
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyColor.withValues(alpha: .7)),
                  ),
                  Gap(12.h),
                  Text(
                    'We cannot access your bank balance, transaction history, or any private financial details. Your data stays protected.',
                    style: get14TextStyle().copyWith(
                        color: ColorManager.kGreyColor.withValues(alpha: .7)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
