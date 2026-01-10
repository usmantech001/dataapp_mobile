import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WalletContainer extends StatelessWidget {
  const WalletContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.only(top: 24.h, bottom: 12.h),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
              color: ColorManager.kPrimary,
              borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WALLET BALANCE',
                style: get14TextStyle().copyWith(color: ColorManager.kWhite),
              ),
              Row(
                spacing: 12.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 controller.isBalanceVisible? RichText(
                      text: TextSpan(
                          text: formatCurrency(num.parse(controller.balance)).split('.').first,
                          style: get32TextStyle().copyWith(
                              color: ColorManager.kWhite,
                              fontWeight: FontWeight.w600),
                          children: [
                        TextSpan(
                            text: '.${formatCurrency(num.parse(controller.balance)).split('.').last}',
                            style: get32TextStyle().copyWith(
                                color: ColorManager.kWhite.withValues(alpha: .6),
                                fontWeight: FontWeight.w600))
                      ])): Text('********', style: get28TextStyle().copyWith(
                              color: ColorManager.kWhite,
                              fontWeight: FontWeight.w600),),
                  GestureDetector(
                    onTap: () {
                      controller.toggleBalanceVisibility();
                    },
                    child: Icon(
                     controller.isBalanceVisible? Icons.visibility : Icons.visibility_off,
                      color: ColorManager.kWhite,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}
