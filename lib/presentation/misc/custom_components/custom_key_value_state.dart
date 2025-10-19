import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';
import '../style_manager/styles_manager.dart';

class CustomKeyValueState extends StatelessWidget {
  final String title;
  final String desc;
  final bool? bottomPadding;
  final Widget? titleW;
  final Widget? descW;
  const CustomKeyValueState({
    super.key,
    required this.title,
    required this.desc,
    this.bottomPadding = true,
    this.titleW,
    this.descW,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding! ? 15 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: titleW ??
                Text(title, style: customKeyValueStateTitleTextStyle()),
          ),
          descW ??
              Text(desc, textAlign: TextAlign.right, style: get12TextStyle()),
        ],
      ),
    );
  }

  static TextStyle customKeyValueStateTitleTextStyle() {
    return get12TextStyle().copyWith(color: ColorManager.kTextDark7);
  }
}
