import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/model/core/cable_tv_plan.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/screens/dashboard/services/cable_tv/misc/arg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/service_txn.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/available_balance.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../../../misc/transaction_pin/transaction_pin.dart';

class CableTv3 extends StatelessWidget {
  final CableTvArg arg;
  final CableTvPlan plan;
  const CableTv3({super.key, required this.arg, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: ColorManager.kWhite,
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kHorizontalScreenPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Icon(CupertinoIcons.xmark,
                    size: 20, color: ColorManager.kTextDark7),
              ),
            ),
          ),
          const AvailableBalance(),
          const SizedBox(height: 22),
          RichText(
            text: TextSpan(
              style: get24TextStyle().copyWith(fontWeight: FontWeight.w900),
              children: [
                TextSpan(text: "${formatNumber(arg.discount?.amount ?? 0)} "),
                const TextSpan(
                  text: "NGN",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          CustomContainer(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 18),
            header: Text(
              "SUMMARY",
              style: get14TextStyle().copyWith(color: ColorManager.kTextDark7),
            ),
            child: Column(
              children: [
                CustomKeyValueState(
                    title: "Service Provider", desc: arg.provider.name),
                CustomKeyValueState(title: "Decoder Number", desc: arg.number),
                CustomKeyValueState(title: "Plan", desc: plan.name),
                  num.parse(arg.discount?.discount.toString() ?? "0") <= 0 ? SizedBox.shrink() :     CustomKeyValueState(
                    title: "Discount",
                    titleW: Row(
                      spacing: 16,
                      children: [
                        Text("Discount",
                            style: get12TextStyle()
                                .copyWith(color: ColorManager.kTextDark7)),
                        Container(
                            height: 17,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            decoration: BoxDecoration(
                                color: ColorManager.kPrimaryLight,
                                borderRadius: BorderRadius.circular(100)),
                            child: Text(
                                "${formatDiscountPercentage(plan.amount.toDouble(), arg.discount?.discount?.toDouble() ?? 0)}%",
                                style: get12TextStyle()
                                    .copyWith(color: ColorManager.kBlack))),
                      ],
                    ),
                    desc: "N ${arg.discount?.discount}"),
            (arg.discount?.fee ?? 0) <= 0
                    ? SizedBox.shrink():
                    CustomKeyValueState(
                    title: "Service Charge", desc: formatCurrency(arg.discount?.fee ?? 0)),
            
                CustomKeyValueState(
                    title: "Amount", desc: formatCurrency(plan.amount)),
                               CustomKeyValueState(
                    title: "Total", desc: formatCurrency(arg.discount?.amount ?? 0)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Proceed",
            isActive: true,
            onTap: () async {
                  Navigator.pop(context);

              createTransaction(BuildContext context,
                  {required String transaction_pin}) async {
                try {
                  ServiceTxn _ = await ServicesHelper.purchaseCableTv(
                    provider: arg.provider.code,
                    number: arg.number,
                    code: plan.code,
                    type: arg.type.type.toLowerCase(),
                    pin: "$transaction_pin",
                  );

                  await Provider.of<UserProvider>(context, listen: false)
                      .updateUserInfo();

                  await Navigator.pushNamed(
                      context, RoutesManager.transactionStatus,
                      arguments: _);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                } catch (err) {
                  showCustomToast(
                      context: context, description: err.toString());
                }
              }

              await showCustomBottomSheet(
                  context: context,
                  screen: TransactionPin(funcCall: createTransaction));
            },
            loading: false,
          )
        ],
      ),
    );
  }
}
