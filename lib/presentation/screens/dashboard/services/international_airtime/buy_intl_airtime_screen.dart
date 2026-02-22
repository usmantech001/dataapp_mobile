import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/intl_airtime_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_elements.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/error_widget.dart';
import 'package:dataplug/presentation/misc/custom_components/operator_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuyIntlAirtimeScreen extends StatefulWidget {
  const BuyIntlAirtimeScreen({super.key});

  @override
  State<BuyIntlAirtimeScreen> createState() => _BuyIntlAirtimeScreenState();
}

class _BuyIntlAirtimeScreenState extends State<BuyIntlAirtimeScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<IntlAirtimeController>();
      controller.getIntlAirtimeOperators();
      controller.clearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final intlAirtimeController = context.watch<IntlAirtimeController>();

    return Scaffold(
      appBar: CustomAppbar(title: "Buy International Airtime"),
      bottomNavigationBar: CustomBottomNavBotton(
          text: 'Proceed',
          onTap: () {
            final controller = context.read<IntlAirtimeController>();
            if (controller.selectedOperator == null) {
              showCustomToast(
                context: context,
                description: "Please select an operator",
              );
              return;
            }
            final summaryItems = [
              SummaryItem(
                  title: 'Country',
                  name: controller.selectedCountry?.name ?? ""),
              SummaryItem(
                  title: 'Operator',
                  name: controller.selectedOperator?.name ?? ""),
              SummaryItem(
                title: 'Phone number',
                name: controller.phoneController.text.trim(),
                hasDivider: true,
              ),
              SummaryItem(
                  title: 'Amount in Currency',
                  name:
                      "${controller.selectedOperator?.currency} ${controller.amountController.text.trim()}"),
              SummaryItem(
                  title: 'Amount',
                  name: '₦${controller.amountController.text.trim()}'),
            ];
            final reviewModel = ReviewModel(
                summaryItems: summaryItems,
                amount: controller.amountController.text.trim(),
                shortInfo: 'International Airtime',
                onPinCompleted: (pin) async {
                  displayLoader(context);
                  controller.buyInternationalAirtime(
                    pin,
                    onSuccess: (transactionInfo) {
                      popScreen();
                      final items = getSummaryItems(
                           transInfo:  transactionInfo, TransactionType.airtime);
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Consumer<IntlAirtimeController>(
            builder: (context, intlAirtimeController, child) {
          return Column(
            spacing: 24.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              intlAirtimeController.gettingOperators
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
                        intlAirtimeController.providerErrMsg != null
                              ? CustomError(
                                  errMsg: intlAirtimeController.providerErrMsg!,
                                  onRefresh: () {
                                    intlAirtimeController.getIntlAirtimeOperators();
                                  })
                              : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 8.w,
                            children: List.generate(
                                intlAirtimeController
                                    .intlAirtimeOperators.length, (index) {
                              final operator = intlAirtimeController
                                  .intlAirtimeOperators[index];
                              return OperatorSelector(
                                  name: operator.name,
                                  logo: operator.logo ?? "",
                                  isSelected: operator.name ==
                                      intlAirtimeController
                                          .selectedOperator?.name,
                                  onTap: () {
                                    intlAirtimeController
                                        .onSelectOperator(operator);
                                  });
                            }),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  spacing: 24.h,
                  children: [
                    CustomInputField(
                      formHolderName: 'Phone Number',
                      textEditingController:
                          intlAirtimeController.phoneController,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          intlAirtimeController.selectedCountry?.phone_code ??
                              "",
                          style: get14TextStyle(),
                        ),
                      ),
                    ),
                    CustomInputField(
                      formHolderName: "Amount",
                      textInputAction: TextInputAction.done,
                      textEditingController:
                          intlAirtimeController.amountController,
                      textInputType: TextInputType.number,
                      //suffixConstraints: BoxConstraints(maxWidth: 200),
                      suffixIcon: intlAirtimeController.selectedOperator != null
                          ? Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ColorManager.kPrimaryLight,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "₦${intlAirtimeController.rate.toStringAsFixed(5)} = 1 ${intlAirtimeController.selectedOperator?.currency ?? ""}",
                                style: TextStyle(
                                  color: ColorManager.kPrimary,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                ),
                              ),
                            )
                          : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // _amountFormatter
                      ],

                      onChanged: (value) {
                        intlAirtimeController.onAmountChanged();
                      },
                    ),
                    CustomInputField(
                      formHolderName: "Amount In Naira",
                      textInputAction: TextInputAction.done,
                      textEditingController: TextEditingController(
                          text:
                              "₦${intlAirtimeController.amountInNaira.toStringAsFixed(2)}"),
                      textInputType: TextInputType.number,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
