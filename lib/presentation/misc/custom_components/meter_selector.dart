import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/material.dart';

class MeterSelector extends StatelessWidget {
  const MeterSelector(
      {super.key,
      required this.meterType,
      required this.isSelected,
      required this.onTap});
  final String meterType;
  final VoidCallback onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.kPrimary.withValues(alpha: .08)
                : ColorManager.kWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected
                    ? ColorManager.kPrimary
                    : ColorManager.kGreyColor.withValues(alpha: .08))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radio.adaptive(value: value, groupValue: groupValue, onChanged: onChanged)
            Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (value) {},
              activeColor: ColorManager.kPrimary,
            ),
            Text(meterType)
          ],
        ),
      ),
    );
  }
}
