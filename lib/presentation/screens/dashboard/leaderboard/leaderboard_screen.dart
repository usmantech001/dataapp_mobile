import 'package:dataplug/core/model/core/leaderboard.dart';
import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/loading.dart';
import 'package:dataplug/presentation/misc/custom_components/toggle_selector_widget.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<RewardsController>().getLeaderboard();
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<String> tabText = ['Top Referrals', 'Top Earnings'];
    return Scaffold(
      appBar: CustomAppbar(title: 'Leaderboard'),
      body: Consumer<RewardsController>(
        builder: (context, controller, child) {
          return Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(color: ColorManager.kWhite),
            child: Column(
              children: [
                Row(
                  spacing: 12.w,
                  children: [
                    Container(
                      height: 44.h,
                      width: 44.w,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.sp),
                          color: ColorManager.kGreyF8),
                      child: svgImage(
                        imgPath: 'assets/icons/leaderboard.svg',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leaderboard',
                          style: get16TextStyle(),
                        ),
                        Text(
                          'This month\'s top performers',
                          style: get14TextStyle().copyWith(
                              color: ColorManager.kGreyColor.withValues(alpha: .7)),
                        )
                      ],
                    )
                  ],
                ),
                Gap(20.h),
                ToggleSelectorWidget(
                  tabIndex: controller.leaderboardCurrentIndex,
                  tabText: tabText,
                  hasMargin: false,
                  bgColor: ColorManager.kGreyF5,
                  selectedColor: ColorManager.kWhite,
                  selectedTexColor: ColorManager.kGreyColor,
                  onTap: (index) {
                     controller.onTabChange(index);
                  },
                ),
                Gap(12.h),
                Expanded(
                  child: controller.gettingLeaderBoards? buildLoading(wrapWithExpanded: false): controller.leaderboardCurrentIndex== 0? ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = controller.leaderBoardItems[index];
                        return LeaderboardTile(
                          item: item,
                          index: index,
                          bgColor: ColorManager.kLightYellow.withValues(alpha: .2),
                          borderColor: ColorManager.kYellow,
                          iconBgColor: ColorManager.kYellowLight,
                          nuberColor: ColorManager.kDeepOrange,
                        );
                      },
                      separatorBuilder: (context, index) => Gap(10),
                      itemCount: controller.leaderBoardItems.length) :ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = controller.leaderBoardItems[index];
                        return LeaderboardTile(
                          index: index,
                          item: item,
                          isReferrals: false,
                          bgColor: ColorManager.kLightGreen,
                          borderColor: ColorManager.kGreen,
                          iconBgColor: ColorManager.kLightGreenD0,
                          nuberColor: ColorManager.kDeepgreen,
                          textColor: ColorManager.kGreen,
                        );
                      },
                      separatorBuilder: (context, index) => Gap(10),
                      itemCount: controller.leaderBoardItems.length),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile(
      {super.key,
      required this.item,
      required this.index,
      required this.bgColor,
      required this.borderColor,
      required this.iconBgColor,
      required this.nuberColor,
      this.textColor,
      this.isReferrals = true
      });
  final int index;
  final Color bgColor;
  final Color borderColor;
  final Color iconBgColor;
  final Color nuberColor;
  final Color? textColor;
  final LeaderboardItem item;
  final bool isReferrals;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: index < 3 ? bgColor : ColorManager.kGreyF8,
          border: Border.all(
            color: index < 3 ? borderColor : ColorManager.kGreyF8,
          )),
      child: Row(
        children: [
          Container(
            height: 44.h,
            width: 44.w,
            padding: EdgeInsets.all(10.sp),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                color: index < 3 ? iconBgColor : ColorManager.kGreyE2),
            child: Text(
              index == 0
                  ? '🏆'
                  : index == 1
                      ? '🥈'
                      : index == 2
                          ? '🥉'
                          : '👤',
              style: get22TextStyle(),
            ),
          ),
          Gap(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.email,
                style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
              ),
             if(isReferrals) Text(
               isReferrals? '${item.value} referrals' : formatCurrency(item.value),
                style: get14TextStyle().copyWith(
                    color: textColor?? ColorManager.kGreyColor.withValues(alpha: .7)),
              )
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
            decoration: BoxDecoration(
                color: index < 3 ? iconBgColor : ColorManager.kGreyE2,
                borderRadius: BorderRadius.circular(200)),
            child: Text(
              '#${index+1}',
              style: get16TextStyle().copyWith(
                fontWeight: FontWeight.w400,
                color: index < 3
                    ? nuberColor
                    : ColorManager.kGreyColor.withValues(alpha: .7),
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
