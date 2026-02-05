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
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

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





Future<Uint8List> generateFancyReceiptPdf() async {
  const opayGreen = PdfColor.fromInt(0xFF00B875);
const bgGray = PdfColor.fromInt(0xFFF5F6FA);
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (context) {
        return pw.Container(
          color: bgGray,
          padding: const pw.EdgeInsets.all(24),
          child: pw.Center(
            child: pw.Container(
              width: 350,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  // Logo / Title
                  pw.Text(
                    "YourApp",
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      //color: opayGreen,
                    ),
                  ),

                  pw.SizedBox(height: 16),

                  // Status Badge
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: opayGreen,
                      borderRadius: pw.BorderRadius.circular(20),
                    ),
                    child: pw.Text(
                      "SUCCESS",
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 14),

                  // Amount
                  pw.Text(
                    "₦25,000.00",
                    style: pw.TextStyle(
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                      color: opayGreen
                    ),
                  ),

                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Transaction Successful",
                    style: const pw.TextStyle(fontSize: 12),
                  ),

                  pw.SizedBox(height: 20),
                  pw.Divider(),

                  _row("From", "John Doe"),
                  _row("To", "Jane Smith"),
                  _row("Date", "30 Jan 2026"),
                  _row("Time", "09:32 AM"),
                  _row("Reference", "OPAY-92HD83"),

                  pw.SizedBox(height: 20),
                  pw.Divider(),

                  pw.Text(
                    "Thank you for using YourApp",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _row(String title, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ),
        pw.Text(
          value,
          style:  pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
