import 'dart:developer';

import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/transaction_status/fake.dart';
import 'package:dataplug/presentation/screens/dashboard/card/card_receipt.dart';
import 'package:dataplug/presentation/screens/dashboard/card/create_card/arg/fund_card_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../core/model/core/card_data.dart';
import '../../../../../core/providers/card_provider.dart';
import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../misc/available_balance.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../../../misc/transaction_pin/transaction_pin.dart';
import '../create_card/arg/fund_card_summary_arg.dart';
import '../create_card/arg/withdrawal_card_summary.dart';

class WithdrawCardSummary extends StatelessWidget {
  final WithdrawCardSummaryArg param;
  const WithdrawCardSummary({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    CardProvider cardProvider = Provider.of<CardProvider>(context);
    final fee =  param.type.toLowerCase() == "dollar" ?  context.read<GenericProvider>().serviceCharge!.virtualCardWithdrawalUsd ?? 0 :  context.read<GenericProvider>().serviceCharge!.virtualCardWithdrawalNgn ?? 0;
   
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
                        "${formatNumber(num.parse(param.type.toLowerCase() == "dollar" ? param.fundingAmount.toString() : param.fundingAmount.toString() ?? "0") + fee)} "),
                TextSpan(
                  text: param.type.toLowerCase() == "dollar" ? "USD" : "NGN",
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
                CustomKeyValueState(
                    title: "Withdrawing Amount",
                    desc: formatCurrency(param.fundingAmount,
                        code: param.type.toLowerCase() == "dollar"
                            ? "USD"
                            : "NGN")),
                param.type.toLowerCase() == "dollar"
                    ? CustomKeyValueState(
                        title: "Naira Equivalent",
                        desc: formatCurrency(
                            param.fundingAmount * param.exchangeRate,
                            code: "NGN"))
                    : Gap(0),
                    CustomKeyValueState(
                    title: "Service Charge",
                    desc: formatCurrency(fee,
                        code: param.type.toLowerCase() == "dollar"
                            ? "USD"
                            : "NGN")),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Proceed",
            isActive: true,
            onTap: () async {
              final card = cardProvider.cards.where(
                (card) => card.id == param.id,
              );

              if (0 <= param.amountInNaira) {
                createTransaction(BuildContext context,
                    {required String transaction_pin}) async {
                  try {
                    CardData _ = await ServicesHelper.withdrawFromCard(
                      id: param.id,
                      request: FundCardRequest(
                          currency: param.type.toLowerCase() == "dollar"
                              ? "USD"
                              : "NGN",
                          amount: param.fundingAmount,
                          pin: transaction_pin),
                    );

                    await cardProvider.getUsersCards();
                    await cardProvider.getUsersCardTransactions(id: param.id);
                    // await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             CardHistoryDetails(param: _)));
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    log("REERER");
                  } catch (err) {
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
}
