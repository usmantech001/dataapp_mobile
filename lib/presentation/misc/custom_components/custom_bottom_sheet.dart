import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_manager/color_manager.dart';

Future<dynamic> showCustomBottomSheet(
    {required BuildContext context,
    required Widget screen,
    bool? isDismissible,
    bool? enableDrag}) async {
  return showModalBottomSheet(
    backgroundColor: ColorManager.kWhite,
    shape:  RoundedRectangleBorder(
      
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
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
