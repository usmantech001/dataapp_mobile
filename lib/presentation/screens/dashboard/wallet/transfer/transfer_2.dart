import 'dart:developer';

import 'package:dataplug/core/model/core/user.dart';
import 'package:dataplug/presentation/misc/available_balance.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_progress.dart';
import 'package:dataplug/presentation/misc/image_manager/image_manager.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_bottom_sheet.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/style_manager/styles_manager.dart';
import 'transfer_3.dart';

class Transfer2 extends StatefulWidget {
  final User param;
  const Transfer2({super.key, required this.param});

  @override
  State<Transfer2> createState() => _Transfer2State();
}

class _Transfer2State extends State<Transfer2> {
  final spacer = const SizedBox(height: 40);

  TextEditingController amountController = TextEditingController(text: "");
  // final CurrencyTextInputFormatter _amountFormatter =
  //     CurrencyTextInputFormatter(symbol: "", decimalDigits: 2);
  ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log(widget.param.toMap().toString() ?? "");
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
                          "Wallet Transfer",
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      controller: controller,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: .5, color: ColorManager.kBar2Color),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              //
                              Stack(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(
                                        right: 8, bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: ColorManager.kPrimaryLight,
                                        image: DecorationImage(
                                            image: AssetImage(
                                          ImageManager.kProfilePlaceholderIcon,
                                        ))),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 15),
                                    // child: Image.asset(
                                    //     ImageManager.kProfilePlaceholderIcon,
                                    //     width: 18),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: loadNetworkImage(
                                        widget.param.avatar ?? "",
                                        width: 24,
                                        height: 24,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //
                    
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "${widget.param.firstname} ${widget.param.lastname}",
                                  style: get14TextStyle()
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                    
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
                    
                        const SizedBox(height: 75),
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
                              screen: Transfer3(
                                amount: parseNum(amountController.text) ?? 0,
                                user: widget.param,
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
