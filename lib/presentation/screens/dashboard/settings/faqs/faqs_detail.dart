import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/model/core/faq.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';

class FaqDetails extends StatelessWidget {
  final FaqData param;
  const FaqDetails({super.key, required this.param});

  final spacer = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: const BackIcon(),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              //
                              Text(
                                param.question,
                                textAlign: TextAlign.center,
                                style: get18TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),

                    //

                    //
                    customDivider(
                      height: 1,
                      margin: const EdgeInsets.only(top: 16, bottom: 15),
                      color: ColorManager.kBar2Color,
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        children: [
                          //
                          Text(
                            param.answer,
                            style: get14TextStyle().copyWith(height: 1.8),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(String text, {EdgeInsetsGeometry? margin}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: ColorManager.kBar2Color),
          borderRadius: BorderRadius.circular(19),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(text,
                  style:
                      get14TextStyle().copyWith(fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right, color: ColorManager.kBarColor)
          ],
        ),
      ),
    );
  }
}
