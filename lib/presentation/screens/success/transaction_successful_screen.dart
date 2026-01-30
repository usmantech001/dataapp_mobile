import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/utils/animated_success_icon.dart';
import 'package:dataplug/core/utils/custom_image.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/dashed_divider.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class TransactionSuccessfulScreen extends StatelessWidget {
  const TransactionSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewDetails =
        ModalRoute.of(context)?.settings.arguments as ReceiptModel;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: AnimatedSuccessIcon()),
            Gap(20.h),
            Text(
              'Successful',
              style: get24TextStyle(),
            ),
            Gap(12.h),
            Text(
              'Your payment was successful. Thank you for your purchase!',
              textAlign: TextAlign.center,
              style: get16TextStyle().copyWith(
                  color: ColorManager.kGreyColor.withValues(
                    alpha: .7,
                  ),
                  fontWeight: FontWeight.w400),
            ),
            Gap(16.h),
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
                    child: Text(
                      '₦${reviewDetails.amount}',
                      style:
                          get32TextStyle().copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Gap(4),
                  Center(
                    child: Text(
                      reviewDetails.shortInfo,
                      style: get16TextStyle().copyWith(
                          color: ColorManager.kGreyColor.withValues(alpha: .7),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Gap(24.h),
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
          text: 'Generate Receipt', isActive: true, onTap: (){
            pushNamed(RoutesManager.receipt, arguments: reviewDetails);
          }, loading: false),
          Gap(12.h),
            CustomButton(
          text: 'Back Home', isActive: true, onTap: (){
            removeAllAndPushScreen(RoutesManager.bottomNav);
          }, loading: false, backgroundColor: ColorManager.kWhite, textStyle: get16TextStyle().copyWith(color: ColorManager.kGreyColor.withValues(alpha: .7), fontWeight: FontWeight.w400),),
          ],
        ),
      )),
    );
  }
}





class SuccessIconAnimation extends StatefulWidget {
  const SuccessIconAnimation({super.key});

  @override
  State<SuccessIconAnimation> createState() => _SuccessIconAnimationState();
}

class _SuccessIconAnimationState extends State<SuccessIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // 🔁 continuous loop

    _scale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fade = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SvgPicture.asset(
          'assets/icons/success.svg',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
