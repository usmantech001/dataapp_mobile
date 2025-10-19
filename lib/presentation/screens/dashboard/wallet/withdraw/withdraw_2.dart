import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/model/core/user_bank.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/available_balance.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import '../../settings/bank/misc/bank_card.dart';
import 'withdraw_3.dart';

class Withdraw2 extends StatefulWidget {
  final UserBank param;
  const Withdraw2({super.key, required this.param});

  @override
  State<Withdraw2> createState() => _Withdraw2State();
}

class _Withdraw2State extends State<Withdraw2> {
  final spacer = const SizedBox(height: 40);

  TextEditingController amountController = TextEditingController(text: "");
  // final CurrencyTextInputFormatter _amountFormatter =
  //     CurrencyTextInputFormatter(symbol: "", decimalDigits: 2);
  ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorManager.kPrimary,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.topLeft,
                        child: const BackIcon(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Withdraw",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: CustomProgress(value: 2, valuePerct: .9),
                      ),
                    ),
                  ],
                ),

                //

                //
                customDivider(
                  height: 1,
                  margin: const EdgeInsets.only(top: 16, bottom: 30),
                  color: ColorManager.kBar2Color,
                ),

                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        BankCard(
                          footer: null,
                          header: null,
                          showDelete: false,
                          showBankIcon: true,
                          onTap: () {},
                          userBank: widget.param,
                        ),
                        const SizedBox(height: 15),
                        const Center(child: AvailableBalance()),
                        //
                        spacer,
                        CustomInputField(
                          formHolderName: "Amount",
                          textEditingController: amountController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // _amountFormatter
                          ],
                          validator: (val) => Validator.validateField(
                              fieldName: "Amount", input: val),
                          onChanged: (_) => setState(() {}),
                        ),
                    
                        const SizedBox(height: 55),
                        CustomButton(
                          text: "Proceed",
                          isActive: true,
                          onTap: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                    
                            showCustomBottomSheet(
                              context: context,
                              isDismissible: true,
                              screen: Withdraw3(
                                userBank: widget.param,
                                amount: parseNum(amountController.text) ?? 0,
                              ),
                            );
                          },
                          loading: false,
                        ),
                        //
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
