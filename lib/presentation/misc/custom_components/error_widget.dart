import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.errMsg, required this.onRefresh,  this.topPadding});
  final String errMsg;
  final VoidCallback onRefresh;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding?? 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20.h,
        children: [
          Text(
            errMsg,
            textAlign: TextAlign.center,
          ),
          CustomButton(
            text: 'Refresh',
            isActive: true,
            onTap: onRefresh,
            loading: false,
            border: Border.all(color: ColorManager.kPrimary),
            backgroundColor: ColorManager.kGreyF5,
            textColor: ColorManager.kBlack,
            width: 200,
          )
        ],
      ),
    );
  }
}
