import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class VirtualAccountsScreen extends StatelessWidget {
  const VirtualAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Bank Account'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Virtual Accounts',
                  style: get18TextStyle(),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: ColorManager.kPrimary,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    spacing: 6.w,
                    children: [
                      svgImage(imgPath: 'assets/icons/flash-icon.svg'),
                      Text(
                        'Quick Fund',
                        style: get14TextStyle()
                            .copyWith(color: ColorManager.kWhite),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(

                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15.w),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                        color: ColorManager.kWhite,
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Column(
                      spacing: 12.h,
                      children: [
                        VirtualAccountRowText(name: 'Bank Name', value: 'Usman'),
                        VirtualAccountRowText(name: 'Account Number', value: '3161001031', hasIcon: true,),
                        VirtualAccountRowText(name: 'Bank Name', value: 'Usman'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Gap(15.h),
                itemCount: 5),
          )
        ],
      ),
    );
  }
}

class VirtualAccountRowText extends StatelessWidget {
  const VirtualAccountRowText({super.key, required this.name, required this.value, this.hasIcon = false});
  final String name;
  final String value;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: get16TextStyle()
              .copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),
        ),
        Row(
          children: [
            Text(
              value,
              style: get16TextStyle().copyWith(color: ColorManager.kGreyColor),
            ),
            if(hasIcon) Container(
              margin: EdgeInsets.only(left: 4.w),
              height: 20.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: ColorManager.kPrimary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(4.r)
              ),
              child: Icon(Icons.copy, color: ColorManager.kPrimary, size: 15,))
          ],
        )
      ],
    );
  }
}
