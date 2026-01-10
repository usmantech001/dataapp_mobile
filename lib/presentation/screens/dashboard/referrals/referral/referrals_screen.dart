import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({super.key});

  @override
  State<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<RewardsController>().getReferrals();
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Total Referrals'),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.25.w,
                color: ColorManager.kGreyColor.withValues(alpha: .04)
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 12.w,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: ColorManager.kGreyColor.withValues(alpha: .06),
                  ),
                  Column(
                    spacing: 6.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Agbeluyi Temiloluwa', style: get14TextStyle().copyWith(fontWeight: FontWeight.w500),),
                       Text('Joined May 11, 2026', style: get12TextStyle().copyWith(fontWeight: FontWeight.w400, color: ColorManager.kGreyColor.withValues(alpha: .4)),),
                    ],
                  )
                ],
              ),
              Text('Active', style: get14TextStyle().copyWith(fontWeight: FontWeight.w500, color: ColorManager.kSuccess),)
            ],
          ),
        );
      }),
    );
  }
}