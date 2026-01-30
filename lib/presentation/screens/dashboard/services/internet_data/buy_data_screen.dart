import 'package:dataplug/core/model/core/data_plans.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/data_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_bottom_sheet.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/error_widget.dart';
import 'package:dataplug/presentation/misc/custom_components/operator_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_components/toggle_selector_widget.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/select_contact.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/buy_airtime_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({super.key});

  @override
  State<BuyDataScreen> createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<DataController>();
      controller.getDataProviders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: CustomAppbar(title: 'Buy Data'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToggleSelectorWidget(
                tabIndex: controller.selectedTypeIndex,
                tabText: controller.dataTypes,
                onTap: (index) {
                  controller.onSelectDataType(index);
                },
              ),
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
                        Padding(
                          // scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: controller.providerErrMsg!=null? CustomError(errMsg: controller.providerErrMsg!, onRefresh: (){
                            controller.getDataProviders();
                          }):  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: MediaQuery.sizeOf(context).width * 0.02,
                            children: List.generate(controller.providers.length,
                                (index) {
                              final operator = controller.providers[index];
                              return OperatorSelector(
                                  name: operator.name,
                                  logo: operator.logo ?? "",
                                  isSelected: operator.name ==
                                      controller.selectedProvider?.name,
                                  onTap: () {
                                    controller.onSelectProvider(operator,
                                        isPreSelect: false);
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
                      textEditingController: controller.phoneNumberController,
                      textInputType: TextInputType.number,
                      suffixIcon: InkWell(
                        onTap: () async {
                          bool permissionGranted =
                              await FlutterContacts.requestPermission();
                          if (permissionGranted) {
                            Contact? res = await showCustomBottomSheet(
                              context: context,
                              isDismissible: true,
                              screen: SelectFromContactWidget(),
                            );
                            if (res != null) {
                              print('...response from contact is $res');
                              // phoneController.text = res
                              //     .phones.first.number
                              //     .replaceAll(" ", "")
                              //     .replaceAll("(", "")
                              //     .replaceAll(")", "")
                              //     .replaceAll("+234", "0")
                              //     .replaceAll("-", "")
                              //     .trim();
                              setState(() {});
                            }
                          }
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
              controller.gettingPlans
                  ? GridView.count(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(9, (index) {
                        return PlanBoxShimmer();
                      }),
                    )
                  : controller.plansErrMsg != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            spacing: 30.h,
                            children: [
                              Text(controller.plansErrMsg ?? "", textAlign: TextAlign.center,),
                              CustomButton(
                                text: 'Retry',
                                width: 180.w,
                                isActive: true,
                                onTap: () {
                                  if(controller.selectedTypeIndex==0){
                                    controller.getDataPlans();
                                  }else{
                                    controller.getDataPlanTypes();
                                  }
                                },
                                loading: false,
                                border: Border.all(
                                  color: ColorManager.kPrimary,
                                ),
                                textColor: ColorManager.kPrimary,
                                backgroundColor: ColorManager.kGreyF5,
                              )
                            ],
                          ),
                        )
                      : controller.allPlans.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.h,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Row(
                                    spacing: 8.w,
                                    children: controller.selectedTypeIndex == 0
                                        ? List.generate(
                                            controller.dataPlanTypes.length,
                                            (index) {
                                            final type =
                                                controller.dataPlanTypes[index];
                                            return PlanTab(
                                              planType: type,
                                              isSelected: controller.type ==
                                                  type
                                                      .split(" ")
                                                      .last
                                                      .toLowerCase(),
                                              onTap: () {
                                                controller.onSelectPlanType(type
                                                    .split(" ")
                                                    .last
                                                    .toLowerCase());
                                              },
                                            );
                                          })
                                        : List.generate(
                                            controller.plansByDays.length,
                                            (index) {
                                            final duration = controller
                                                .plansByDays.keys
                                                .toList()[index];
                                            return PlanTab(
                                              duration: duration,
                                              isSelected:
                                                  controller.selectedDuration ==
                                                      duration,
                                              onTap: () {
                                                controller.onDurationChanged(
                                                    duration);
                                              },
                                            );
                                          }),
                                  ),
                                ),
                                GridView.count(
                                  // controller: ,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                      controller.selectedDuration == 'All'
                                          ? controller.allPlans.length
                                          : controller.durationPlans.length,
                                      (index) {
                                    final plan =
                                        controller.selectedDuration == 'All'
                                            ? controller.allPlans[index]
                                            : controller.durationPlans[index];
                                    print('..the plan is $plan');
                                    return PlanBox(
                                      plan: plan,
                                      onTap: () {
                                        if (controller.phoneNumberController
                                            .text.isEmpty) {
                                          showCustomToast(
                                              context: context,
                                              description:
                                                  'Please enter a phone number');
                                          return;
                                        }
                                        controller.onPlanSelected(plan);
                                        final generalController =
                                            context.read<GeneralController>();
                                        num serviceCharge = generalController
                                                .serviceCharge?.data ??
                                            0;
                                        num totalAmount = calculateTotalAmount(
                                            amount: plan.amount.toString(),
                                            charge: serviceCharge);
                                        final summaryItems = [
                                          SummaryItem(
                                              title: 'Network',
                                              name: controller
                                                      .selectedProvider?.name ??
                                                  ""),
                                          SummaryItem(
                                            title: 'Phone number',
                                            name: controller
                                                .phoneNumberController.text
                                                .trim(),
                                            hasDivider: true,
                                          ),
                                          if (serviceCharge != 0)
                                            SummaryItem(
                                              title: 'Service Charge',
                                              name:
                                                  formatCurrency(serviceCharge),
                                            ),
                                          SummaryItem(
                                              title: 'Amount',
                                              name:
                                                  formatCurrency(totalAmount)),
                                        ];
                                        final reviewDetails = ReviewModel(
                                            summaryItems: summaryItems,
                                            amount: plan.amount.toString(),
                                            providerName: controller
                                                .selectedProvider?.name,
                                            logo: controller
                                                .selectedProvider?.logo,
                                            shortInfo:
                                                '${controller.selectedProvider?.name ?? ""} Data',
                                            onPinCompleted: (pin) async {
                                              displayLoader(context);
                                              controller.buyData(
                                                pin,
                                                onSuccess: (transactionInfo) {
                                                  popScreen();
                                                  final items = getSummaryItems(
                                                      transactionInfo,
                                                      TransactionType.data);
                                                  final review = ReceiptModel(
                                                      summaryItems: items,
                                                      amount: transactionInfo
                                                          .amount
                                                          .toString(),
                                                      shortInfo:
                                                          '${transactionInfo.meta.provider?.name ?? ""} Airtime');
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          RoutesManager
                                                              .successful,
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false,
                                                          arguments: review);
                                                },
                                                onError: (error) {
                                                  popScreen();
                                                  showCustomErrorTransaction(
                                                      context: context,
                                                      errMsg: error);
                                                },
                                              );
                                            });
                                        showReviewBottomShhet(context,
                                            reviewDetails: reviewDetails);
                                      },
                                    );
                                  }),
                                )
                              ],
                            )
                          : controller.allPlans.isEmpty? Center(child: Text('')): SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}

