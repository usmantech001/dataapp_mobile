import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/keypad_provider.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/biometric_card.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_keypad_input_box.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_container.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart'; 

class AirtimeReviewScreen extends StatelessWidget {
  const AirtimeReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewDetails =
        ModalRoute.of(context)?.settings.arguments as ReviewModel;
    return Scaffold(
      appBar: CustomAppbar(title: 'Review'),
      bottomNavigationBar: Container(
        color: ColorManager.kWhite,
        padding: EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: CustomButton(
            text: 'Continue to Pay ₦${reviewDetails.amount}',
            isActive: true,
            onTap: () {
              context.read<KeypadProvider>().setEnterPinEmpty();
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return CustomPinBottomSheet(reviewDetails: reviewDetails);
                  });
            },
            loading: false),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 24, left: 15, right: 15),
        child: Column(
          children: [
            if (reviewDetails.providerName != null)
              ReviewHeaderContainer(
                providerType: reviewDetails.providerType ?? "",
                providerName: reviewDetails.providerName ?? "",
                logo: reviewDetails.logo ?? "",
                onChange: reviewDetails.onChangeProvider,
              ),
            SummaryContainer( summaryItem: reviewDetails.summaryItems)
          ],
        ),
      ),
    );
  }
}

class CustomPinBottomSheet extends StatelessWidget {
  const CustomPinBottomSheet({super.key, required this.reviewDetails});
  final ReviewModel reviewDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: ColorManager.kWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confirm Payment',
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
            Gap(24),
           
            Text(
              'Enter PIN Code',
              style: get16TextStyle().copyWith(fontWeight: FontWeight.w500),
            ),
            CustomKeyPadInputBox(),
            Gap(5),
            Text(
              'Enter your 4-digit security PIN',
              style: get12TextStyle(),
            ),
             BiometricCard(),
            CustomKeyPad(
                onPinComplete: (pin) {
                  reviewDetails.onPinCompleted(pin);
                },
                onSuccessfulBiometric: (token) {})
          ],
        ),
      ),
    );
  }
}
