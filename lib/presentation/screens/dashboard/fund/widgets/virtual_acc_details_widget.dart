import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VirtualAccDetailsWidget extends StatelessWidget {
  const VirtualAccDetailsWidget(
      {super.key, required this.name, required this.value, this.isAccountNumber = false, this.onTap});
  final String name;
  final String value;
  final bool isAccountNumber;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.6,
              color: ColorManager.kGreyF8.withOpacity(0.3)
            )
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               name,
             style: get12TextStyle().copyWith(color:  ColorManager.kBlack.withOpacity(0.67)),
         
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                 value,
                 style:  isAccountNumber ? get20TextStyle().copyWith(color: ColorManager.kPrimary, fontWeight: FontWeight.w700  ) : get16TextStyle().copyWith(color:  ColorManager.kBlack, fontWeight: FontWeight.w400 ),
                  
                ),
                if(isAccountNumber) Container(
                  height: 26.h,
                  width: 26.w,
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.all(6.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    color: ColorManager.kPrimary.withOpacity(0.1)
                  ),
                  child: Icon(Icons.copy, size: 20,))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
