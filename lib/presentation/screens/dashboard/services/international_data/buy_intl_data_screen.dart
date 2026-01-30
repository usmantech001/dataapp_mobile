import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/intl_data_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
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
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BuyIntlDataScreen extends StatefulWidget {
  const BuyIntlDataScreen({super.key});

  @override
  State<BuyIntlDataScreen> createState() => _BuyIntlDataScreenState();
}

class _BuyIntlDataScreenState extends State<BuyIntlDataScreen> {
  // Map<String, String> dataTypes = {
  //   'direct': 'Direct',
  //   'sme' : 'SME/CG',
  //   'direct' : 'Smile',
  //   'direct' : ''
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<IntlDataController>();
      controller.getIntlDataOperators();
      controller.clearData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IntlDataController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: CustomAppbar(title: 'Buy International Data'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.gettingOperators
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
                       controller.providerErrMsg != null
                              ? CustomError(
                                  errMsg: controller.providerErrMsg!,
                                  onRefresh: () {
                                    controller.getIntlDataOperators();
                                  })
                              : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 8.w,
                                  children: List.generate(
                                      controller.intlDataOperators.length,
                                      (index) {
                                    final operator =
                                        controller.intlDataOperators[index];
                                    return OperatorSelector(
                                        name: operator.name,
                                        logo: operator.logo ?? "",
                                        isSelected: operator.name ==
                                            controller.selectedOperator?.name,
                                        onTap: () {
                                          controller.onSelectOperator(
                                            operator,
                                          );
                                        });
                                  }),
                                ),
                        ),
                      ],
                    ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    CustomInputField(
                      formHolderName: "Phone Number",
                      textInputAction: TextInputAction.next,
                      textEditingController: controller.phoneController,
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  'Data Packages',
                  style: get16TextStyle(),
                ),
              ),
              ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final plan = controller.allPlans[index];
                    return InkWell(
                      onTap: () {
                        if (controller.phoneController.text.isEmpty) {
                          showCustomToast(
                              context: context,
                              description: 'Please enter a phone number');
                          return;
                        }
                        controller.onSelectPlan(plan);
                        final summaryItems = [
                          SummaryItem(
                              title: 'Network',
                              name: controller.selectedOperator?.name ?? ""),
                          SummaryItem(
                            title: 'Phone number',
                            name: controller.phoneController.text.trim(),
                            hasDivider: true,
                          ),
                          SummaryItem(
                              title: 'Amount', name: plan.amount.toString()),
                        ];
                        final reviewModel = ReviewModel(
                            summaryItems: summaryItems,
                            amount: plan.amount.toString(),
                            shortInfo:
                                '${controller.selectedOperator?.name ?? ""} Data',
                            onPinCompleted: (pin) async {
                              displayLoader(context);
                              controller.buyInternationalData(
                                pin,
                                onSuccess: (transactionInfo) {
                                  popScreen();
                                  final items = getSummaryItems(
                                      transactionInfo, TransactionType.data);
                                  print(
                                      '....able to get the summary items $items');
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
                        showReviewBottomShhet(context,
                            reviewDetails: reviewModel);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                                color: ColorManager.kWhite,
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Column(
                              spacing: 12.h,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Text(
                                      plan.name,
                                      maxLines: 1,
                                      style: get14TextStyle().copyWith(
                                          color: ColorManager.kGreyColor
                                              .withValues(alpha: .7)),
                                    )),
                                    Gap(20),
                                    Text(
                                      formatCurrency(num.parse(plan.amountNgn),
                                          decimal: 0),
                                      style: get16TextStyle().copyWith(
                                          color: ColorManager.kPrimary),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: '15GB',
                                            style: get20TextStyle().copyWith(
                                                color: ColorManager.kGreyColor,
                                                fontWeight: FontWeight.w600),
                                            children: [
                                          TextSpan(
                                              text: ' / 30 days',
                                              style: get14TextStyle().copyWith(
                                                  color: ColorManager.kGreyColor
                                                      .withValues(alpha: .7)))
                                        ])),
                                    Gap(20),
                                    Text(
                                      formatCurrency(num.parse(plan.amountNgn),
                                          decimal: 0),
                                      style: get12TextStyle().copyWith(
                                          color: ColorManager.kGreyColor
                                              .withValues(alpha: .4)),
                                    )
                                  ],
                                ),
                                // Text('data')
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                  color: ColorManager.kGreen,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.r),
                                      bottomLeft: Radius.circular(4.r))),
                              child: Text(
                                'Best Selling',
                                style: get10TextStyle()
                                    .copyWith(color: ColorManager.kWhite),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap(10),
                  itemCount: controller.allPlans.length)
            ],
          ),
        ),
      );
    });
  }
}
