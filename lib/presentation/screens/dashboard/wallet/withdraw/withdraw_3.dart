import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/user_bank.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

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

class Withdraw3 extends StatelessWidget {
  final UserBank userBank;
  final num amount;
  const Withdraw3({super.key, required this.userBank, required this.amount});

  @override
  Widget build(BuildContext context) {
         final fee = context.read<GenericProvider>().serviceCharge?.withdrawal ?? 0;
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
                TextSpan(text: formatNumber(amount + fee)),
                const TextSpan(
                  text: " NGN",
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
                    title: "Bank Name", desc: userBank.bank_name),
                CustomKeyValueState(
                    title: "Bank Account Number",
                    desc: userBank.account_number),
                CustomKeyValueState(
                    title: "Bank Account Name", desc: userBank.account_name),
                   fee  <= 0
                    ? SizedBox.shrink()
                    : CustomKeyValueState(
                        title: "Service Charge",
                        desc: formatCurrency(fee)),
                CustomKeyValueState(
                    title: "Amount", desc: formatCurrency(amount)),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "Proceed",
            isActive: true,
            onTap: () async {
              createTransaction(BuildContext context,
                  {required String transaction_pin}) async {
                try {
                  ServiceTxn _ = await ServicesHelper.makeWithdrawal(
                    bank_account_id: userBank.id,
                    amount: "$amount",
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
