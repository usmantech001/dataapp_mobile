import 'dart:developer';

import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/providers/card_provider.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/transaction_status/fake.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/card_data.dart';
import '../../../../../core/model/core/service_txn.dart';
import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/available_balance.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../../../misc/transaction_pin/transaction_pin.dart';
import 'arg/card_request.dart';
import 'arg/card_summary_arg.dart';

class CardSummary extends StatelessWidget {
  final CardSummaryArg param;
  const CardSummary({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
CardProvider cardProvider = Provider.of<CardProvider>(context);
    return Container(
      height: 530,
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
                TextSpan(
                    text:
                        "${formatNumber(num.parse(param.type.toLowerCase() == "dollar" ? param.amountInNaira.toString() : param.amountInNaira.toString() ?? "0"))} "),
                const TextSpan(
                  text: "NGN",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
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
                CustomKeyValueState(title: "Card Type", desc: param.type),
                CustomKeyValueState(
                    title: "Card Holder Name", desc: param.holderName),
                CustomKeyValueState(
                    title: "Card Issuer",
                    desc: capitalizeFirstString(param.issuer)),
                CustomKeyValueState(
                    title: "Card Creation Fee",
                    desc: formatCurrency(num.parse(param.fee.toString() ?? "0"),
                        code: param.type.toLowerCase() == "dollar"
                            ? "USD"
                            : "NGN")),
                param.type.toLowerCase() == "dollar"
                    ? CustomKeyValueState(
                        title: "Minimum Card Balance",
                        desc:
                            "\$${param.amount}")
                    : CustomKeyValueState(
                        title: "Minimum Card Balance",
                        desc:
                            formatCurrency(param.amount)),
                            param.type.toLowerCase() == "dollar"
                    ? CustomKeyValueState(
                        title: "Rate",
                        desc:
                            "${formatCurrency(param.rate)}")
                    : SizedBox.shrink(),
                param.type.toLowerCase() == "dollar"
                    ? CustomKeyValueState(
                        title: "Naira Equivalent",
                        desc: formatCurrency(param.amountInNaira))
                    : Gap(0),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Proceed",
            isActive: true,
            onTap: () async {
              if (userProvider.user.wallet_balance >= param.amountInNaira) {
                createTransaction(BuildContext context,
                    {required String transaction_pin}) async {

                      log(param.amountInNaira.toString());
                      log(param.amount.toString());
                  try {
                    // final pinValue = transaction_pin;
                    // if (pinValue == null) {
                    //   showCustomToast(
                    //     context: context,
                    //     description:
                    //         "Invalid PIN. Please enter a 4-digit number.",
                    //   );
                    //   return;
                    // }
                    CardData _ = await ServicesHelper.createCard(
                      request: CreateCardRequest(
                        currency: param.type.toLowerCase() == "dollar"
                            ? "USD" : "NGN",
                        amount: param.amount,
                        name: param.holderName,
                        brand: param.issuer,
                        address: param.address,
                        pin: transaction_pin,
                      )
                    );

                    // await userProvider.updateUserInfo();
                    cardProvider.getUsersCards();
// 
                    // await Navigator.pushNamed(
                    //     context, RoutesManager.transactionStatus,
                    //     arguments: _);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    Navigator.pop(context);
                    Navigator.pop(context);
                    log("REERER");
                  } catch (err, s) {
                    log(s.toString(), name: "Stack");
                    showCustomToast(
                        context: context, description: err.toString());
                  }
                }

                //
                await showCustomBottomSheet(
                    context: context,
                    screen: TransactionPin(funcCall: createTransaction));
              } else {
                showCustomToast(
                    context: context, description: "Insufficient Balance");
              }
            },
            loading: false,
          )
        ],
      ),
    );
  }

  print10() {
    log("10");
  }
}
