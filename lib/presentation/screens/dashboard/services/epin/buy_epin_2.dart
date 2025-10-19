import 'package:dataplug/core/constants.dart';
import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/generic_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../misc/available_balance.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_key_value_state.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../../../misc/transaction_pin/transaction_pin.dart';
import 'misc/epin_arg.dart';

class BuyEPin2 extends StatelessWidget {
  final EPinArg param;
  const BuyEPin2({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
  final fee = context.read<GenericProvider>().serviceCharge!.ePin ?? 0;
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
                TextSpan(text: "${formatNumber(param.epinProduct.amount)} "),
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
                    title: "Exam Type", desc: param.provider.name),
                CustomKeyValueState(
                    title: "Candidate Number", desc: param.number),
                  CustomKeyValueState(
                    title: "Amount",
                    desc: formatCurrency(param.epinProduct.amount)),
                num.parse(param.discount.discount.toString() ?? "0") <= 0
                    ? SizedBox.shrink()
                    : CustomKeyValueState(
                        title: "Discount",
                        titleW: Row(
                          spacing: 16,
                          children: [
                            Text("Discount",
                                style: get12TextStyle()
                                    .copyWith(color: ColorManager.kTextDark7)),
                            // Container(
                            //     height: 17,
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 8, vertical: 0),
                            //     decoration: BoxDecoration(
                            //         color: ColorManager.kPrimaryLight,
                            //         borderRadius: BorderRadius.circular(100)),
                            //     child: Text(
                            //         "${formatDiscountPercentage(param.epinProduct.amount.toDouble(), param.discount.discount?.toDouble() ?? 0)}%",
                            //         style: get12TextStyle()
                            //             .copyWith(color: ColorManager.kBlack))),
                          ],
                        ),
                        desc:
                            "N ${((param.discount.discount ?? 0)).toStringAsFixed(2)}"),
              
                fee <= 0
                    ? SizedBox.fromSize()
                    : CustomKeyValueState(
                        title: "Service Charge", desc: formatCurrency(fee)),
                CustomKeyValueState(
                    title: "Total",
                    desc: formatCurrency(param.discount.amount)),
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
                  ServiceTxn _ = await ServicesHelper.purchaseEPin(
                    product: param.epinProduct.id,
                    number: param.number,
                    pin: "$transaction_pin",
                  );
                  await userProvider.updateUserInfo();

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

              //
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
