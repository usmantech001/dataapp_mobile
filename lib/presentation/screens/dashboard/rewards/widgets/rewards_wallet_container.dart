import 'package:dataplug/core/providers/rewards_controller.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class RewardsWalletContainer extends StatelessWidget {
  const RewardsWalletContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RewardsController>(
      builder: (context, controller, child) {
        return Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 12.h),
                  decoration: BoxDecoration(
                    color: ColorManager.kWhite,
                    borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Earnings', style: get14TextStyle(),),
                      Gap(20.h),
                      Row(
                    spacing: 12.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     //controller.isBalanceVisible? 
                     RichText(
                          text: TextSpan(
                            text: formatCurrency(num.parse(controller.referralInfo?.totalEarnings?? '0')).split('.').first,
                             // text: formatCurrency(num.parse(controller.balance)).split('.').first,
                              style: get32TextStyle().copyWith(
                                  
                                  fontWeight: FontWeight.w600),
                              children: [
                            TextSpan(
                              text: '.${formatCurrency(num.parse(controller.referralInfo?.totalEarnings??'0')).split('.').last}',
                                //text: '.${formatCurrency(num.parse(controller.balance)).split('.').last}',
                                style: get32TextStyle().copyWith(
                                    color: ColorManager.kGreyColor.withValues(alpha: .4),
                                    fontWeight: FontWeight.w600))
                          ])),
                          // : Text('********', style: get28TextStyle().copyWith(
                          //         color: ColorManager.kWhite,
                          //         fontWeight: FontWeight.w600),),
                      GestureDetector(
                        onTap: () {
                         // controller.toggleBalanceVisibility();
                        },
                        child: Icon(
                          Icons.visibility,
                        // controller.isBalanceVisible? Icons.visibility : Icons.visibility_off,
                         
                        ),
                      )
                    ],
                  ),
                  Gap(20.h),
                  CustomButton(text: 'Claim Reward', isActive: true, onTap: (){}, loading: false)
                    ],
                  ),
                );
      }
    );
  }
}