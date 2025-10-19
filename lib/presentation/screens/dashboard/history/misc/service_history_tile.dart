import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/utils.dart';

class ServiceHistoryTile extends StatelessWidget {
  final ServiceTxn param;
  const ServiceHistoryTile({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, RoutesManager.historyDetails,
            arguments: param);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            buildTileIcon(),
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
                        TextSpan(text: "${formatDateSlash(param.createdAt)}"),
                        TextSpan(
                            text: " | ",
                            style: TextStyle(color: ColorManager.kBar2Color)),
                        TextSpan(text: "${getTimeFromDate(param.createdAt)}"),
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
                  formatCurrency(param.totalAmount),
                  textAlign: TextAlign.right,
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w600, fontFamily: GoogleFonts.roboto().fontFamily),
                ),
                const SizedBox(height: 4),
                Text(
                  capitalize(enumToString(param.status)),
                  style: get14TextStyle().copyWith(
                    fontWeight: FontWeight.w500,
                    color: ColorManager.getStatusTextColor(param.status),
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
  switch (param.purpose) {
    case ServicePurpose.withdrawal:
      return "Withdrawal";
    case ServicePurpose.deposit:
    case ServicePurpose.transfer:
      return param.remark;
    default:
      final provider = param.meta["provider"];
      final providerName = provider is Map ? provider["name"] ?? "" : "";
      return "$providerName ${ServiceTxn.serviceEnumToString(param.purpose)}";
  }
}
  Widget buildTileIcon() {
    switch (param.purpose) {
       case ServicePurpose.virtualCard:
        return Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: ColorManager.kPrimaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ImageManager.getWalletIcon(param.purpose,
              cashFlowType: param.type),
        );
      case ServicePurpose.deposit:
      case ServicePurpose.withdrawal:
      case ServicePurpose.transfer:
        return Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: ColorManager.kPrimaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ImageManager.getWalletIcon(param.purpose,
              cashFlowType: param.type),
        );
      
      default:
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6, right: 5),
              child: Image.asset(ImageManager.getServiceImage(param.purpose),
                  width: 44),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(78),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(1.5),
                child: loadNetworkImage(
                  param.meta["provider"]?["logo"] ?? "",
                  borderRadius: BorderRadius.circular(78),
                  width: 19,
                ),
              ),
            )
          ],
        );
    }
  }
}
