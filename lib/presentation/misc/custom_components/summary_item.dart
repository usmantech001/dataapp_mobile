import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/dashed_divider.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({super.key, required this.title, required this.name, this.hasDivider = false});
  final String title, name;
  final bool hasDivider;
  //final bool isStatus
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 50.w,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: get14TextStyle().copyWith(color: ColorManager.kTextColor),
            ),
            Flexible(
              child: Text(
                name,
                textAlign: TextAlign.end,
                style: get14TextStyle().copyWith(fontWeight: FontWeight.w500),
              ),
            ),

          ],
        ),
        
     
      ],
    );
  }
}
