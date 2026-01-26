import 'dart:typed_data';

import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/receipt_generator.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/dashed_divider.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewDetails =
        ModalRoute.of(context)?.settings.arguments as ReceiptModel;
    return Scaffold(
      appBar: CustomAppbar(title: 'Receipt'),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
         
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: ColorManager.kPrimary.withValues(alpha: .08),
                      child: svgImage(imgPath: 'assets/icons/receipt.svg'),
                    ),
                  ),
                  Gap(16.h),
                  Center(
                    child: Text(
                      'Transaction Receipt',
                      style: get20TextStyle().copyWith(color: ColorManager.kGreyColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Gap(5.h),
                  Center(
                    child: Text(
                      '₦${reviewDetails.amount}',
                      style: get32TextStyle()
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                   Text(
                    reviewDetails.shortInfo,
                    style:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500),
                  ),
                  
                  
                  Gap(20.h),
                  Text(
                    'Summary',
                    style:
                        get16TextStyle().copyWith(fontWeight: FontWeight.w500),
                  ),
                  DashedDivider(),
                  Column(
                    spacing: 12,
                    children: reviewDetails.summaryItems,
                  )
                ],
              ),
            ),
            Gap(24.h),
            CustomButton(
                text: 'Download Receipt',
                isActive: true,
                onTap: () {},
                loading: false),
            Gap(12.h),
            CustomButton(
              text: 'Share Receipt',
              isActive: true,
              onTap: () {
                generateReceiptPdfFromModel(reviewDetails).then((Uint8List pdfBytes) {
                          
                          sharePdf(pdfBytes, '94949494949');
                        });
              },
              loading: false,
              backgroundColor: ColorManager.kWhite,
              textStyle: get16TextStyle().copyWith(
                  color: ColorManager.kGreyColor.withValues(alpha: .7),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      )),
    );
  }
}
