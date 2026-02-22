import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/bank_controller.dart';
import 'package:dataplug/core/providers/general_controller.dart';
import 'package:dataplug/core/providers/wallet_controller.dart';
import 'package:dataplug/core/utils/app-loader.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/core/utils/nav.dart';
import 'package:dataplug/core/utils/review_bottomsheet.dart';
import 'package:dataplug/core/utils/summary_info.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_bottom_sheet.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/select_bank.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:dataplug/presentation/screens/dashboard/services/airtime/buy_airtime_1.dart';
import 'package:dataplug/presentation/screens/dashboard/wallet/transfer/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletController>().clearData();
      final controller = context.read<BankController>();

      if (controller.bankList.isEmpty) {
        controller.getBankList();
      }
      controller.clearData();
    });
    super.initState();
  }

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
  @override
  Widget build(BuildContext context) {
    final walletController = context.watch<WalletController>();
    return Scaffold(
      appBar: CustomAppbar(title: 'Withdraw'),
      bottomNavigationBar: CustomBottomNavBotton(
          text: 'Continue',
          onTap: () {
            final controller = context.read<BankController>();
            if (controller.bankInfoErrMsg != null) {
              showCustomToast(
                context: context,
                // meesage
                description: "Please enter a valid bank details",
              );
              return;
            }
            final useAbleAmount = formatUseableAmount(walletController.amountController.text.trim());
            num amount = num.tryParse(useAbleAmount)??0;
            if (walletController.amountController.text.isEmpty || amount<1) {
              showCustomToast(
                context: context,
                // meesage
                description: "Please enter a valid amount",
              );
              return;
            }
           
            final generalController = context.read<GeneralController>();
              num serviceCharge = generalController.serviceCharge?.withdrawal??0;
              num totalAmount = calculateTotalAmount(amount: formatUseableAmount(
                        walletController.amountController.text.trim()), charge: serviceCharge);


            final summaryItems = [
              SummaryItem(
                  title: 'Bank Account Number',
                  name: controller.accountNumberController.text),
              SummaryItem(
                title: 'Bank Name',
                name: controller.attachedBankName??"",
                hasDivider: true,
              ),
              SummaryItem(
                  title: 'Withdrawal Amount',
                  name: walletController.amountController.text.trim()),
                  SummaryItem(
                    title: 'Withdrawal fee', name: formatCurrency(serviceCharge), hasDivider: true,),    
                SummaryItem(
                    title: 'Total Amount', name: formatCurrency(totalAmount)),  
                  
            ];
            final reviewDetails = ReviewModel(
                summaryItems: summaryItems,
                amount: formatUseableAmount(walletController.amountController.text),
                shortInfo: '',
                providerType: 'Electricity',
                
                
                onPinCompleted: (pin) async {
                  displayLoader(context);
                  walletController.withdraw(
                    pin,
                    onSuccess: (transactionInfo) {
                      popScreen();
                      final items = getSummaryItems(
                           transInfo:  transactionInfo, TransactionType.withdraw);
                      print('....able to get the summary items $items');
                      final review = ReceiptModel(
                          summaryItems: items,
                          amount: transactionInfo.amount.toString(),
                          shortInfo:
                              '${transactionInfo.meta.provider?.name ?? ""} Airtime');
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesManager.successful,
                          (Route<dynamic> route) => false,
                          arguments: review);
                    },
                    onError: (error) {
                      popScreen();
                      showCustomErrorTransaction(
                          context: context, errMsg: error);
                      },
                  );
                });

                showReviewBottomShhet(context, reviewDetails: reviewDetails);
          }),
      body: Consumer<BankController>(builder: (context, bankController, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    await showCustomBottomSheet(
                        context: context, screen: const SelectBank());
                  },
                  child: IgnorePointer(
                    child: CustomInputField(
                      formHolderName: "Bank Name",
                      hintText: "",
                      textInputAction: TextInputAction.next,
                      textEditingController: TextEditingController(
                          text: bankController.selectedBank?.name),
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: ColorManager.kFormHintText,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                CustomInputField(
                  formHolderName: "Bank Account Number",
                  hintText: "",
                  textInputAction: TextInputAction.next,
                  textEditingController: bankController.accountNumberController,
                  textInputType: TextInputType.number,
                  maxLength: 10,
                  counterText: "",
                  focusNode: bankController.focusNode,
                ),
                if (bankController.verifyingBankInfo)
                  CustomVerifying(text: 'Verifying bank info'),
                bankController.bankInfoErrMsg != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          bankController.bankInfoErrMsg!,
                          style: get12TextStyle().copyWith(
                            color: ColorManager.kError,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : bankController.attachedBankName != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              spacing: 8.w,
                              children: [
                                Container(
                                    height: 20.h,
                                    width: 20.w,
                                    //padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: ColorManager.kGreen,
                                      borderRadius:
                                          BorderRadiusGeometry.circular(6.r),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: ColorManager.kWhite,
                                      size: 20,
                                    )),
                                Text(
                                  bankController.attachedBankName!,
                                  style: get12TextStyle().copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: ColorManager.kGreen,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                Gap(20.h),
                AmountTextField(
                    controller: walletController.amountController,
                    onChanged: (amount) {
                      if(amount.isNotEmpty){
                        walletController.onAmountChanged(num.parse(amount));
                      }
                    }),
                Gap(20.h),
                AmountSuggestion(
                    selectedAmount: walletController.selectedSuggestedAmount,
                    onSelect: (amount) {
                      walletController.onSuggestedAmountSelected(amount);
                    },
                    suggestedAmounts: suggestedAmounts)
              ],
            ),
          ),
        );
      }),
    );
  }
}
