import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ToggleSelectorWidget extends StatelessWidget {
  const ToggleSelectorWidget(
      {super.key,
      required this.tabIndex,
      required this.tabText,
      //required this.selectorName,
      this.hasMargin = true,
      this.bgColor,
      this.selectedColor,
      this.selectedTexColor,
      required this.onTap,});
  final List<String> tabText;
  // final String secTabIndex;
  final int tabIndex;
  //final String selectorName;
  final Function(int) onTap;
  final bool hasMargin;
  final Color? bgColor;
  final Color? selectedColor;
  final Color? selectedTexColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: hasMargin? EdgeInsets.symmetric(horizontal: 15.w) : EdgeInsets.zero,
      padding: EdgeInsets.all(4.sp),
      height: 40.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor?? ColorManager.kWhite,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: tabIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: 40.h,
              width: 160.w,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: selectedColor?? ColorManager.kPrimary,
                  borderRadius: BorderRadius.circular(10.sp)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              2,
              (index) => InkWell(
                onTap: () => onTap(index),
                child: Center(
                  child: Container(
                    height: 40.h,
                    width: 160.w,
                    alignment: Alignment.center,
                    child: Text(
                         tabText[index],
                         style: get14TextStyle().copyWith(
                      
                        color: tabIndex == index
                            ? (selectedTexColor?? ColorManager.kWhite)
                            : ColorManager.kGreyColor.withValues(alpha: .4),
                        fontWeight: FontWeight.w500
                         ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
