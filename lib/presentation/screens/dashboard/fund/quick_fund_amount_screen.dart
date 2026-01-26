import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_textfield.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuickFundAmountScreen extends StatelessWidget {
  const QuickFundAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestedAmounts = [
      '500',
      '1000',
      '1500',
      '2000',
      '3000',
      '5000',
      '10000',
      '20000'
    ];
    return Consumer<WalletController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: CustomAppbar(title: 'Quick Fund'),
          bottomNavigationBar: CustomBottomNavBotton(text: 'Continue', onTap: (){
            if (controller.amountController.text.isEmpty ||
                  num.parse(formatUseableAmount(controller.amountController.text)) <= 0) {
                showCustomToast(
                  context: context,
                  // meesage
                  description:
                      "Please enter a valid amount",
                );
                return;

              }

              pushNamed(RoutesManager.addFundPaymentMethods);
          }),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Column(
              spacing: 20.h,
              children: [
                AmountTextField(
                  controller: controller.amountController,
                  onChanged: (value) {
                    controller.onAmountChanged(num.parse(value));
                  },
                ),
                AmountSuggestion(
                          selectedAmount: controller.selectedSuggestedAmount,
                          onSelect: (amount) {
                            controller.onSuggestedAmountSelected(amount);
                          },
                          suggestedAmounts: suggestedAmounts)
              ],
            ),
          ),
        );
      }
    );
  }
}
