import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/deposit/deposit_2.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_back_icon.dart';
import '../../../../misc/custom_components/custom_elements.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_components/custom_scaffold.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/route_manager/routes_manager.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class Deposit1 extends StatefulWidget {
  const Deposit1({super.key});

  @override
  State<Deposit1> createState() => _Deposit1State();
}

class _Deposit1State extends State<Deposit1> {
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
                          "Top Up",
                          textAlign: TextAlign.center,
                          style: get18TextStyle(),
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
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
                        //
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
                    
                        const SizedBox(height: 95),
                        CustomButton(
                          text: "Proceed",
                          isActive: true,
                          onTap: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                    
                            //
                    
                            setState(() => btnLoading = true);
                            await ServicesHelper.getVirtualAccountProviders()
                                .then((value) {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.deposit2,
                                arguments: Deposit2Arg(
                                  providers: value,
                                  amount: parseNum(amountController.text) ?? 0,
                                ),
                              );
                            }).catchError((_) {
                              showCustomToast(
                                  context: context, description: "$_");
                            });
                    
                            setState(() => btnLoading = false);
                          },
                          loading: btnLoading,
                        ),
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

  bool btnLoading = false;
}
