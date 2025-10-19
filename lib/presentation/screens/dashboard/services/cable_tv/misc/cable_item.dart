import 'package:dataplug/core/model/core/cable_tv_provider.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/model/core/cable_tv_plan.dart';

class CableTvItem extends StatelessWidget {
  final Function(CableTvPlan) onTap;
  final CableTvProvider provider;
  final CableTvPlan plan;
  const CableTvItem({
    super.key,
    required this.onTap,
    required this.plan,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(plan),
      child: Stack(
        children: [
          Container(
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
                Text(formatCurrency(plan.amount), style: get16TextStyle()),
                const SizedBox(height: 8),
                Text(
                  plan.name,
                  textAlign: TextAlign.center,
                  style: get12TextStyle()
                      .copyWith(color: ColorManager.kTextDark.withOpacity(.6)),
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
                    borderRadius: BorderRadius.circular(50),
                    color: ColorManager.kPrimaryLight,
                  ),
                  child: Text(
                    provider.name,
                    style: get12TextStyle().copyWith(
                      color: ColorManager.kPrimary,
                    ),
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