class PlanBox extends StatelessWidget {
  const PlanBox({super.key, required this.plan, required this.onTap});
  final DataPlan plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: ColorManager.kGreyColor.withValues(alpha: .07))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              plan.bundle,
              style: get16TextStyle(),
            ),
            Gap(2),
            Text(
              '${plan.duration} days',
              style: get12TextStyle().copyWith(
                  color: ColorManager.kGreyColor.withValues(alpha: .7)),
            ),
            Gap(10),
            Text(
              formatCurrency(plan.amount, decimal: 0),
              style: get16TextStyle().copyWith(color: ColorManager.kPrimary),
            )
          ],
        ),
      ),
    );
  }
}

class PlanBoxShimmer extends StatelessWidget {
  const PlanBoxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withOpacity(.07)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _line(width: 60.w, height: 14.h),
            Gap(6),
            _line(width: 40.w, height: 10.h),
            Gap(12),
            _line(width: 70.w, height: 14.h),
          ],
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}

class PlanTab extends StatelessWidget {
  const PlanTab(
      {super.key,
      this.duration,
      required this.onTap,
      this.planType,
      this.isSelected = false});
  final String? duration;
  final bool isSelected;
  final VoidCallback onTap;
  final String? planType;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.kPrimary.withValues(alpha: .08)
                : ColorManager.kWhite,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: isSelected
                    ? ColorManager.kPrimary
                    : ColorManager.kGreyColor.withValues(alpha: .08))),
        child: Text(
          planType != null
              ? planType!
              : duration == 'All'
                  ? duration!
                  : getPlanNameByDuration(int.parse(duration!)),
          style: get14TextStyle().copyWith(
              color: isSelected
                  ? ColorManager.kPrimary
                  : ColorManager.kGreyColor.withValues(alpha: .7)),
        ),
      ),
    );
  }
}

String getPlanNameByDuration(int duration) {
  switch (duration) {
    case 1:
      return "Daily";
    case 7:
      return "Weekly";
    case 30:
      return "Monthly";
    case 60:
      return "2-Month";
    case 90:
      return "3-Month";
    default:
      return '$duration Days';
  }
}
