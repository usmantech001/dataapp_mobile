import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/rewards/widgets/activity_container.dart';
import 'package:dataplug/presentation/screens/dashboard/rewards/widgets/leaderboard_container.dart';
import 'package:dataplug/presentation/screens/dashboard/rewards/widgets/refer_earn_container.dart';
import 'package:dataplug/presentation/screens/dashboard/rewards/widgets/rewards_wallet_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<RewardsController>().getReferralInfo();
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Rewards',
        canPop: Navigator.canPop(context),
      ),
      body: Consumer<RewardsController>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Column(
              spacing: 16.h,
              children: [
                RewardsWalletContainer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorManager.kWhite,
                    borderRadius: BorderRadius.circular(16.sp),
                  ),
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Activity',
                        style:
                            get14TextStyle().copyWith(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        spacing: 12.w,
                        children: [
                          Expanded(
                              child: ActivityContainer(
                                  iconPath: 'user-icon',
                                  totalNumber: '${controller.referralInfo?.totalReferrals??0}',
                                  text: 'Total Referrals',
                                  onTap: () => pushNamed(RoutesManager.referrals),
                                  )),
                          Expanded(
                              child: ActivityContainer(
                                  iconPath: 'active-referral',
                                  totalNumber: controller.referralInfo?.totalReferrals??'0',
                                  text: 'Active Referrals',
                                  onTap: () => pushNamed(RoutesManager.referrals),
                                  )),
                          Expanded(
                              child: ActivityContainer(
                                  iconPath: 'inactive-referral',
                                  totalNumber: controller.referralInfo?.totalReferrals??'0',
                                  text: 'Inactive Referrals',
                                  onTap: () => pushNamed(RoutesManager.referrals),
                                  )),
                        ],
                      ),
                    ],
                  ),
                ),
                LeaderboardContainer(),
                ReferEarnContainer(referralCode: controller.referralInfo?.refCode??"", totalReferrals: controller.referralInfo?.totalReferrals??"",)
              ],
            ),
          );
        }
      ),
    );
  }
}
