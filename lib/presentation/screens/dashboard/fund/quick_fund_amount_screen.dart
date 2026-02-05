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

class QuickFundAmountScreen extends StatefulWidget {
  const QuickFundAmountScreen({super.key});

  @override
  State<QuickFundAmountScreen> createState() => _QuickFundAmountScreenState();
}

class _QuickFundAmountScreenState extends State<QuickFundAmountScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<WalletController>().clearData();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final List<String> suggestedAmounts = [
      '1000',
      '1500',
      '2000',
      '3000',
      '5000',
      '10000',
      '20000',
      '30000'
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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
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
            ),
          ),
        );
      }
    );
  }
}
