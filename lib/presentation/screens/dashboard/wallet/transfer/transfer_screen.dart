import 'package:dataplug/core/model/core/review_model.dart';
import 'package:dataplug/core/providers/betting_controller.dart';
import 'package:dataplug/core/providers/electricity_controller.dart';
import 'package:dataplug/core/providers/transfer_controller.dart';
import 'package:dataplug/core/utils/custom_verifying.dart';
import 'package:dataplug/core/utils/formatters.dart';
import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:dataplug/presentation/misc/custom_components/amount_suggestion.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_appbar.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_btn.dart';
import 'package:dataplug/presentation/misc/custom_components/custom_input_field.dart';
import 'package:dataplug/presentation/misc/custom_components/meter_selector.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_container.dart';
import 'package:dataplug/presentation/misc/custom_components/summary_item.dart';
import 'package:dataplug/presentation/misc/custom_snackbar.dart';
import 'package:dataplug/presentation/misc/route_manager/routes_manager.dart';
import 'package:dataplug/presentation/misc/style_manager/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    
  }

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: CustomAppbar(title: 'Wallet Transfer'),
        bottomNavigationBar: CustomBottomNavBotton(
            text: 'Continue',
            onTap: () {
              final controller = context.read<TransferController>();
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
      
               final summaryItems = [
                SummaryItem(title: 'Name', name: controller.attachedName ?? "Akanji Usman"),
                SummaryItem(
                  title: 'Phone Number',
                  name: "07067766333",
                  
                ),
                SummaryItem(
                  title: 'Attached Name',
                  name: controller.attachedName??'',
                  hasDivider: true,
                ),
                SummaryItem(
                    title: 'Transfer Amount', name: controller.amountController.text.trim()),
                SummaryItem(
                    title: 'Transfer fee', name: "₦0.00", hasDivider: true,),    
                // SummaryItem(
                //     title: 'Total Amount', name: controller.amountController.text.trim()),     
              ];
              final reviewModel = ReviewModel(
                  summaryItems: summaryItems,
                  amount: formatUseableAmount(controller.amountController.text),
                  shortInfo: 'Transfer',
                  onChangeProvider: () => Navigator.pushNamed(context, RoutesManager.electricityProviders,),
                  onPinCompleted: (pin) async {
                    print('...on pin completed $pin');
                    controller.transfer(pin, onError: (error) {
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
              Navigator.pushNamed(context, RoutesManager.reviewDetails,
                  arguments: reviewModel);
      
      
            }),
        body: Consumer<TransferController>(
            builder: (context, transferController, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 24, bottom: 30),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // dismisses keyboard
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                
                  Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputField(
                        formHolderName: 'Receiver info',
                        hintText: 'Username, email, or phone number',
                        focusNode: transferController.focusNode,
                        textEditingController:
                            transferController.beneficiaryController,
                      ),
                      transferController.verifyingBeneficiary
                          ? CustomVerifying(text: 'Verifying info...')
                          : !transferController.verifyingBeneficiary &&
                                  transferController.beneficiaryErrMsg != null
                              ? Text(
                                  transferController.beneficiaryErrMsg!,
                                  style: get14TextStyle()
                                      .copyWith(color: ColorManager.kError),
                                )
                              : SizedBox(),
                    ],
                  ),
                  
                  AmountTextField(
                    controller: transferController.amountController,
                    onChanged: (value) {
                      transferController.onAmountChanged(num.parse(value));
                    },
                  ),
                  AmountSuggestion(
                      selectedAmount:
                          transferController.selectedSuggestedAmount,
                      onSelect: (amount) {
                        transferController.onSuggestedAmountSelected(amount);
                      },
                      suggestedAmounts: suggestedAmounts)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AmountTextField extends StatelessWidget {
  const AmountTextField(
      {super.key, required this.controller, required this.onChanged});
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Amount',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              cursorHeight: 30,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
