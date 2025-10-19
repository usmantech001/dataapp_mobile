import 'package:flutter/material.dart';
import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomSelectableButtonsWithDot extends StatelessWidget {
  final String text;
  final bool selected;
  final Function(bool)? onTap;
  const CustomSelectableButtonsWithDot(
      {super.key, required this.text, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) onTap!(selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              width: 1,
              color: selected
                  ? ColorManager.kPrimary.withOpacity(.25)
                  : ColorManager.kFormInactiveBorder,
            )),
        child: Row(
          children: [
            selected
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            width: 1.5, color: ColorManager.kPrimary)),
                    padding: const EdgeInsets.all(1.5),
                    child: Icon(Icons.circle_sharp,
                        color: selected
                            ? ColorManager.kPrimary
                            : ColorManager.kBarColor,
                        size: 14),
                  )
                : Icon(Icons.circle_outlined,
                    color: ColorManager.kSmallText, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: get14TextStyle().copyWith(
                  color: ColorManager.kTextColor, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
