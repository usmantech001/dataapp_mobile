import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/screens/dashboard/services/giftcard/arg.dart';
import '../../../../../core/helpers/service_helper.dart';
import '../../../../../core/model/core/giftcard_txn.dart';
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

class Giftcard2 extends StatelessWidget {
  final GiftcardArg arg;

  const Giftcard2({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
        final fee = context.read<GenericProvider>().serviceCharge?.giftcard ?? 0;
    return Container(
      height: 600,
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
                TextSpan(text: "${formatNumber(double.parse(arg.breakdown.payableAmount))} "),
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
                CustomKeyValueState(title: "Category", desc: arg.category),
                CustomKeyValueState(
                    title: "Product",
                    desc:
                        arg.product.name),
                // CustomKeyValueState(title: "Rate", desc: NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(arg.product.buyRate)),
                CustomKeyValueState(title: "Type", desc: arg.type.toName()),
                CustomKeyValueState(title: "Rate", desc:  formatCurrency(num.parse(arg.breakdown.rate))),
                CustomKeyValueState(
                    title: "Amount in currency",
                    desc:
                        formatCurrency(double.parse(arg.amount), code: "USD")),
                CustomKeyValueState(title: "Quantity", desc: arg.quantity),
                 (num.parse(arg.breakdown.serviceCharge ?? "0")) <= 0
                    ? SizedBox.shrink()
                    : CustomKeyValueState(
                        title: "Service Charge",
                        desc: formatCurrency(num.parse(arg.breakdown.serviceCharge))),

                CustomKeyValueState(
                    title: "Amount",
                    desc: formatCurrency(double.parse(arg.breakdown.amount))),
                                    CustomKeyValueState(
                    title: "Total",
                    desc:
                        formatCurrency((double.parse(arg.breakdown.payableAmount) + fee), code: "NGN")),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Proceed",
            isActive: true,
            onTap: () async {
              log(arg.breakdown.payableAmount.toString());
                  Navigator.pop(context);
              createTransaction(BuildContext context,
                  {required String transaction_pin}) async {
           

                try {
                  int safeQuantity = 0;
                  try {
                    safeQuantity = int.parse(arg.quantity);
                  } catch (_) {
                    safeQuantity = 0;
                  }
                  GiftcardTxn _ = await ServicesHelper.buyGiftcard(
                    amount: double.parse(arg.amount),
                    pin: transaction_pin,
                    giftcardId: arg.product.id,
                    payoutMethod: '',
                    quantity: safeQuantity,
                    tradeType: "buy",
                    cards: [],
                    cardType: arg.type.toName().toString(),
                  );

                  // await Provider.of<UserProvider>(context, listen: false)
                  //     .updateUserInfo();

                  await Navigator.pushNamed(
                      context, RoutesManager.giftcardTransactionStatus,
                      arguments: _);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.pop(context);
                } catch (err, s) {

                  log("Error creating giftcard transaction: $err\n$s");
                  log("Error creating giftcard transaction stack: $s");
               
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
