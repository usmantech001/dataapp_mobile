import 'package:dataplug/core/helpers/service_helper.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/providers/airtime_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_textfield.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/operator_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../misc/color_manager/color_manager.dart';
import '../../../../misc/custom_components/custom_input_field.dart';
import '../../../../misc/custom_snackbar.dart';
import '../../../../misc/style_manager/styles_manager.dart';

class BuyAirtime1 extends StatefulWidget {
  const BuyAirtime1({super.key});

  @override
  State<BuyAirtime1> createState() => _BuyAirtime1State();
}

class _BuyAirtime1State extends State<BuyAirtime1> {
  final spacer = const SizedBox(height: 20);
  final List<String> suggestedAmounts = [
    '50',
    '100',
    '200',
    '500',
    '800',
    '1000',
    '2000',
    '2500'
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AirtimeController>().getAirtimeProviders();
    });
    super.initState();
  }

  //

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AirtimeController>(builder: (context, controller, child) {
      return Scaffold(
        // backgroundColor: ColorManager.kPrimary,

        appBar: CustomAppbar(title: 'Buy Airtime'),
        bottomNavigationBar: CustomBottomNavBotton(
            text: 'Proceed',
            onTap: () {
              if (controller.selectedProvider == null) {
                showCustomToast(
                  context: context,
                  description: "Please select a network",
                );
                return;
              }
              final generalController = context.read<GeneralController>();
              num serviceCharge = generalController.serviceCharge?.airtime??0;
              num totalAmount = calculateTotalAmount(amount: formatUseableAmount(
                        controller.amountController.text.trim()), charge: serviceCharge);
              final summaryItems = [
                SummaryItem(
                    title: 'Network',
                    name: controller.selectedProvider?.name ?? ""),
                SummaryItem(
                  title: 'Phone number',
                  name: controller.phoneNumberController.text.trim(),
                  hasDivider: true,
                ),
               if(serviceCharge!=0) SummaryItem(
                  title: 'Service Charge',
                  name: formatCurrency(serviceCharge),
                  
                ),
                SummaryItem(
                    title: 'Amount',
                    name: formatCurrency(totalAmount, decimal: 0)),
              ];
              final reviewDetails = ReviewModel(
                  summaryItems: summaryItems,
                  providerName: controller.selectedProvider?.name,
                  logo: controller.selectedProvider?.logo??"",
                  amount: formatUseableAmount(
                      controller.amountController.text.trim()),
                  shortInfo:
                      '${controller.selectedProvider?.name ?? ""} Airtime',
                  onPinCompleted: (pin) async {
                    displayLoader(context);
                    controller.buyAirtime(
                      pin,
                      onSuccess: (transactionInfo) {
                        popScreen();
                        final items = getSummaryItems(
                            transactionInfo, TransactionType.airtime);
                        print('....able to get the summary items $items');
                        final review = ReceiptModel(
                            summaryItems: items,
                            amount: transactionInfo.amount.toString(),
                            shortInfo:
                                '${transactionInfo.meta.provider?.name ?? ""} Airtime');
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.successful,
                            (Route<dynamic> route) => false,
                            arguments: review);
                      },
                      onError: (error) async{
                        popScreen();
                        showCustomErrorTransaction(
                            context: context, errMsg: error);
                      },
                    );
                  });
             showReviewBottomShhet(context, reviewDetails: reviewDetails);
            }),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                controller.gettingProviders
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 8.w,
                            children: List.generate(
                                4, (index) => OperatorSelectorShimmer())),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Text(
                              'Select Operator',
                              style: get16TextStyle(),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 8.w,
                              children: List.generate(
                                  controller.airtimeProviders.length, (index) {
                                final operator =
                                    controller.airtimeProviders[index];
                                return OperatorSelector(
                                    name: operator.name,
                                    logo: operator.logo ?? "",
                                    isSelected: operator.name ==
                                        controller.selectedProvider?.name,
                                    onTap: () {
                                      controller.onSelectProvider(operator);
                                    });
                              }),
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20.h,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInputField(
                            formHolderName: "Phone Number",
                            textInputAction: TextInputAction.next,
                            textEditingController:
                                controller.phoneNumberController,
                            textInputType: TextInputType.number,
                            suffixIcon: InkWell(
                              onTap: () async {
                                /*
                                            Contact? res =
                                                await showCustomBottomSheet(
                                              context: context,
                                              isDismissible: true,
                                              screen: SelectFromContactWidget(),
                                            );
                                            if (res != null) {
                                              phoneController.text = res
                                                  .phones.first.number
                                                  .replaceAll(" ", "")
                                                  .replaceAll("(", "")
                                                  .replaceAll(")", "")
                                                  .replaceAll("+234", "0")
                                                  .replaceAll("-", "")
                                                  .trim();
                                              setState(() {});
                                            }
                                            */
                              },
                              child: Icon(
                                Icons.person,
                                size: 24,
                                color: ColorManager.kPrimary,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          if (controller.phoneError)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.only(left: 3, top: 2),
                              child: const Text(
                                "Phone number does not match selected network",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: controller.toggleIsPorted,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.isPorted,
                                  activeColor: ColorManager.kPrimary,
                                  onChanged: (v) => controller.toggleIsPorted(),
                                ),
                                const Text("Is this number ported?"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //spacer,
                      AmountTextField(
                        controller: controller.amountController,
                        onChanged: (value) {
                          controller.onAmountChanged(num.parse(value));
                        },
                      ),
                      AmountSuggestion(
                          selectedAmount: controller.selectedSuggestedAmount,
                          onSelect: (amount) {
                            controller.onSuggestedAmountSelected(amount);
                          },
                          suggestedAmounts: suggestedAmounts)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}



num calculateTotalAmount({required String amount,required num charge }){
  final total = (num.tryParse(amount)??0) + charge;
  return total;
}