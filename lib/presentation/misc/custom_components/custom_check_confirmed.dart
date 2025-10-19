import 'package:flutter/cupertino.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomCheckConfirmed extends StatelessWidget {
  final String text;
  final bool showCheck;
  const CustomCheckConfirmed(
      {super.key, required this.text, this.showCheck = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.5, vertical: 7.5),
      decoration: BoxDecoration(
        color: ColorManager.kPrimaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheck)
            Padding(
                padding: const EdgeInsets.only(right: 4.5),
                child: Icon(CupertinoIcons.checkmark_alt_circle_fill,
                    color: ColorManager.kPrimary, size: 18)),
          Flexible(
            child: Text(
              text,
              style: get12TextStyle().copyWith(
                fontWeight: FontWeight.w500,
                color: ColorManager.kPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
