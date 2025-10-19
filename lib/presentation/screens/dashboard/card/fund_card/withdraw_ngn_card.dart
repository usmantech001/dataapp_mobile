import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_scaffold.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/card/fund_card/withdraw_card_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_btn.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_snackbar.dart';
import '../create_card/arg/withdrawal_card_summary.dart';

class WithdrawNgnCard extends StatefulWidget {
  final String id;
  const WithdrawNgnCard({super.key, required this.id});

  @override
  State<WithdrawNgnCard> createState() => _WithdrawNgnCardState();
}

class _WithdrawNgnCardState extends State<WithdrawNgnCard> {
  final spacer = const SizedBox(height: 20);
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(children: [
              // Top header row with back icon and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: BackIcon(),
                  ),
                  Expanded(
                    child: Text(
                      "Withdraw NGN Card Funds",
                      textAlign: TextAlign.center,
                      style: get18TextStyle(),
                    ),
                  ),
                  const SizedBox(width: 40), // Space placeholder
                ],
              ),
              customDivider(height: 1, margin: const EdgeInsets.only(top: 16)),
              Gap(26),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row

                    spacer,

                    CustomInputField(
                        formHolderName: "Withdrawal Amount",
                        textInputAction: TextInputAction.done,
                        textEditingController: _amountController,
                        textInputType: TextInputType.number,
                        suffixConstraints: BoxConstraints(maxWidth: 200),
                        
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          // _amountFormatter
                        ],
                        validator: (val) => Validator.validateField(
                            fieldName: "Amount", input: val),
                        onChanged: (value) {}),
                   
                    spacer,
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: ColorManager.kPrimary.withValues(alpha: .21),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // Icon(Icons.info_outline, color: ColorManager.kPrimary), and text
                                Icon(Icons.info,
                                    color: ColorManager.kBlack, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Funds are withdrawn back to your main wallet.",
                                    style: get12TextStyle().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.kTextDark7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                // Spacer(),
                    Gap(120),

                    CustomButton(
                      text: "Proceed",
                      isActive: true,
                      onTap: () async {
                        if (_amountController.text.isEmpty) {
                          showCustomToast(
                            context: context,
                            description: "Please enter card holder name",
                          );
                          return;
                        }

                       

                   
                        // final payable = param.amount -
                        //     num.parse(param.discount.discount.toString() ?? "0") +
                        //     fee;
                        // if (userProvider.user.wallet_balance >= payable) {
                        //   createTransaction(BuildContext context,
                        //       {required String transaction_pin}) async {
                        //     try {
                        //       ServiceTxn _ = await ServicesHelper.buyAiritme(
                        //         phone: param.phone,
                        //         amount: payable,
                        //         isPorted: param.is_ported,
                        //         provider: param.airtimeProvider.code,
                        //         pin: "$transaction_pin",
                        //       );

                        //       await userProvider.updateUserInfo();

                        //       await Navigator.pushNamed(
                        //           context, RoutesManager.transactionStatus,
                        //           arguments: _);
                        //       Navigator.pop(context);
                        //       Navigator.pop(context);
                        //       Navigator.pop(context);
                        //     } catch (err) {
                        //       showCustomToast(
                        //           context: context, description: err.toString());
                        //     }
                        //   }

                        //   //
                        //   await showCustomBottomSheet(
                        //       context: context,
                        //       screen: TransactionPin(funcCall: createTransaction));
                        // } else {
                        //   showCustomToast(
                        //       context: context, description: "Insufficient Balance");
                        // }

                         await showCustomBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      screen: WithdrawCardSummary(
                                        param: WithdrawCardSummaryArg(
                                          id: widget.id, 
                                         exchangeRate: 0,
                                      
                                          amountInNaira: num.parse(_amountController.text),
                                     
                                          type: "Naira",
                                          fundingAmount: parseNum(_amountController.text
                                                  .replaceAll(",", "")) ??
                                              0,
                                        ),
                                      ),
                                    );
                      },
                      loading: false,
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
