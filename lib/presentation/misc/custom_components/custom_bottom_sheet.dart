import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';

Future<dynamic> showCustomBottomSheet(
    {required BuildContext context,
    required Widget screen,
    bool? isDismissible,
    bool? enableDrag}) async {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.elliptical(20, 20),
        topRight: Radius.elliptical(20, 20),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    barrierColor: ColorManager.kBlack.withOpacity(.2),
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible ?? false,
    builder: (builder) => screen,
    enableDrag: enableDrag ?? false,
  );
}
