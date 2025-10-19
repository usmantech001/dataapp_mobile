import 'package:dataplug/core/enum.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_container.dart';
import '../../../../misc/image_manager/image_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class SelectCardCurrency extends StatelessWidget {
  const SelectCardCurrency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: ColorManager.kWhite,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding, vertical: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Icon(CupertinoIcons.xmark,
                      size: 20, color: Colors.transparent),
                ),
              ),
              Text("Create Virtual Card", style: get18TextStyle()),

              //
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Icon(CupertinoIcons.xmark,
                      size: 20, color: ColorManager.kTextDark7),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 24,
                top: 24,
              ),
              child: Text(
                "Kindly select the virtual card type you want to create",
                style: get14TextStyle().copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorManager.kFadedTextColor),
              ),
            ),
          ),
          CustomContainer(
            onTap: () {
              Navigator.pop(context);

              Navigator.pushNamed(
                context,
                RoutesManager.createDollarCard,
              );

            },
            footer: const SizedBox(
              width: 100,
              height: 30,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      Image.asset(Assets.images.kVirtualCard2.path, width: 44),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Image.asset(
                          Assets.images.usdflag.path,
                          width: 16,
                          height: 24,
                        ),
                      ),
                    ]),
                const SizedBox(width: 16),
                const SizedBox(height: 16),
                Text("USD Card",
                    style:
                        get14TextStyle().copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(
            width: 24,
          ),
          CustomContainer(
            onTap: () {
              Navigator.pop(context);

              Navigator.pushNamed(
                context,
                RoutesManager.createNairaCard,
              );
              // Navigator.pop(context);
            },
            // footer: const SizedBox(width: 100, height: 10),
            header: const SizedBox(
              width: 100,
              height: 30,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      Image.asset(Assets.images.kVirtualCard2.path, width: 44),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Image.asset(
                          Assets.images.ngnFlag.path,
                          width: 16,
                          height: 24,
                        ),
                      ),
                    ]),
                const SizedBox(width: 16),
                Text("NGN Card",
                    style:
                        get14TextStyle().copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
