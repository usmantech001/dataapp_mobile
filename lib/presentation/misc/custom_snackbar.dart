import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/enum.dart';
import 'color_manager/color_manager.dart';

showCustomToast({
  required BuildContext context,
  required String description,
  Widget? widget,
  Color? backgroundColor,
  ToastType type = ToastType.error,
  Duration duration = const Duration(milliseconds: 2100),
}) async {
  Color textColor = ColorManager.kSuccess;
  Color bgColor = ColorManager.kSuccessAlt;
  IconData icon = LucideIcons.check;

  if (type == ToastType.error) {
    bgColor = ColorManager.kError.withOpacity(.2);
    textColor = ColorManager.kError;
    icon = LucideIcons.x;
  }

  InAppNotification.show(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          //
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: bgColor),
            child: Center(child: Icon(icon, size: 17, color: textColor)),
          ),

          //
          Expanded(
            child: Text(
              description,
              style: get14TextStyle().copyWith(color: textColor),
            ),
          ),

          const SizedBox(width: 5),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => InAppNotification.dismiss(context: context),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(LucideIcons.x, color: ColorManager.kD1D3D9),
            ),
          )
        ],
      ),
    ),
    context: context,
    duration: duration,
  );
}
