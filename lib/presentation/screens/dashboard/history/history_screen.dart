import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/model/bar%20graph/bar_data.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/model/core/spending_analysis_response.dart';
import 'package:dataplug/core/providers/history_controller.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/loading.dart';
import 'package:dataplug/presentation/misc/custom_components/toggle_selector_widget.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryController>().getServiceTxnsHistory();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> cableTvTypes = ['History', 'Spending Analysis'];
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Transaction History',
        canPop: false,
        suffix: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return FilterBottomSheet();
                });
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: ColorManager.kWhite,
            child: Icon(
              Icons.tune,
              size: 25,
              color: ColorManager.kGreyColor,
            ),
          ),
        ),
      ),
      body: Consumer<HistoryController>(builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Column(
            children: [
              ToggleSelectorWidget(
                tabIndex: controller.currentTabIndex,
                tabText: cableTvTypes,
                onTap: (index) {
                  controller.onChangedTab(index);
                },
              ),
              Expanded(
                  child: controller.currentTabIndex == 1
                      ? controller.gettingAnalysis? Center(child: CircularProgressIndicator()) : controller.analysisError!=null?Text(controller.analysisError!): SpendingAnalysis(
                        spendingAnalysisData: controller.selectedPeriodIndex==0? controller.weeklyAnalysis! : controller.monthlyAnalysis!,
                      )
                      : controller.gettingHistory
                          ? buildLoading(wrapWithExpanded: false)
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 20.h),
                              itemBuilder: (context, index) {
                                final transInfo =
                                    controller.transactionsHistory[index];
                                return HistoryTile(transInfo: transInfo);
                              },
                              separatorBuilder: (context, index) => Gap(12),
                              itemCount: controller.transactionsHistory.length))
            ],
          ),
        );
      }),
    );
  }
}



class SpendingAnalysis extends StatelessWidget {
  const SpendingAnalysis({super.key, required this.spendingAnalysisData});

  final SpendingAnalysisData spendingAnalysisData;

  @override
  Widget build(BuildContext context) {
    final charts = spendingAnalysisData.chart;
    final isWeekly = spendingAnalysisData.period == "weekly";
    print('...period is ${spendingAnalysisData.period} ${charts[0].label}');

    final maxY = charts
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    final barGroups = charts.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final isToday = isWeekly &&
          DateTime.parse(item.date).weekday == DateTime.now().weekday;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.amount.toDouble(),
            color: isToday ? ColorManager.kPrimary : ColorManager.kGreyEB,
            width: 32.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      );
    }).toList();

    return Consumer<HistoryController>(
      builder: (context, controller, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: ColorManager.kWhite,
                  borderRadius: BorderRadius.circular(16.sp),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Spending Analysis', style: get18TextStyle()),
                        Row(
                          spacing: 10.w,
                          children:  [
                            MonthlyWeeklySelector(text: 'Weekly', isSelected: controller.selectedPeriodIndex==0, onTap: () {
                              controller.onPeriodTabChanged(0);
                            },),
                            MonthlyWeeklySelector(text: 'Monthly', isSelected:  controller.selectedPeriodIndex==1,onTap: () {
                              controller.onPeriodTabChanged(1);
                            },),
                          ],
                        ),
                      ],
                    ),
                    Gap(24.h),
                    Text(
                      'Total Spending',
                      style: get14TextStyle()
                          .copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7)),
                    ),
                    Gap(16.h),
                    Text(
                      '₦${spendingAnalysisData.summary.totalSpent}',
                      style: get28TextStyle(),
                    ),
                    Gap(24.h),
                    SizedBox(
                      height: 200.h,
                      child: BarChart(
                        BarChartData(
                          maxY: maxY == 0 ? 100 : maxY,
                          minY: 0,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              strokeWidth: 0.8,
                              color: ColorManager.kGreyEB,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) =>
                                    Text('₦${value.toInt()}'),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= charts.length) {
                                    return const SizedBox();
                                  }
                                  return Text(
                                    charts[index].label, // Mon, Tue... or Feb 2025
                                    style: get12TextStyle().copyWith(
                                      color: ColorManager.kGreyColor.withValues(alpha: .7),
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          barGroups: barGroups,
                        ),
                      ),
                    ),
                    Gap(32.h),
                    Column(
                      children: spendingAnalysisData.serviceBreakdown.map((e) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: PercentageAnalysisWidget(
                            name: e.service,
                            percent: e.percentage.toStringAsFixed(0),
                            amount: e.amount.toString(),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class PercentageAnalysisWidget extends StatelessWidget {
  const PercentageAnalysisWidget(
      {super.key,
      required this.name,
      required this.percent,
      required this.amount});
  final String name;
  final String percent;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8.w,
          children: [
            CircleAvatar(
              radius: 5,
              backgroundColor: ColorManager.kGreyE2,
            ),
            RichText(
              text: TextSpan(
                  text: name,
                  style:
                      get16TextStyle().copyWith(color: ColorManager.kGreyColor),
                  children: [
                    TextSpan(
                        text: ' $percent%',
                        style: get16TextStyle().copyWith(
                            color: ColorManager.kGreyColor.withValues(
                              alpha: .7,
                            ),
                            fontWeight: FontWeight.w400))
                  ]),
            )
          ],
        ),
        Text(
          '₦$amount',
          style: get16TextStyle().copyWith(color: ColorManager.kGreyColor),
        )
      ],
    );
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.transInfo});
  final ServiceTxn transInfo;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final summaryItems =
            getSummaryItems(transInfo, TransactionType.airtime);
        final details = ReceiptModel(
            summaryItems: summaryItems,
            amount: transInfo.amount.toString(),
            shortInfo: "");
        pushNamed(RoutesManager.receipt, arguments: details);
      },
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48.h,
              width: 48.w,
              padding: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                  color: ColorManager.kPrimary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12.r)),
                child:   svgImage(imgPath: 'assets/icons/${getIcon(transInfo.purpose)}.svg', height: 24.h, width: 24.w)
            ),
            Gap(12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  '${capitalize(transInfo.purpose.name)} Purchase',
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  formatDateShortWithTime(
                          transInfo.createdAt ?? DateTime.now()) ??
                      "",
                  style: get12TextStyle().copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  '₦${formatNumber(transInfo.amount)}',
                  style: get14TextStyle().copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  capitalize(transInfo.status.name),
                  style: get12TextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: ColorManager.kSuccess),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String getIcon(ServicePurpose purpose){
  switch (purpose) {
    case ServicePurpose.airtime:
     return 'airtime-icon';
    case ServicePurpose.data:
     return 'data-icon';
    case ServicePurpose.electricity:
     return 'electricity-icon';
    case ServicePurpose.tvSubscription:
     return 'cable-icon';
    case ServicePurpose.internationalAirtime:
     return 'intl-airtime-icon';
    case ServicePurpose.internationalData:
     return 'intl-data-icon';
    case ServicePurpose.education:
     return 'epin-icon';
    case ServicePurpose.betting:
     return 'betting-icon';
     case ServicePurpose.withdrawal:
     return 'withdraw-green';  
     case ServicePurpose.transfer:
     return 'transfer-green';  
     case ServicePurpose.deposit:
     return 'topup-green';          
    default:
    return 'airtime-icon'; 
  }
}

