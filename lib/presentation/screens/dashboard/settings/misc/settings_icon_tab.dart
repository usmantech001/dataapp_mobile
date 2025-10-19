import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class SettingsIconTab extends StatelessWidget {
  final String? text;
  final String img;
  final Function onTap;
  const SettingsIconTab(
      {super.key, this.text, required this.img, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 10),
                // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: ColorManager.kPrimaryLight,
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(image: AssetImage(img))
                ),
                // child: Center(
                //   child: Image.asset(img, width: 16, height: 20),
                // ),
              ),
              Gap(10),
              if (text != null) Column(
                children: [
                  Gap(5),
                  Text(text!, style: get14TextStyle()),
                ],
              )
            ],
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 18,)
        ],
      ),
    );
  }
}
