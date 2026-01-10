import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomVerifying extends StatelessWidget {
  const CustomVerifying({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 15.h,
          width: 15.w,
          child: CircularProgressIndicator(
            backgroundColor: ColorManager.kPrimary.withValues(alpha: .05),
            color: ColorManager.kPrimary,
          ),
        ),
        Gap(10),
        Text(
          text,
          style: get14TextStyle().copyWith(color: ColorManager.kPrimary),
        )
      ],
    );
  }
}
