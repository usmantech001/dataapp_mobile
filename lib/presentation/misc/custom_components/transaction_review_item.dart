import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/keypad_provider.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/utils.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/airtime_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TransactionReviewBottomSheetItem extends StatelessWidget {
  const TransactionReviewBottomSheetItem(
      {super.key, required this.reviewDetails});
  final ReviewModel reviewDetails;

  @override
  Widget build(BuildContext context) {
    final walletController = context.read<WalletController>();
    return Container(
      // height: 500,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Review Transaction',
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
           if(reviewDetails.providerName!=null) Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 12.h, ),
              decoration: BoxDecoration(
                  color: ColorManager.kGreyF8,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15.r,
                    backgroundColor: ColorManager.kWhite,
                    child: CustomNetworkImage(imageUrl: reviewDetails.logo??""),
                  ),
                  Gap(8),
                  Text(
                    reviewDetails.providerName ?? "",
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                    color: ColorManager.kGreyF8,
                    borderRadius: BorderRadius.circular(16.r)),
                child: Column(
                  spacing: 16.h,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                          color: ColorManager.kPrimary.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Balance:',
                            style: get14TextStyle()
                                .copyWith(color: ColorManager.kPrimary),
                          ),
                          Text(
                            '${formatCurrency(num.parse(walletController.balance)).replaceAll('₦', '')} NGN',
                            style: get14TextStyle().copyWith(
                                color: ColorManager.kPrimary,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Column(
                      spacing: 16.h,
                      children: List.generate(reviewDetails.summaryItems.length,
                          (index) {
                        return reviewDetails.summaryItems[index];
                      }),
                    ),
                  ],
                )),
            Gap(24.h),
            CustomButton(
              isActive: true,
              loading: false,
              onTap: () {
                context.read<KeypadProvider>().setEnterPinEmpty();
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return CustomPinBottomSheet(reviewDetails: reviewDetails);
                    });
              },
              text: 'Proceed',
            )
          ],
        ),
      ),
    );
  }
}

// Widget customeBacArrow() {
//   return GestureDetector(
//     onTap: () => popScreen(),
//     child: const Icon(
//       Icons.arrow_back_sharp,
//       color: AppColors.kGrey66,
//     ),
//   );
// }
