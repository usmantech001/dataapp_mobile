import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_container.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class DepositMethodCard extends StatelessWidget {
  final Widget? header;
  final Widget? footer;

  final bool showNextArrow;
  final bool showBankIcon;
  final Function onTap;
  final VirtualAccountProvider provider;

  const DepositMethodCard(
      {super.key,
      required this.header,
      required this.footer,
      this.showNextArrow = false,
      this.showBankIcon = false,
      required this.onTap,
      required this.provider});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () => onTap(),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 14),
      footer: footer,
      header: header,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 4, bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: ColorManager.kPrimaryLight,
                ),
                padding: const EdgeInsets.all(15),
                child: Image.asset(ImageManager.kBankIcon, width: 16),
              ),
              if (showBankIcon)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Colors.white),
                    child: loadNetworkImage(provider.logo,
                        borderRadius: BorderRadius.circular(35), width: 18),
                  ),
                )
            ],
          ),

          SizedBox(width: showBankIcon ? 12 : 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeFirstString(provider.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        get14TextStyle().copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Fund via ${provider.name}",
                    style: get12TextStyle(),
                  ),
                ],
              ),
            ),
          ),
          //

          if (showNextArrow)
            Padding(
              padding: const EdgeInsets.only(left: 3, bottom: 12),
              child: Icon(Icons.keyboard_arrow_right_sharp,
                  color: ColorManager.kBarColor),
            )
        ],
      ),
    );
  }
}
