import 'package:cached_network_image/cached_network_image.dart';
import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/dashed_divider.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SummaryContainer extends StatelessWidget {
  const SummaryContainer(
      {super.key, required this.summaryItem});

  
  final List<SummaryItem> summaryItem;

  @override
  Widget build(BuildContext context) {
    final walletController = context.watch<WalletController>();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.kPrimary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance:',
                  style:
                      get14TextStyle().copyWith(color: ColorManager.kDeepGreen),
                ),
                Text(
                  '${formatCurrency(num.parse(walletController.balance), showSymbol: false)} NGN',
                  style: get14TextStyle().copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorManager.kDeepGreen),
                )
              ],
            ),
          ),
          Gap(16),
          Text(
            'Summary',
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          DashedDivider(),
          Column(
            spacing: 12,
            children: summaryItem,
          )
        ],
      ),
    );
  }
}

class ReviewHeaderContainer extends StatelessWidget {
  const ReviewHeaderContainer({super.key, required this.providerType, required this.providerName,required this.logo, required this.onChange});
  final VoidCallback? onChange;
  final String providerType, providerName, logo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: ColorManager.kWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$providerType Provider',
            style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomNetworkImage(imageUrl: logo),
                  Gap(12),
                      Text(providerName, style: get16TextStyle().copyWith(fontWeight: FontWeight.w400),)
                ],
              ),
                InkWell(
                  onTap: onChange,
                  child: Text('Change', style: get14TextStyle().copyWith(fontWeight: FontWeight.w600, color: ColorManager.kPrimary),))
            ],
          )
        ],
      ),
    );
  }
}