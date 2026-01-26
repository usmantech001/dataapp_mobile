import 'package:dataplug/core/helpers/auth_helper.dart';
import 'package:dataplug/core/providers/user_provider.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

class BiometricCard extends StatelessWidget {
  const BiometricCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
        padding: const EdgeInsets.all(12.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorManager.kPrimaryLight,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Use Face ID/Thumb print",
                    style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorManager.kPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap here to use Face ID/thumb print to login",
                    style: get12TextStyle().copyWith(
                      height: 1.0,
                      color: ColorManager.kTextDark7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(ImageManager.kFaceIcon,
                color: ColorManager.kPrimary, width: 36),
          ],
        ),
      ),
    );
  }
}