import 'package:dataplug/core/model/core/user_bank.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:flutter/material.dart';

import '../../../../../misc/color_manager/color_manager.dart';
import '../../../../../misc/custom_components/custom_container.dart';
import '../../../../../misc/image_manager/image_manager.dart';
import '../../../../../misc/style_manager/styles_manager.dart';

class BankCard extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final bool showDelete;
  final bool showNextArrow;
  final bool showBankIcon;
  final Function onTap;
  final Function? onDelete;
  final UserBank userBank;

  const BankCard(
      {super.key,
      required this.header,
      required this.footer,
      this.showDelete = true,
      this.showNextArrow = false,
      this.showBankIcon = false,
      required this.onTap,
      this.onDelete,
      required this.userBank});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomContainer(
          onTap: () => onTap(),
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 14),
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
                        child: loadNetworkImage(userBank.bank?.icon ?? "",
                            borderRadius: BorderRadius.circular(35), width: 20),
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
                      Text(userBank.bank_name,
                          style: get12TextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      const SizedBox(height: 3),
                      RichText(
                          text: TextSpan(
                        style: get14TextStyle()
                            .copyWith(fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: userBank.account_number),
                          TextSpan(
                            text: " | ",
                            style: TextStyle(color: ColorManager.kBar2Color),
                          ),
                          TextSpan(text: userBank.account_name)
                        ],
                      )),
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
        ),
        if (showDelete)
          Positioned(
            right: 10,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (onDelete != null) onDelete!();
              },
              child: Image.asset(ImageManager.kDeleteIcon, width: 24),
            ),
          )
      ],
    );
  }
}
