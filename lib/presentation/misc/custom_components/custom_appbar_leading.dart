import 'package:flutter/material.dart';

import 'custom_back_icon.dart';

class CustomAppBarLeading extends StatelessWidget {
  const CustomAppBarLeading({Key? key, this.color, this.widget, this.onTap})
      : super(key: key);
  final Function? onTap;

  final Color? color;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap!() : () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: widget ?? const BackIcon()),
            ),
          ],
        ),
      ),
    );
  }
}
