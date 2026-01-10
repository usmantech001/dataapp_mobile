import 'package:dataplug/gen/assets.gen.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';


class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.canPop = true,
    this.hasLogo = false
  });

  final String title;
  final bool canPop;
  final bool hasLogo;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           canPop? InkWell(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: ColorManager.kWhite,
                child: const Icon(
                  Icons.navigate_before,
                  size: 30,
                ),
              ),
            ): const SizedBox(width: 40, height: 40,),
          hasLogo?  Assets.images.dataplugLogoText.image(width: 118, height: 25):  Text(
              title,
              style: get18TextStyle(),
            ),
            const SizedBox(width: 40,)
          ],
        ),
      ),
    );
  }
}
