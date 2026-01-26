import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_textfield.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/meter_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/buy_airtime_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BuyElectricityScreen extends StatefulWidget {
  const BuyElectricityScreen({super.key});

  @override
  State<BuyElectricityScreen> createState() => _BuyElectricityScreenState();
}

class _BuyElectricityScreenState extends State<BuyElectricityScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ElectricityController>().clearValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> meterTypes = ['Prepaid', 'Postpaid'];
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
    return Scaffold(
      appBar: CustomAppbar(title: 'Buy Electricity'),
      bottomNavigationBar: CustomBottomNavBotton(
          text: 'Continue',
          onTap: () {
            final controller = context.read<ElectricityController>();
            if (controller.meterNoErrMsg != null
                //|| controller.meterNumberController.text.isEmpty
                ) {
              showCustomToast(
                context: context,
                // meesage
                description:
                    "Merchant not verified. Please check the meter number and try again.",
              );
              return;
            }

            if (controller.amountController.text.isEmpty ||
                num.parse(formatUseableAmount(
                        controller.amountController.text)) <=
                    0) {
              showCustomToast(
                  context: context,
                  // meesage
                  description: "Please enter a valid amount");
              return;
            }

               final generalController = context.read<GeneralController>();
              num serviceCharge = generalController.serviceCharge?.electricity??0;
              num totalAmount = calculateTotalAmount(amount: formatUseableAmount(
                        controller.amountController.text.trim()), charge: serviceCharge);

            final summaryItems = [
              SummaryItem(
                  title: 'Electricity Provider',
                  name: controller.selectedProvider?.name ?? ""),
              SummaryItem(
                title: 'Meter Number',
                name: controller.meterNumberController.text.trim(),
                hasDivider: true,
              ),
              if(serviceCharge!=0) SummaryItem(
                  title: 'Service Charge',
                  name: formatCurrency(serviceCharge),
                  
                ),
              SummaryItem(
                  title: 'Recharge Amount',
                  name: controller.amountController.text.trim()),
                  SummaryItem(
                  title: 'Total Amount',
                  name: formatCurrency(totalAmount)),
            ];
            String meterType = controller.isPrepaid ? 'prepaid' : 'postpaid';
            final reviewModel = ReviewModel(
                summaryItems: summaryItems,
                amount: formatUseableAmount(controller.amountController.text),
                shortInfo: 'Recharge $meterType meter',
                providerType: 'Electricity',
                providerName: controller.selectedProvider?.name,
                logo: controller.selectedProvider?.logo,
                onChangeProvider: () => Navigator.pushNamed(
                      context,
                      RoutesManager.electricityProviders,
                    ),
                onPinCompleted: (pin) async {
                  displayLoader(context);
                  controller.buyUnit(
                    pin,
                    onSuccess: (transactionInfo) {
                      popScreen();
                      final items = getSummaryItems(
                          transactionInfo, TransactionType.electricity);
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
                    onError: (error) {
                      popScreen();
                      showCustomErrorTransaction(
                          context: context, errMsg: error);
                    },
                  );
                });
           showReviewBottomShhet(context, reviewDetails: reviewModel);
          }),
      body: Consumer<ElectricityController>(
          builder: (context, electricityController, child) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meter Type',
                      style: get18TextStyle()
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Gap(10),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                            child: MeterSelector(
                                meterType: meterTypes[0],
                                isSelected: electricityController.isPrepaid,
                                onTap: () {
                                  electricityController
                                      .toggleMeterType(MeterType.prepaid);
                                })),
                        Expanded(
                            child: MeterSelector(
                                meterType: meterTypes[1],
                                isSelected: !electricityController.isPrepaid,
                                onTap: () {
                                  electricityController
                                      .toggleMeterType(MeterType.postpaid);
                                })),
                      ],
                    ),
                  ],
                ),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInputField(
                      formHolderName: 'Meter Number',
                      hintText: 'Enter meter no.',
                      focusNode: electricityController.focusNode,
                      textEditingController:
                          electricityController.meterNumberController,
                    ),
                    electricityController.verifyingMeterNo
                        ? CustomVerifying(text: 'Verifying meter number')
                        : !electricityController.verifyingMeterNo &&
                                electricityController.meterNoErrMsg != null
                            ? Text(
                                electricityController.meterNoErrMsg!,
                                style: get14TextStyle()
                                    .copyWith(color: ColorManager.kError),
                              )
                            : electricityController.meterNumberController.text
                                        .isNotEmpty &&
                                    electricityController.attachedMeterName !=
                                        null
                                ? Container(
                                    padding: EdgeInsets.all(12.sp),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        color: ColorManager.kPrimary
                                            .withValues(alpha: .08),
                                        border: Border.all(
                                            color: ColorManager.kPrimary
                                                .withValues(alpha: .5))),
                                    child: RichText(
                                      maxLines: 1,
                                        text: TextSpan(
                                            text: 'Attached Name  ',
                                            style: get14TextStyle().copyWith(
                                                color: ColorManager.kGreyColor
                                                    .withValues(alpha: .7)),
                                                    children: [
                                                      TextSpan(
                                                        text: electricityController.attachedMeterName??"",
                                                        
                                                        style: get14TextStyle().copyWith(color: ColorManager.kPrimary, )

                                                      )
                                                    ]
                                                    )),
                                  )
                                : SizedBox(),
                  ],
                ),
                CustomInputField(
                  formHolderName: 'Phone Number',
                  hintText: 'Enter phone no.',
                  textEditingController: electricityController.phoneController,
                ),
                AmountTextField(
                  controller: electricityController.amountController,
                  onChanged: (value) {
                    electricityController.onAmountChanged(num.parse(value));
                  },
                ),
                AmountSuggestion(
                    selectedAmount:
                        electricityController.selectesSuggestedAmount,
                    onSelect: (amount) {
                      electricityController.onSuggestedAmountSelected(amount);
                    },
                    suggestedAmounts: suggestedAmounts)
              ],
            ),
          ),
        );
      }),
    );
  }
}
