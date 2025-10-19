import 'package:flutter/material.dart';

import '../color_manager/color_manager.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? footer;
  final Widget? leftSider;
  final Widget? rightSider;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadiusSize;
  final Function? onTap;
  final double? width;
  const CustomContainer(
      {super.key,
      required this.child,
      this.margin,
      this.padding,
      this.footer,
      this.header,
      this.borderRadiusSize,
      this.onTap,
      this.width,
      this.leftSider,
      this.rightSider});

  @override
  Widget build(BuildContext context) {
    double topSpacer = 9;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              width: width,
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusSize ?? 19),
                border: Border.all(width: 1, color: ColorManager.kBar2Color),
              ),
              child:
                  Padding(padding: const EdgeInsets.only(top: 5), child: child),
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    color: ColorManager.kWhite,
                    padding: EdgeInsets.symmetric(horizontal: topSpacer),
                    alignment: Alignment.center,
                    child: header,
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: ColorManager.kWhite,
                    padding: EdgeInsets.symmetric(horizontal: topSpacer),
                    alignment: Alignment.center,
                    child: footer,
                  ),
                ],
              ),
            ),

            if (leftSider != null)
              Positioned(
                bottom: 0,
                top: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: ColorManager.kWhite,
                      width: 9,
                      padding: EdgeInsets.symmetric(horizontal: topSpacer),
                      alignment: Alignment.center,
                      child: leftSider,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

            if (rightSider != null)
              Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: ColorManager.kWhite,
                      width: 9,
                      padding: EdgeInsets.symmetric(horizontal: topSpacer),
                      alignment: Alignment.center,
                      child: rightSider,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
