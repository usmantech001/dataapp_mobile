import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';

Future<T?> showDialogPopup<T>(BuildContext context, Widget widget,
    {bool barrierDismissible = false, Color? barrierColor}) {
  return showDialog<T>(
    context: context,
    barrierColor: barrierColor ?? ColorManager.kBlack.withOpacity(0.2),
    builder: (_) => widget,
    barrierDismissible: barrierDismissible,
  );
}
