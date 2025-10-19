import 'package:flutter/cupertino.dart';

import '../../../misc/color_manager/color_manager.dart';
import '../../../misc/style_manager/styles_manager.dart';

class SocialAuth extends StatelessWidget {
  final String text;
  final String image;

  const SocialAuth({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12.5),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.kPrimary),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 18, height: 18),
          const SizedBox(width: 4),
          Text(text,
              style: get12TextStyle().copyWith(fontWeight: FontWeight.w600, color: ColorManager.kPrimary))
        ],
      ),
    );
  }
}
