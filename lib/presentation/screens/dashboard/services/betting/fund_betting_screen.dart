import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/betting_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_container.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/buy_airtime_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FundBettingScreen extends StatefulWidget {
  const FundBettingScreen({super.key});

  @override
  State<FundBettingScreen> createState() => _FundBettingScreenState();
}

class _FundBettingScreenState extends State<FundBettingScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BettingController>().clearValues();
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<String> suggestedAmounts = [
      '500',
      '1000',
      '1500',
      '2000',
      '3000',
      '5000',
      '10000',
      '20000'
    ];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: CustomAppbar(title: 'Fund Betting'),
        bottomNavigationBar: CustomBottomNavBotton(
            text: 'Continue',
            onTap: () {
              final controller = context.read<BettingController>();
              // if (controller.meterNoErrMsg != null 
              // //|| controller.meterNumberController.text.isEmpty
              // ) {
              //   showCustomToast(
              //     context: context,
              //     // meesage
              //     description:
              //         "Merchant not verified. Please check the meter number and try again.",
              //   );
              // }
      
              if (controller.amountController.text.isEmpty ||
                  num.parse(formatUseableAmount(controller.amountController.text)) <= 0) {
                showCustomToast(
                  context: context,
                  // meesage
                  description:
                      "Please enter a valid amount.",
                );
                return;
              }
       final generalController = context.read<GeneralController>();
              num serviceCharge = generalController.serviceCharge?.betting??0;
              num totalAmount = calculateTotalAmount(amount: formatUseableAmount(
                        controller.amountController.text.trim()), charge: serviceCharge);

               final summaryItems = [
                SummaryItem(title: 'Betting Provider', name: controller.selectedProvider?.name ?? ""),
                SummaryItem(
                  title: 'Bet ID / Phone Number',
                  name: controller.bettingNumberController.text.trim(),
                  
                ),
                SummaryItem(
                  title: 'Attached Name',
                  name: controller.attachedName??'',
                  hasDivider: true,
                ),
                SummaryItem(
                    title: 'Amount', name: controller.amountController.text.trim()),
               if(serviceCharge!=0) SummaryItem(
                    title: 'Service Charge', name: formatCurrency(serviceCharge), hasDivider: true,),    
                SummaryItem(
                    title: 'Total Amount', name: formatCurrency(totalAmount)),     
              ];
              final reviewModel = ReviewModel(
                  summaryItems: summaryItems,
                  amount: formatUseableAmount(controller.amountController.text),
                  providerType: 'Electricity',
                  providerName: controller.selectedProvider?.name,
                  logo: controller.selectedProvider?.logo,
                  onChangeProvider: () => Navigator.pushNamed(context, RoutesManager.electricityProviders,),
                  onPinCompleted: (pin) async {
                    print('...on pin completed $pin');
                    controller.fundBetting(pin,  onSuccess: (transactionInfo) {
                        final items = getSummaryItems(
                            transactionInfo, TransactionType.airtime);
                        print('....able to get the summary items $items');
                        final review = ReceiptModel(
                            summaryItems: items,
                            amount: transactionInfo.amount.toString(),
                            shortInfo: 'Fund Betting');
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.successful,
                            (Route<dynamic> route) => false,
                            arguments: review);
                      }, onError: (error) {
                      showCustomErrorTransaction(context: context, errMsg: error);
                    } ,);
                   
                  });
                showReviewBottomShhet(context, reviewDetails: reviewModel);
      
      
            }),
        body: Consumer<BettingController>(
            builder: (context, bettingController, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24, bottom: 30),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // dismisses keyboard
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                 ReviewHeaderContainer(
                providerType: "Betting",
                providerName: bettingController.selectedProvider?.name??"",
                logo: bettingController.selectedProvider?.logo??"",
                
                onChange: (){},
              ),
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        formHolderName: 'Bet ID / Phone Number',
                        hintText: 'Enter Bet ID / Phone Number',
                        focusNode: bettingController.focusNode,
                        textEditingController:
                            bettingController.bettingNumberController,
                      ),
                      bettingController.verifyingBettingNo
                          ? CustomVerifying(text: 'Verifying Bet ID')
                          : !bettingController.verifyingBettingNo &&
                                  bettingController.bettingNoErrMsg != null
                              ? Text(
                                  bettingController.bettingNoErrMsg!,
                                  style: get14TextStyle()
                                      .copyWith(color: ColorManager.kError),
                                )
                              : SizedBox(),
                    ],
                  ),
                  
                  AmountTextField(
                    controller: bettingController.amountController,
                    onChanged: (value) {
                      bettingController.onAmountChanged(num.parse(value));
                    },
                  ),
                  AmountSuggestion(
                      selectedAmount:
                          bettingController.selectedSuggestedAmount,
                      onSelect: (amount) {
                        bettingController.onSuggestedAmountSelected(amount);
                      },
                      suggestedAmounts: suggestedAmounts)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AmountTextField extends StatelessWidget {
  const AmountTextField(
      {super.key, required this.controller, required this.onChanged});
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Amount',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              cursorHeight: 30,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
