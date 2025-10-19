import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/utils/utils.dart';

class InternetDataItem extends StatelessWidget {
  final DataPlan plan;
  final Function onTap;
  const InternetDataItem({super.key, required this.onTap, required this.plan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            padding:
                const EdgeInsets.only(top: 28, right: 14, left: 14, bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(width: .6, color: ColorManager.kBar2Color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(plan.bundle ?? "", textAlign: TextAlign.center, style: get14TextStyle().copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                // const SizedBox(height: 8),
                Text(
                  "${plan.duration.toUpperCase()} Day",
                  textAlign: TextAlign.center,
                  style: get14TextStyle().copyWith(
                    color: ColorManager.kTextDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.kPrimaryLight,
                  ),
                  child: Text(

                    "${getCurrencySymbol('NGN')} ${formatNumber(plan.amount, short: true)}",
                    textAlign: TextAlign.center,
                    style:
                        get12TextStyle().copyWith(color: ColorManager.kPrimary, fontFamily: GoogleFonts.roboto().fontFamily, ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
