import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/giftcard_txn.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils.dart';

class GiftcardTxnTile extends StatelessWidget {
  final GiftcardTxn param;
  const GiftcardTxnTile({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.giftcardHistoryDetailsView,
            arguments: param);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            buildTileIcon(param.gift_card?.category?.icon ?? ""),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getRemark(), style: get14TextStyle()),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: get14TextStyle()
                          .copyWith(color: ColorManager.kTextDark7),
                      children: [
                        TextSpan(text: "${formatDateSlash(param.created_at)}"),
                        TextSpan(
                            text: " | ",
                            style: TextStyle(color: ColorManager.kBar2Color)),
                        TextSpan(text: "${getTimeFromDate(param.created_at)}"),
                      ],
                    ),
                  ),

                  //
                ],
              ),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency(param.amount),
                  textAlign: TextAlign.right,
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  capitalize(enumToString(param.status)),
                  style: get14TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorManager.getGiftcardAndCryptoStatusTextColor(
                        param.status),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getRemark() {
    return capitalizeFirstString(param.gift_card?.name ?? "");
  }
}

Widget buildTileIcon(imageUrl) {
  return Container(
    height: 42,
    width: 42,
    decoration: BoxDecoration(
      color: ColorManager.kPrimaryLight,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
    ),
     
    // child: ClipRRect(
    //   borderRadius: BorderRadius.circular(50),
    //   child: loadNetworkImage(imageUrl,
    //       borderRadius: BorderRadius.circular(50), width: 42),
    // ),
  );
}
