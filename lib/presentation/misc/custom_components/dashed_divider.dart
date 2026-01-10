import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.height = 1,
   
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.verticalPadding,
  });

  final double height;
  ///final Color color;
  final double dashWidth;
  final double dashSpace;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding?? 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
      
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: ColorManager.kGreyColor.withValues(alpha: .12)),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