class MonthlyWeeklySelector extends StatelessWidget {
  const MonthlyWeeklySelector(
      {super.key, required this.text, this.isSelected = false, required this.onTap});
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isSelected ? ColorManager.kPrimary : ColorManager.kGreyF5),
          child: Text(
            text,
            style: get14TextStyle().copyWith(
                color: isSelected
                    ? ColorManager.kWhite
                    : ColorManager.kGreyColor.withValues(alpha: .4),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryController>(builder: (context, controller, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
            color: ColorManager.kWhite,
            borderRadius: BorderRadius.circular(24.r)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: get18TextStyle(),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorManager.kGreyF8,
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              ),
              Gap(24.h),
              Text(
                'Category',
                style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
              ),
              Gap(12.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: List.generate(controller.categoryFilterList.length,
                    (index) {
                  final filter = controller.categoryFilterList[index];
                  return InkWell(
                    onTap: () {
                      controller.onFilterChanged(index);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          color: controller.selectedCategoryIndex == index
                              ? ColorManager.kPrimary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100.sp),
                          border: Border.all(
                              color: ColorManager.kGreyColor
                                  .withValues(alpha: .08))),
                      child: Text(
                        filter,
                        style: get14TextStyle().copyWith(
                            color: controller.selectedCategoryIndex == index
                                ? ColorManager.kWhite
                                : ColorManager.kGreyColor.withValues(alpha: .7)),
                      ),
                    ),
                  );
                }),
              ),
              Gap(24.h),
              Text(
                'Status',
                style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),
              ),
              Gap(12.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children:
                    List.generate(controller.statusFilterList.length, (index) {
                  final filter = controller.statusFilterList[index];
                  return InkWell(
                    onTap: () {
                      controller.onFilterChanged(index, isStatus: true);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.sp),
                          color: controller.selectedStatusIndex == index
                              ? ColorManager.kPrimary
                              : Colors.transparent,
                          border: Border.all(
                              color: ColorManager.kGreyColor
                                  .withValues(alpha: .08))),
                      child: Text(
                        filter,
                        style: get14TextStyle().copyWith(
                            color: controller.selectedStatusIndex == index
                                ? ColorManager.kWhite
                                : ColorManager.kGreyColor.withValues(alpha: .7)),
                      ),
                    ),
                  );
                }),
              ),
              Gap(32.h),
              Row(
                spacing: 10.w,
                children: [
                  Expanded(
                      child: CustomButton(
                          text: 'Clear Filter',
                          isActive: true,
                          onTap: () {},
                          loading: false,
                          backgroundColor: ColorManager.kWhite,
                          border: Border.all(
                            color: ColorManager.kGreyColor.withValues(alpha:  .12)
                          ),
                          textColor: ColorManager.kGreyColor.withValues(alpha: .7),
                          ),
                          ),
                  Expanded(
                      child: CustomButton(
                          text: 'Apply Filter',
                          isActive: true,
                          onTap: () {
                            controller.getServiceTxnsHistory();
                            popScreen();
                          },
                          loading: false)),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
