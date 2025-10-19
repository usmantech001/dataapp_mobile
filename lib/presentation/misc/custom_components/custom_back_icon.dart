import 'package:flutter/material.dart';
import '../image_manager/image_manager.dart';

class BackIcon extends StatelessWidget {
  final Function? onTap;
  const BackIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 12),
        child: Image.asset(ImageManager.kArrowLeft, width: 20, height: 10),
      ),
    );
  }
}
