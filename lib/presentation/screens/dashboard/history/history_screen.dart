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
    context.read<HistoryController>().getServiceTxnsHistory();
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
                  child: controller.currentTabIndex==1? SpendingAnalysis():  controller.gettingHistory
                      ? buildLoading()
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          itemBuilder: (context, index) {
                            final transInfo = controller.transactionsHistory[index];
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
  const SpendingAnalysis({super.key});
  

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

// for (final tx in transactions) {
//   weeklyTotals[tx.date.weekday] =
//       (weeklyTotals[tx.date.weekday] ?? 0) + tx.amount;
// }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorManager.kWhite,
      ),
      child: BarChart(
        BarChartData(
      maxY: 40000,
      //gridData: FlGridData(show: true),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text('₦${value ~/ 1000}k');
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return Text(days[value.toInt()]);
            },
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: List.generate(7, (index) {
        final isToday = DateTime.now().weekday - 1 == index;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: weeklyTotals[index + 1] ?? 0,
              width: 42,
              borderRadius: BorderRadius.circular(12),
              color: isToday ? Colors.teal : Colors.grey.shade300,
            ),
          ],
        );
      }),
        ),
      ),
    )
;
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.transInfo});
  final ServiceTxn transInfo;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final summaryItems = getSummaryItems(transInfo, TransactionType.airtime);
        final details = ReceiptModel(summaryItems: summaryItems, amount: transInfo.amount.toString(), shortInfo: "");
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
                  formatDateShortWithTime(transInfo.createdAt?? DateTime.now())??"",
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
                      fontWeight: FontWeight.w400, color: ColorManager.kSuccess),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
