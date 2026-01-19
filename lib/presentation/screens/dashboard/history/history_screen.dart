import 'package:dataplug/core/model/bar%20graph/bar_data.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/model/core/service_txn.dart';
import 'package:dataplug/core/providers/history_controller.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
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
                      ? SpendingAnalysis()
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
  SpendingAnalysis({super.key});
  final List<double> weeklySummary = [40.4, 2.5, 42.3, 10, 100.50, 40, 10.7];
  @override
  Widget build(BuildContext context) {
    Map<int, double> weeklyTotals = {
      1: 0, // Mon
      2: 0, // Tue
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0, // Sun
    };

    BarData barData = BarData(
        sunAmount: weeklySummary[0],
        monAmount: weeklySummary[1],
        tueAmount: weeklySummary[2],
        wedAmount: weeklySummary[3],
        thurAmount: weeklySummary[4],
        friAmount: weeklySummary[5],
        satAmount: weeklySummary[6]);
    barData.initializeBarData();
// for (final tx in transactions) {
//   weeklyTotals[tx.date.weekday] =
//       (weeklyTotals[tx.date.weekday] ?? 0) + tx.amount;
// }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(16.sp)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spending Analysis',
                      style: get18TextStyle(),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        MonthlyWeeklySelector(
                          text: 'Weekly',
                          isSelected: true,
                        ),
                        MonthlyWeeklySelector(text: 'Monthly')
                      ],
                    )
                  ],
                ),
                Gap(24.h),
                Text(
                  'Total Spending',
                  style: get14TextStyle().copyWith(
                      color: ColorManager.kGreyColor.withValues(alpha: .7)),
                ),
                Gap(16.h),
                Text(
                  '₦67,545.23',
                  style: get28TextStyle(),
                ),
                Gap(24.h),
                SizedBox(
                  height: 200.h,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
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
                            getTitlesWidget: (value, meta) {
                              return Text('₦${value.toInt()}');
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              return Text(
                                days[value.toInt() - 1],
                                style: get12TextStyle().copyWith(
                                    color: ColorManager.kGreyColor
                                        .withValues(alpha: .7)),
                              );
                            },
                          ),
                        ),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: barData.barData.map((data) {
                        final isToday = DateTime.now().weekday == data.x;
                        return BarChartGroupData(x: data.x, barRods: [
                          BarChartRodData(
                              toY: data.y,
                              color: isToday
                                  ? ColorManager.kPrimary
                                  : ColorManager.kGreyEB,
                              width: 32.w,
                              borderRadius: BorderRadius.circular(5.r)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
                Gap(32.h),
                Column(
                  spacing: 24.h,
                  children: [
                    PercentageAnalysisWidget(
                        name: 'Buy Data', percent: '40', amount: '20,000'),
                    PercentageAnalysisWidget(
                        name: 'Buy Airtime', percent: '20', amount: '10,000'),
                    PercentageAnalysisWidget(
                        name: 'Transfer', percent: '8', amount: '2,000'),
                         PercentageAnalysisWidget(
                        name: 'Others', percent: '2', amount: '500'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
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
        pushNamed(RoutesManager.successful, arguments: details);
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
              decoration: BoxDecoration(
                  color: ColorManager.kPrimary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12.r)),
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

class MonthlyWeeklySelector extends StatelessWidget {
  const MonthlyWeeklySelector(
      {super.key, required this.text, this.isSelected = false});
  final String text;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
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
