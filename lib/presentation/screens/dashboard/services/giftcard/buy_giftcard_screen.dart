import 'package:dataplug/core/model/core/custom_network_image.dart';
import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/giftcard_controller.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BuyGiftcardScreen extends StatelessWidget {
  const BuyGiftcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final giftCardController = context.watch<GiftcardController>();
    return Scaffold(
      appBar: CustomAppbar(title: 'Buy GiftCard'),
      bottomNavigationBar:  CustomBottomNavBotton(
          text: 'Continue',
          onTap: () {
            
            // if (controller.meterNoErrMsg != null 
            // //|| controller.meterNumberController.text.isEmpty
            // ) {
            //   showCustomToast(
            //     context: context,
            //     // meesage
            //     description:
            //         "Merchant not verified. Please check the meter number and try again.",
            //   );
            // }

            // if (controller.amountController.text.isEmpty ||
            //     num.parse(formatUseableAmount(controller.amountController.text)) <= 0) {
            //   showCustomToast(
            //     context: context,
            //     // meesage
            //     description:
            //         "Merchant not verified. Please check the meter number and try again.",
            //   );
            //   return;
            // }

             final summaryItems = [
              SummaryItem(title: 'GiftCard', name: giftCardController.selectedProduct?.name ?? ""),
              SummaryItem(
                title: 'Type',
                name: giftCardController.giftCardTypes[giftCardController.currentTypeTabIndex],
                hasDivider: true,
              ),
              SummaryItem(
                  title: 'Unit', name: '${giftCardController.giftcardQuantity}'),
            ];
            final reviewModel = ReviewModel(
                summaryItems: summaryItems,
                amount: formatUseableAmount('2000'),
                shortInfo: giftCardController.selectedProduct?.name??"",
                logo: giftCardController.selectedProduct?.logo,
                onChangeProvider: () => Navigator.pushNamed(context, RoutesManager.electricityProviders,),
                onPinCompleted: (pin) async {
                  giftCardController.buyGiftCard(pin, onError: (error) {
                    showDialog(
                      context: context, 
                      builder: (context){
                      return Dialog(
                        backgroundColor: ColorManager.kError,
                        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                         // height: 200,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                          decoration: BoxDecoration(
                            color: ColorManager.kWhite,
                            borderRadius: BorderRadius.circular(24.r)
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(backgroundColor: ColorManager.kErrorEB.withValues(alpha: .08),radius: 43.r, child: CircleAvatar(backgroundColor: ColorManager.kErrorEB,radius: 30.r, child: Icon(Icons.close),),),
                              Gap(24.h),
                              Text('Purchase Failed', style: get20TextStyle(),),
                              Gap(12.h),
                              Text(error.toString(),textAlign: TextAlign.center, style: get14TextStyle().copyWith(
                                
                              ),),
                              Gap(24.h),
                              CustomButton(text: 'Okay',width: 90,borderRadius: BorderRadius.circular(12.r), isActive: true, onTap: (){
                                Navigator.pop(context);
                              }, loading: false)
                            ],
                          ),
                        ),
                      );
                    });
                  } ,);
                 
                });
            showReviewBottomShhet(context, reviewDetails: reviewModel);


          }),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomNetworkImage(
                          imageUrl:
                              giftCardController.selectedProduct?.logo ?? ""),
                      Gap(12),
                      SizedBox(
                        width: 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             giftCardController.selectedProduct?.name??"",
                              style: get14TextStyle()
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Gap(4.h),
                            Text(
                              "( \$${giftCardController.selectedProduct?.minAmount} to \$99.99 ) US USD",
                              style: get14TextStyle()
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        'Change',
                        style: get14TextStyle().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorManager.kPrimary),
                      ))
                ],
              ),
            ),
            CustomInputField(
              suffixIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorManager.kGreyF8,
                  borderRadius: BorderRadius.circular(46.r)
                ),
                child: Row(
                  spacing: 12.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        giftCardController.quantityIncrementDecrement(false);
                      },
                      child: Icon(Icons.remove)),
                    Text(giftCardController.giftcardQuantity< 10 ? "0${giftCardController.giftcardQuantity}" : giftCardController.giftcardQuantity.toString()),
                    GestureDetector(
                      onTap: () {
                        giftCardController.quantityIncrementDecrement(true);
                      },
                      child: Icon(Icons.add))
                  ],
                ),
              ),
            ),
            Gap(12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: ColorManager.kPrimary.withValues(alpha: .08),
                border: Border.all(color: ColorManager.kPrimary),
                borderRadius: BorderRadius.circular(14.r)
              ),
              child: Text('₦ 7,514,40', style: get20TextStyle().copyWith(fontWeight: FontWeight.w500),),
            )
          ],
        ),
      ),
    );
  }
}
