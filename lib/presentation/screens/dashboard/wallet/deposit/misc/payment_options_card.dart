import 'package:flutter/material.dart';

import '../../../../../../core/model/core/virtual_account_provider.dart';
import '../../../../../../core/utils/utils.dart';
import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_container.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class PaymentOptionsCard extends StatelessWidget {
  final Widget? header;
  final Widget? footer;

  final Function onTap;
  final VirtualAccProviderPaymentOptions provider;

  const PaymentOptionsCard(
      {super.key,
      required this.header,
      required this.footer,
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
          Container(
            margin: const EdgeInsets.only(right: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: ColorManager.kPrimaryLight,
            ),
            padding: const EdgeInsets.all(15),
            child: Image.asset(ImageManager.kBankIcon, width: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                "By ${capitalize(provider.name)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: get14TextStyle().copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 12),
            child: Icon(
              Icons.keyboard_arrow_right_sharp,
              color: ColorManager.kBarColor,
            ),
          )
        ],
      ),
    );
  }
}
