import 'package:dataplug/core/enum.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_container.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/providers/user_provider.dart';

class Earnings extends StatelessWidget {
  const Earnings({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("TOTAL EARNINGS", style: get12TextStyle()),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: get26TextStyle(),
                children: [
                  TextSpan(
                    text: userProvider.balanceVisible
                        ? formatNumber(userProvider.totalReferralsEarnings)
                        : "*****",
                  ),
                  const TextSpan(text: " NGN", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => userProvider.toggleBalanceVisibility(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, bottom: 4, top: 4, right: 5),
                child: Icon(
                    userProvider.balanceVisible
                        ? LucideIcons.eyeOff
                        : LucideIcons.eye,
                    size: 16,
                    color: ColorManager.kTextDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: CustomContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                leftSider: const SizedBox(height: 57),
                child: builtItem("Total Referrals",
                    count: "${userProvider.totalReferrals}", onTap: () {
                  Navigator.pushNamed(context, RoutesManager.earningList,
                      arguments: ReferralStatus.all);
                }),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CustomContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                leftSider: const SizedBox(height: 57),
                rightSider: const SizedBox(height: 57),
                child: builtItem("Active Referrals",
                    count: "${userProvider.activeReferrals}", onTap: () {
                  Navigator.pushNamed(context, RoutesManager.earningList,
                      arguments: ReferralStatus.active);
                }),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CustomContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                rightSider: const SizedBox(height: 57),
                child: builtItem("Inactive Referrals",
                    count: "${userProvider.inactiveReferrals}", onTap: () {
                  Navigator.pushNamed(context, RoutesManager.earningList,
                      arguments: ReferralStatus.inactive);
                }),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget builtItem(String title,
      {required String count, required Function onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: get14TextStyle()),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 18),
          child: Text(
            count,
            style: get22TextStyle().copyWith(
              color: ColorManager.kPrimary,
            ),
          ),
        ),
        CustomButton(
          height: 25,
          text: "View list",
          border: Border.all(width: .15, color: ColorManager.k267E9B),
          backgroundColor: ColorManager.kPrimaryLight,
          textStyle: get12TextStyle().copyWith(color: ColorManager.kPrimary),
          isActive: true,
          onTap: () => onTap(),
          loading: false,
        )
      ],
    );
  }
}
